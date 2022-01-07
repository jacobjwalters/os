; Single processor kernel
; This is a basic Forth-like interpreter.

; TODO:
; Load in code from higher adddresses

%define COM1	0x3f8

%include "boot.asm"

stage2:

.picsetup:
	cli

	in al, 0x21	; Save masks
	mov bl, al
	in al, 0xa1
	mov bh, al

	mov al, 0x11	; PIC initialisation command
	out 0x20, al
	out 0xa0, al

	mov al, 0x20	; Master PIC mapped to 0x20-0x27 in IDT
	out 0x21, al
	mov al, 0x28	; Master PIC mapped to 0x28-0x2f in IDT
	out 0xa1, al

	mov al, 0x04	; Tell master there's a slave on IRQ2
	out 0x21, al
	mov al, 0x02	; Tell slave to cascade through its IRQ1 line
	out 0xa1, al

	mov al, 0x01	; Tell PICs to operate in 8086/88 mode
	out 0x21, al
	out 0xa1, al

	;mov al, bl	; Restore masks
	mov al, 0xff	; Disable interrupts for now
	out 0x21, al
	;mov al, bh
	mov al, 0xff
	out 0xa1, al

.sersetup:
	mov al, 0x01	; Disable interrupts apart from data ready
	mov dx, COM1+1
	out dx, al
	mov al, 0x80	; Enable DLAB (in order to set baud rate)
	mov dx, COM1+3
	out dx, al
	mov al, 0x01	; Set divisor to 1 (=115200bps)
	mov dx, COM1
	out dx, al
	mov al, 0x00
	mov dx, COM1+1
	out dx, al
	mov al, 0x03	; Set parity to 8N1 (and clear DLAB)
	mov dx, COM1+3
	out dx, al
	mov al, 0x27	; Enable FIFO buffer and set to interrupt on one byte
	mov dx, COM1+2
	out dx, al
	mov al, 0x0b	; IRQs enabled, RTS/DTR set
	mov dx, COM1+4
	out dx, al

	sti

main:
	call clearscr
	mov rsi, tstMsg
	call printstr
	jmp start

tstMsg:
	db "Hello, world! We're running in 64 bit mode! ",0

;
;  SCREEN UTILITIES
;
clearscr:
	mov rdi, 0xb8000
	mov rcx, 500  ; / by 4 as we clear 8 bytes at once
	mov rax, 0xf120f120f120f120
	rep stosq
	mov rdi, 0xb8000
	ret
printchar:  ; char in al  -- no register saving as this is for performance - clobbers rax!
	mov ah, 0xf1
	mov [rdi], ax
	inc rdi
	inc rdi
	ret
printstr:  ; ptr to str in rsi
	push rax
.loop:
		lodsb
		or al, al
		jz .printend
		call printchar
		jmp .loop
.printend:
	pop rax
	ret

align 512		; sector align
%include "idt.asm"	; takes 4096 bytes
%include "isr.asm"

%include "interpreter.asm"


;
; DATA SECTION
;

serBuffer:	; serial receive buffer
	resb 256

kbBuffer:
	resb 256	; reserve 256 bytes for keyboard buffer
end:
