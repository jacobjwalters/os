; This file contains the interrupt handlers as called by the IDT.

; Intel reserved interrupts
isr_00:	; Divide by zero
	mov dword [gs:0xb8000],'/@0@'
	iretq
isr_01:	; Debug
	mov dword [gs:0xb8000],'D@B@'
	iretq
isr_02:	; NMI
	mov dword [gs:0xb8000],'N@M@'
	iretq
isr_03:	; Breakpoint
	mov dword [gs:0xb8000],'B@P@'
	iretq
isr_04:	; Overflow
	mov dword [gs:0xb8000],'O@V@'
	iretq
isr_05:	; Bound range exceeded
	mov dword [gs:0xb8000],'B@R@'
	iretq
isr_06:	; Invalid opcode
	mov dword [gs:0xb8000],'O@P@'
	cli
	hlt
	iretq
isr_07:	; Device not available
	mov dword [gs:0xb8000],'D@E@'
	iretq
isr_08:	; Double fault
	pop r11		; Get error code into r11
	mov dword [gs:0xb8000],'D@F@'
	iretq
isr_09:	; Coprocessor Segment Overrun (deprecated, triggered only by bad PIC)
	mov dword [gs:0xb8000],'C@S@'
	iretq
isr_0a:	; Invalid TSS
	pop r11		; Get error code into r11
	mov dword [gs:0xb8000],'T@S@'
	iretq
isr_0b:	; Segment not present
	pop r11		; Get error code into r11
	mov dword [gs:0xb8000],'S@!@'
	iretq
isr_0c:	; Stack-segment fault
	pop r11		; Get error code into r11
	mov dword [gs:0xb8000],'S@S@'
	iretq
isr_0d:	; General Protection Fault
	pop r11		; Get error code into r11
	mov dword [gs:0xb8000],'G@P@'
	cli
	hlt
	iretq
isr_0e:	; Page fault
	pop r11		; Get error code into r11
	mov dword [gs:0xb8000],'P@F@'
	cli
	hlt
	iretq
isr_0f:	; RESERVED
	mov dword [gs:0xb8000],'r@e@'
	iretq
isr_10:	; x87 Floating Point Exception
	mov dword [gs:0xb8000],'F@P@'
	iretq
isr_11:	; Alignment check
	pop r11		; Get error code into r11
	mov dword [gs:0xb8000],'E@x@'
	iretq
isr_12:	; Machine Check
	mov dword [gs:0xb8000],'M@C@'
	iretq
isr_13:	; SIMD Floating Point Exception
	mov dword [gs:0xb8000],'S@F@'
	iretq
isr_14:	; Virtualisation Excpetion
	mov dword [gs:0xb8000],'V@T@'
	iretq
isr_15:	; RESERVED
isr_16:	; RESERVED
isr_17:	; RESERVED
isr_18:	; RESERVED
isr_19:	; RESERVED
isr_1a:	; RESERVED
isr_1b:	; RESERVED
isr_1c:	; RESERVED
isr_1d:	; RESERVED
	mov dword [gs:0xb8000],'r@e@'
	iretq
isr_1e:	; Security Exception
	pop r11		; Get error code into r11
	mov dword [gs:0xb8000],'S@E@'
	iretq
isr_1f:	; RESERVED
	mov dword [gs:0xb8000],'r@e@'
	iretq

; PIC 1
isr_20:	; PIT  - currently just ignored
	mov al, 0x20
	out 0x20, al
	iretq
isr_21:	; Keyboard
	;mov dword [gs:0xb8000],'k5b5'
	;mov al, 0x20
	;out 0x20, al
	;iretq
	cli
	hlt

	in al, 0x64     ; read status from kb
	and al, 1	; check there's data to be read
	je .done

	in al, 0x60	; read keycode from kb
	and al, 0x80
	je .low		; i.e. shift pressed
	mov al, 0x51
.low:	mov al, 0x71
.print	mov ah, 0x1f
	mov [gs:0xb8000], ax
.done:	mov al, 0x20
	out 0x20, al
	sti
	iretq
isr_22:	; Cascade (never raised)
isr_23:	; COM2
	mov al, 0x20
	out 0x20, al
	iretq
isr_24:	; COM1
	mov dword [gs:0xb8000],'sCeC'
	mov al, 0x20
	out 0x20, al
	iretq
isr_25:	; LPT2
isr_26:	; Floppy
isr_27:	; LPT1 (raises spurious IRQs)
	mov al, 0x20
	out 0x20, al
	iretq

