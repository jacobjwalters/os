; This code directly enters long mode without entering protected mode
; Add TSS to GDT if neccessary
; Enable CPU features (SSE, AVX etc.)

; Page Table structure:
; 0x1000 - PML4T
; 0x2000 - PDPT
; 0x3000 - PDT
; 0x4000 - PT



; The CPU begins execution in 16 bit mode. The first sector of the disk is
; loaded into memory at 0x7c00 and is then executed. Here, ip=7c00.
org 0x7c00
bits 16

bootloader:
	; Set a default state (BIOS may leave garbage in the registers)
	cli
	xor bx, bx
	mov es, bx
	mov fs, bx
	mov gs, bx
	mov ds, bx
	mov ss, bx
	mov sp, 0x7c00		; Stack grows down from 0x7c00
	sti			; Re-enable interrupts

	jmp 0:.clear_cs		; Ensure we address as [0000:7c00]
.clear_cs:

	; Set graphics mode 0x12 (680*480*16)
	mov ax, 0x0012		; ah=0, al=desired mode
	int 0x10		; Set mode

	; Load long mode code from disk into memory
	mov ax, 0x023f		; function 0x02, load 0x3f sectors
	mov bx, 0x7e00		; es:bx = position to load to
	mov cx, 0x0002		; cx = cylinder and sector
	xor dh, dh		; dx = head and drive number (0x00 is A:)
	int 0x13
	
	mov ax,0x023f
	mov bx, (0x7e00+0x200*0x3f)
	mov dh, 0x01
	int 0x13

	; Indicate to BIOS we want to use long mode only
	mov ax, 0xec00
	mov bl, 0x02
	int 0x15

	; Simple A20 high (TODO: check if supported)
	mov ax, 0x2401
	int 0x15

	;;; Build page tables
	; Clear the memory for the tables
	mov di, 0x1000		; Tables start at 0x1000
	mov cr3, edi
	xor ax, ax
	mov cx, 0x1000		; Repeat 4096 times
	rep stosd		; Zero out page tables
	mov edi, cr3		; Point back to 0x1000

	; Table declaration
	mov DWORD [edi], 0x2003
	add edi, 0x1000
	mov DWORD [edi], 0x3003
	add edi, 0x1000
	mov DWORD [edi], 0x4003
	add edi, 0x1000

	; Identity map the first 2MB
	mov ebx, 0x0003
	mov ecx, 0x0200
.setEntry:
		mov DWORD [edi], ebx
		add ebx, 0x1000
		add edi, 0x0008
	loop .setEntry

	; Enter long mode
	mov eax, 0x00a0		; Enable PAE and PGE (bits 5 & 7)
	mov cr4, eax

	mov edx, 0x1000		; Load ptr to PML4T into CR3
	mov cr3, edx

	mov ecx, 0xC0000080	; Specify EFER MSR
	rdmsr	; Enable long mode
	or eax, 0x0100
	wrmsr

	mov ebx, cr0		; Activate long mode
	or ebx, 0x80000001
	mov cr0, ebx

	lgdt [gdt.pointer]	; Load GDT below
	lidt [idtpointer]	; Load IDT below
	jmp gdt.code:stage2	; Jump to long mode code

;;; Global Descriptor Table
;Here we mark the first 4GiB of mem as r/w/x effectively
gdt:
	dq 0			; Null descriptor
.code: equ $-gdt
	;gdtentry 0x00af, 0x9a00, 0x0000, 0xffff
	dq 0x00209a0000000000
.data: equ $-gdt
	;gdtentry 0x008f, 0x9200, 0x0000, 0xffff
	dq 0x0000920000000000
.pointer:
	dw $-gdt-1		; 16 bit size (limit)
	dq gdt			; 64-bit base addr

;;; IDT Pointer
idtpointer:
	dw 0x1000
	dq idt

times 510-($-bootloader) db 0	; Fill boot sector
dw 0xaa55			; Mark bootable
bits 64