; PIC 2
isr_28:	; CMOS RTC
isr_29:	; free
isr_2a:	; free
isr_2b:	; free
isr_2c:	; PS/2 mouse
isr_2d:	; FPU coprocessor (shouldn't be triggered post-486)
isr_2e:	; Primary ATA disk
isr_2f:	; Secondary ATA disk
	mov al, 0x20
	out 0x20, al
	out 0xa0, al
	iretq

isr_30:
isr_31:
isr_32:
isr_33:
isr_34:
isr_35:
isr_36:
isr_37:
isr_38:
isr_39:
isr_3a:
isr_3b:
isr_3c:
isr_3d:
isr_3e:
isr_3f:
isr_40:
isr_41:
isr_42:
isr_43:
isr_44:
isr_45:
isr_46:
isr_47:
isr_48:
isr_49:
isr_4a:
isr_4b:
isr_4c:
isr_4d:
isr_4e:
isr_4f:
isr_50:
isr_51:
isr_52:
isr_53:
isr_54:
isr_55:
isr_56:
isr_57:
isr_58:
isr_59:
isr_5a:
isr_5b:
isr_5c:
isr_5d:
isr_5e:
isr_5f:
isr_60:
isr_61:
isr_62:
isr_63:
isr_64:
isr_65:
isr_66:
isr_67:
isr_68:
isr_69:
isr_6a:
isr_6b:
isr_6c:
isr_6d:
isr_6e:
isr_6f:
isr_70:
isr_71:
isr_72:
isr_73:
isr_74:
isr_75:
isr_76:
isr_77:
isr_78:
isr_79:
isr_7a:
isr_7b:
isr_7c:
isr_7d:
isr_7e:
isr_7f:
isr_80:
isr_81:
isr_82:
isr_83:
isr_84:
isr_85:
isr_86:
isr_87:
isr_88:
isr_89:
isr_8a:
isr_8b:
isr_8c:
isr_8d:
isr_8e:
isr_8f:
isr_90:
isr_91:
isr_92:
isr_93:
isr_94:
isr_95:
isr_96:
isr_97:
isr_98:
isr_99:
isr_9a:
isr_9b:
isr_9c:
isr_9d:
isr_9e:
isr_9f:
isr_a0:
isr_a1:
isr_a2:
isr_a3:
isr_a4:
isr_a5:
isr_a6:
isr_a7:
isr_a8:
isr_a9:
isr_aa:
isr_ab:
isr_ac:
isr_ad:
isr_ae:
isr_af:
isr_b0:
isr_b1:
isr_b2:
isr_b3:
isr_b4:
isr_b5:
isr_b6:
isr_b7:
isr_b8:
isr_b9:
isr_ba:
isr_bb:
isr_bc:
isr_bd:
isr_be:
isr_bf:
isr_c0:
isr_c1:
isr_c2:
isr_c3:
isr_c4:
isr_c5:
isr_c6:
isr_c7:
isr_c8:
isr_c9:
isr_ca:
isr_cb:
isr_cc:
isr_cd:
isr_ce:
isr_cf:
isr_d0:
isr_d1:
isr_d2:
isr_d3:
isr_d4:
isr_d5:
isr_d6:
isr_d7:
isr_d8:
isr_d9:
isr_da:
isr_db:
isr_dc:
isr_dd:
isr_de:
isr_df:
isr_e0:
isr_e1:
isr_e2:
isr_e3:
isr_e4:
isr_e5:
isr_e6:
isr_e7:
isr_e8:
isr_e9:
isr_ea:
isr_eb:
isr_ec:
isr_ed:
isr_ee:
isr_ef:
isr_f0:	; Forth Data Stack Underflow
	mov dword [gs:0xb8000],'d u '
	iretq
isr_f1: ; Forth Return Stack Underflow
	mov dword [gs:0xb8000],'r u '
	iretq
isr_f2:	; Forth debugging interrupt
	mov dword [gs:0xb8000],'f i '
	iretq
isr_f3:	; Forth halting debugging interrupt
	mov dword [gs:0xb8000],'f h '
	cli
	hlt
isr_f4:	; Forth interactive halting debugging interrupt
	cmp qword [var_src_id], 0
	je .hlt
	iretq
.hlt:
	mov dword [gs:0xb8000],'f s '
	cli
	hlt
isr_f5:
isr_f6:
isr_f7:
isr_f8:
isr_f9:
isr_fa:
isr_fb:
isr_fc:
isr_fd:	; Forth invalid number
	mov dword [gs:0xb8000],'i n '
	cli
	hlt
	iretq
isr_fe:	; Forth invalid word
	mov dword [gs:0xb8000],'i w '
	iretq
isr_ff:	; Forth reset
	mov dword [gs:0xb8000],'r e '
	iretq
