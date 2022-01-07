; This file contains the meat of the Forth interpreter. It loads in at start:
; and proceeds to enter the interpreter loop.

;; REGISTER MAPS
%define ip	rsi	; points to next word to be executed
%define dstackp	rsp	; data stack pointer
%define ds_top	r8	; top of data stack
%define ds_topb	r8b	; low byte of top of data stack
%define rstackp	rbp	; return stack pointer

; r12-r15 are interpreter variables
; r12 = n_ds
; r13 = n_rs
; r14 = state
; r15 = here

; All other registers are scratch


;;; TODO
; Use cmov in conditionals


bits 64

;; INTERNAL VARIABLES
%define COM1		0x3f8
%assign link		0	; Internal LATEST used by assembler
%define WORDBUFLEN	64	; Maximum length of a word
%define TIBSZ	256	; Maximum length of line for ACCEPT
%define RSBEGIN		freemem+0x10000	; Top of RS (grows downwards)


;; MACROS
%macro NEXT 0
	lodsq				; mov rax, rip; add rip, 8
	jmp [rax]
%endmacro

; Data stack macros
%macro PUSHDS 1
	test n_ds, n_ds
	je %%none
	push ds_top
%%none: ;%ifnidn %1, ds_top
		mov ds_top, %1
	;%endif
	inc n_ds
%endmacro
%macro POPDS 1
	cmp n_ds, 1
	je %%only1
	ja %%cont
	call ds_underflow
%%only1:
	mov %1, ds_top
	jmp %%done
%%cont:	mov %1, ds_top
	pop ds_top
%%done: dec n_ds
%endmacro

; Return stack macros
%macro PUSHRS 1
	;lea rstackp, [rstackp-8]
	sub rstackp, 8
	mov [rstackp], %1
	inc n_rs
%endmacro
%macro POPRS 1
	test n_rs, n_rs
	je rs_underflow
	mov %1, [rstackp]
	;lea rstackp, [rstackp+8]
	add rstackp, 8
	dec n_rs
%endmacro

%macro DEFFWORD 2-3 0		; Define Forth word: name, label, flags=0
	align 8
name_%2:
	dq link			; point to previous entry and update LATEST
	%define link name_%2
	%strlen WORDLEN %1
	db WORDLEN | %3		; namelen + flags
	db %1			; store name
	align 8			; zero-pad name
$%2:
	dq docol		; codeword to execute a Forth definition
	; follow macro decl. with series of word pointers
%endmacro

%macro DEFAWORD 2-3 0		; Define Assembly word: name, label, flags=0
	align 8
name_%2:
	dq link			; point to previous entry and update LATEST
	%define link name_%2
	%strlen WORDLEN %1
	db WORDLEN | %3		; namelen + flags
	db %1			; store name
	align 8			; zero-pad name
$%2:				; The $ is to distinguish from x86 instructions
	dq code_%2
code_%2:
	; follow macro decl. with assembly code ending with NEXT
%endmacro

%macro DEFCONST 3-4 0		; Define constant: name, label, value, flags=0
	DEFAWORD %1, %2, %4
		PUSHDS %3
	NEXT
%endmacro

%macro DEFVAR 2-4 0, 0		; Define variable: name, label, value=0, flags=0
	DEFAWORD %1, %2, %4
		PUSHDS var_%2	; Push pointer to variable
	NEXT
	align 8
	var_%2: dq %3
%endmacro

%macro DEFRVAR 3-4 0		; DEFVAR, but in regs; name, label, reg, flags=0
	%define %2 %3
	DEFAWORD %1, %2, %4
		PUSHDS %3	; BEWARE - Only pushes value, not pointer!
	NEXT
%endmacro


;; DEFINITIONS
; Variables and Constants

DEFRVAR "#DS", n_ds, r12
DEFRVAR "#RS", n_rs, r13
DEFRVAR "STATE", state, r14
DEFRVAR "HERE", here, r15

DEFVAR "SP0", sp0
DEFVAR "BASE", base, 10
DEFVAR "LATEST", latest, name_last
; SOURCE defined later
DEFVAR "SOURCE-ID", src_id		; 0=user input, -1=string in SOURCE
DEFVAR ">IN", to_in			; Number of chars read from SOURCE

DEFCONST "F_IMM", f_imm, 0x80
%define F_IMM 0x80
DEFCONST "F_HIDDEN", f_hidden, 0x40
%define F_HIDDEN 0x40
DEFCONST "F_LENMASK", f_lenmask, 0x3f
%define F_LENMASK 0x3f
DEFCONST "DOCOL", ptr_docol, docol
DEFCONST "RP0", rp0, RSBEGIN

; These are required as registers can't be accessed in the same manner as memory
DEFAWORD "STATE@", state_fetch	; Fetches state
	PUSHDS state
NEXT
DEFAWORD "STATE!", state_store	; Stores state
	POPDS state
NEXT
DEFAWORD "HERE@", here_fetch	; Fetches here
	PUSHDS here
NEXT
DEFAWORD "HERE!", here_store	; Stores here
	POPDS here
NEXT

; Essentials
DEFAWORD "EXIT", exit
	POPRS ip
NEXT
DEFAWORD "LIT", lit
	lodsq
	PUSHDS rax
NEXT
DEFAWORD "LITSTRING", litstring	; compile counted string
	lodsq			; Get string
	PUSHDS ip		; Push address
	PUSHDS rax		; Push length
	add ip, rax		; Skip the string
	add ip, 7		; Round up to 8-byte boundary
	and ip, ~7
NEXT


; Stack primitives
DEFAWORD "DROP", drop
	POPDS ds_top
NEXT
DEFAWORD "DUP", dup
	PUSHDS ds_top
NEXT
DEFAWORD "SWAP", swap
	xchg ds_top, [dstackp]
NEXT
DEFAWORD "OVER", over
	PUSHDS [dstackp+8]
NEXT
DEFAWORD "ROT", rot
	xchg ds_top, [dstackp]
	xchg ds_top, [dstackp+8]
NEXT
DEFAWORD "-ROT", nrot
	xchg ds_top, [dstackp+8]
	xchg ds_top, [dstackp]
NEXT
DEFAWORD "2DROP", 2drop
	POPDS ds_top
	POPDS ds_top
NEXT
DEFAWORD "2DUP", 2dup
	mov rax, ds_top
	mov rbx, [dstackp]
	PUSHDS rbx
	PUSHDS rax
NEXT
DEFAWORD "2SWAP", 2swap
	POPDS rax
	POPDS rbx
	POPDS rcx
	PUSHDS rax
	PUSHDS ds_top
	PUSHDS rcx
	mov rbx, ds_top
NEXT
DEFAWORD "2OVER", 2over
	PUSHDS [dstackp+24]
	PUSHDS [dstackp+24]
NEXT
DEFAWORD "?DUP", qdup
	test ds_top, ds_top
	jz .else
		PUSHDS ds_top
	.else:
NEXT

; Arithmetic
DEFAWORD "1+", incr
	inc ds_top
NEXT
DEFAWORD "1-", decr
	dec ds_top
NEXT
DEFAWORD "CELL", cell
	PUSHDS 8
NEXT
DEFAWORD "CELL+", celli
	add ds_top, 8
NEXT
DEFAWORD "CELL-", celld
	sub ds_top, 8
NEXT
DEFAWORD "+", add
	POPDS rax
	add ds_top, rax
NEXT
DEFAWORD "-", sub
	POPDS rax
	sub ds_top, rax
NEXT
DEFAWORD "*", mul
	POPDS rax
	imul ds_top, rax
NEXT
DEFAWORD "/MOD", divmod		; ( a b -- a/b r )
	POPDS rbx
	POPDS rax
	cqo			; fills rdx with the value of bit 63 of rax
	idiv rbx
	PUSHDS rdx		; Remainder
	PUSHDS rax		; Quotient
NEXT
DEFAWORD "2*", 2mul
	sal ds_top, 1
NEXT
DEFAWORD "2/", 2div
	sar ds_top, 1
NEXT
DEFAWORD "U2*", u2mul
	shl ds_top, 1
NEXT
DEFAWORD "U2/", u2div
	shr ds_top, 1
NEXT

; Comparisons
%macro DEFCMP 2		; name, condition
	DEFAWORD %1, cmp_%+2
		xor rax, rax
		POPDS rbx
		cmp ds_top, rbx
		j%-2 %%done
		not rax
	%%done	mov ds_top, rax
	NEXT
%endmacro
%macro DEFTEST 2	; name, condition
	DEFAWORD %1, cmp_0%+2
		xor rax, rax
		test ds_top, ds_top
		j%-2 %%done
		not rax
	%%done	mov ds_top, rax
	NEXT
%endmacro
DEFCMP "=", e
DEFCMP "<>", ne
DEFCMP "<", l
DEFCMP ">", g
DEFCMP "<=", le
DEFCMP ">=", ge
DEFTEST "0=", e
DEFTEST "0<>", ne
DEFTEST "0<", l
DEFTEST "0>", g
DEFTEST "0<=", le
DEFTEST "0>=", ge

; Bitwise
DEFAWORD "AND", and
	POPDS rax
	and ds_top, rax
NEXT
DEFAWORD "OR", or
	POPDS rax
	or ds_top, rax
NEXT
DEFAWORD "XOR", xor
	POPDS rax
	xor ds_top, rax
NEXT
DEFAWORD "INVERT", invert
	not ds_top
NEXT
DEFAWORD "<<", lshift
	POPDS rax
	inc rax
.loop:
	dec rax
	jbe .done
	rcl ds_top, 1
	jmp .loop
.done:
NEXT
DEFAWORD ">>", rshift
	POPDS rax
	inc rax
.loop:
	dec rax
	jbe .done
	rcr ds_top, 1
	jmp .loop
.done:
NEXT

; Memory
DEFAWORD "!", store
	POPDS rax
	POPDS rbx
	mov [rax], rbx
NEXT
DEFAWORD "@", fetch
	mov ds_top, [ds_top]
NEXT
DEFAWORD "+!", add_store
	POPDS rax
	POPDS rbx
	add [rax], rbx
NEXT
DEFAWORD "-!", sub_store
	POPDS rax
	POPDS rbx
	sub [rax], rbx
NEXT
DEFAWORD "C!", cstore
	POPDS rax
	POPDS rbx
	mov [rax], bl
NEXT
DEFAWORD "C@", cfetch
	mov ds_top, [ds_top]
	and ds_top, 0xff
NEXT
DEFAWORD "C@C!", ccopy
	mov rax, ip	; Save ip as it's in rsi which is needed
	mov rdi, ds_top
	POPDS rsi
	movsb
	PUSHDS rsi
	mov ds_top, rdi
	mov ip, rax
NEXT
DEFAWORD "CMOVE", cmove
	mov rax, ip	; Save ip as it's in rsi which is needed
	mov rcx, ds_top
	POPDS rdi
	POPDS rsi
	rep movsb
	POPDS ds_top
	mov ip, rax
NEXT
DEFAWORD "FILL", fill	; ( addr u n -- ) fill u bytes starting from addr with n
	mov rbx, ip	; Save ip as it's in rsi which is needed
	POPDS rax
	POPDS rcx
	POPDS rdi
	rep stosb
	mov ip, rbx
NEXT

; Inter-stack manipulation
DEFAWORD ">R", to_r
	PUSHRS ds_top
	POPDS ds_top
NEXT
DEFAWORD "R>", from_r
	PUSHDS ds_top
	POPRS ds_top
NEXT
DEFAWORD "RDROP", rdrop
	add rstackp, 8
NEXT
DEFAWORD "RPICK", rpick
	shl ds_top, 3			; Multiply by 8 for cell size
	add ds_top, rstackp		; Offset for rstack
	mov ds_top, qword [ds_top]		; Get value
NEXT
DEFAWORD "RP@", rp_fetch
	PUSHDS rstackp
NEXT
DEFAWORD "RP!", rp_store
	POPDS rstackp
NEXT
DEFAWORD "SP@", sp_fetch
	PUSHDS dstackp
NEXT
DEFAWORD "SP!", sp_store
	POPDS dstackp
NEXT

; I/O
DEFAWORD "EOF?", eofq		; Returns true if at end of file
	call _eofq
	PUSHDS rax
	and ds_top, 0xff
	dec ds_top		; -1 if EOF, 0 if not
	neg ds_top
NEXT
_eofq:
	mov rbx, [var_to_in]	; Get current index into file
	cmp rbx, fileend-filestart	; Are we past the end?
	setge al		; 1 if EOF, 0 if not
	ret			; rax=F_EOF, rbx=index
DEFAWORD "FILEKEY", filekey	; Gets char from file
	call _filekey
	PUSHDS rcx
	and ds_top, 0xff
NEXT
_filekey:
	call _eofq		; Gets count and checks if EOF reached
	mov [var_src], al	; Update SOURCE once EOF reached
	jge .done
	mov cl, byte [filestart+rbx]
	inc rbx			; Update >IN
	mov qword [var_to_in], rbx
.done:	ret
DEFAWORD "SKEY", skey		; Get key from serial
	call _skey
	PUSHDS rcx
	and ds_top, 0xff
NEXT
_skey:	; Return byte in cl
	mov rdx, COM1+5
.poll:	in al, dx		; Poll until there is data to read
	and al, 0x01
	je .poll
	mov dx, COM1		; Receive byte
	in al, dx
	mov cl, al
	ret

DEFAWORD "KEY", key		; Gets char from SOURCE
	call _key
	PUSHDS rcx
	and ds_top, 0xff
NEXT
_key:	; Returns char in cl
	cmp qword [var_src_id], 0
	je _skey		; Get char from serial if we're in usermode
	jmp _getchar		; Get char from source
DEFAWORD "SEMIT", semit		; Serial emit
	POPDS rcx
	call _semit
NEXT
_semit:
	mov rdx, COM1+5
.poll:	in al, dx		; Poll until the transit buffer is empty
	and al, 0x20
	je .poll
	mov dx, COM1		; Transmit byte
	mov al, cl
	out dx, al
	cmp cl, 0x0d		; If CR, send LF too
	jne .done
	mov cl, 0x0a
	jmp _semit
.done:	ret
DEFAWORD "WORD", wword		; extra w to avoid conflict with reserved asm
	call _word
	PUSHDS rdi		; ( -- addr len )
	PUSHDS rcx
NEXT
_getchar:			; Get next char from SOURCE
	mov rax, [var_nsrc]	; If buffer fully read, return null
	cmp rax, [var_to_in]
	jle .full
	mov rax, [var_src]	; Find start of buffer
	add rax, [var_to_in]	; Find current character
	mov cl, byte [rax]	; And copy it
	inc qword [var_to_in]	; Incrementing the pointer
	ret
.full:
	mov cl, 0xff
	ret
_word:
	call _getchar
	cmp cl, ' '
	jbe _word
	cmp cl, 0xff		; If 0xff is encountered, we're done
	je .endfile

	mov rdi, wordbuf
.loop:		mov al, cl
		stosb		; mov [rdi], al; inc rdi
		call _getchar
		cmp cl, ' '	; If a given char is whitespace, we're done
		jbe .done
		cmp cl, 0xff	; If 0xff, we're done
		je .done
		;cmp rdi, wordbuf+WORDBUFLEN-17	; -1 for print mechanism
		cmp rdi, wordbuf+WORDBUFLEN-1	; -1 for print mechanism
		jae .done	; If we're above the WORDBUFLEN, we're done
		jmp .loop	; Otherwise, get another char
.done:	mov rax, wordbuf
	mov byte [rdi], 0	; Fix for print mechanism
	sub rdi, rax
	mov rcx, rdi		; rcx contains length
	mov rdi, rax		; rdi contains addr of wordbuf
	ret
.endfile:			; If end of file reached (TODO: length check)
	mov rcx, 0		; 0 length
	mov rdi, wordbuf	; Point to wordbuf
	ret

DEFAWORD "\", comment, F_IMM	; Skip until newline
.loop:
	call _key
	cmp cl, 0x0a
	je .done
	cmp cl, 0xff		; TODO: replace with length check
	je .done
	jmp .loop
.done:
NEXT

DEFAWORD "NUMBER", number
	POPDS rcx		; namelen
	POPDS rdi		; nameaddr
	call _number
	PUSHDS rax		; Numeric value
	PUSHDS rcx		; Error code
NEXT
_number:			; rdi=nameaddr, rcx=namelen
	xor rax, rax		; rax=accumulator, final value
	xor rbx, rbx		; rbx=current char/digit
	xor r9, r9		; r9=negative flag
	test rcx, rcx		; If string length is 0, return error code
	je .error
	mov rdx, [var_base]
	; Check if first char is '-' for -ve numbers
	mov bl, [rdi]		; bl=char
	inc rdi			; Move to next char
	cmp bl, '-'
	sete r9b		; Flag to tell later if we need to negate rax
	jne .parsedigits
	dec rcx
	jz .error		; Error if string is only "-"
.loop:
	imul rax, rdx		; Mult by base to make room for next digit
	mov bl, [rdi]		; Read byte
	inc rdi
.parsedigits:
	sub bl, '0'		; < '0' : invalid char
	jb .error
	cmp bl, 10		; <= '9' : check if numeric character
	jb .base
	and bl, 0xdf		; Simple touppper (0b11011111)
	sub bl, 'A'-'0'		; < 'A' : invalid char
	jb .error
	cmp bl, 'Z'-'0'		; > 'Z' : invalid char
	ja .error
	add bl, 10		; Add 10 to offset the 0-9 chars
.base:
	cmp bl, dl		; If val above base, then break (rdx=base)
	;jge .break		; TODO: should be to .error?
	jge .error
	add rax, rbx		; Accumulate the char value into the total
	dec rcx			; Decrease number of chars
	jnz .loop		; If zero chars left, we're done
.break:
	test r9b, r9b
	je .done
	neg rax
.done:
	ret
.error:
	;int 0xfd
	;mov rcx, -1
	mov rsi, rdi
	jmp printerr
	ret

DEFAWORD "CHAR", char
	call _word
	PUSHDS [rdi]
	and ds_top, 0xff
NEXT

; Dictionary
DEFAWORD "FIND", find
	POPDS rcx
	POPDS rdi
	call _find
	PUSHDS rax
NEXT
_find:	; Takes len=rcx, addr=rdi, returns link ptr=rax,rdx
	mov rbx, ip
	mov rdx, var_latest
	.loop:
		mov rdx, [rdx]	; Get previous entry in dictionary
		test rdx, rdx	; If we're at the start, then error
		jz .notindict

		xor rax, rax
		mov al, [rdx+8]	; Get namelen in al
		and al, F_LENMASK | F_HIDDEN
		cmp al, cl	; Hack to skip word if HIDDEN (wrong length)
		jne .loop

		mov r9, rcx	; Save addrs (rcx, rdi clobbered by repe)
		mov r10, rdi
		lea rsi, [rdx+9]
		repe cmpsb	; Compare the strings
		mov rdi, r10
		mov rcx, r9
		jne .loop	; If the strings don't match, get next word etc
	mov rax, rdx
	mov ip, rbx
	ret
.notindict:
	mov ip, rbx
	xor rax, rax
	ret

DEFAWORD ">CFA", to_cfa
	POPDS rdi
	call _tcfa
	PUSHDS rdi
NEXT
_tcfa:	; link in rdi => cfa ptr in rdi
	xor rax, rax
	add rdi, 8		; Skip link pointer
	mov al, [rdi]		; Get flags and length byte
	inc rdi			; Point rdi to start of name
	and al, F_LENMASK	; Strip the flags, leaving just namelen
	add rdi, rax		; Skip the name
	add rdi, 7		; 8-aligned, so skip the remaining bytes
	and rdi, ~7
	ret

DEFFWORD ">DFA", to_dfa		; Skip codeword and get the definition
	dq to_cfa
	dq celli
dq exit
DEFAWORD "(CREATE)", create	; ( addr len -- )
	POPDS rcx		; rcx=namelen
	and rcx, 0xff
	POPDS rbx		; rbx=addr of name
	mov rdi, here		; rdi=addr of header
	mov rax, [var_latest]	; Get link pointer
	stosq			; And store it in the header

	mov al, cl		; Get namelen
	stosb			; Store in header

	mov r9, ip		; Save ip
	mov rsi, rbx		; Copy name into header
	rep movsb
	mov ip, r9		; Restore ip
	add rdi, 7		; Align name to 8-byte boundary
	and rdi, ~7
	mov [var_latest], here	; Update latest to point to this entry
	mov here, rdi		; Point here to after the header
NEXT
DEFAWORD ",", comma		; Store ds_top as cell and advance here
	POPDS rax
	call _comma
NEXT
_comma:
	mov rdi, here
	stosq
	mov here, rdi
	ret
DEFAWORD "[", lbrac, F_IMM	; Enter immediate mode
	xor state, state
NEXT
DEFAWORD "]", rbrac		; Enter compiling mode
	mov state, 1
NEXT
DEFAWORD "IMMEDIATE", immediate, F_IMM
	mov rdi, [var_latest]	; Get latest entry
	add rdi, 8		; Advance to flags/len byte
	xor byte [rdi], F_IMM	; Toggle immediate flag
NEXT
DEFAWORD "HIDDEN", hidden
	add ds_top, 8		; Advance to flags/len byte
	xor byte [ds_top], F_HIDDEN	; Toggle hidden flag
	POPDS ds_top
NEXT
DEFFWORD "HIDE", hide
	dq wword
	dq find
	dq hidden
dq exit
DEFAWORD "'", tick		; Get xt - only in compiling mode!
	lodsq			; xt of next instr is in ip
	PUSHDS rax
NEXT
DEFAWORD "INT", int
	int 0xf2
NEXT
DEFAWORD "HLT", hlt
	int 0xf3
NEXT
DEFFWORD ":", colon
	dq wword		; Get name
	dq create		; Create header
	dq tick, docol, comma	; Store docol
	dq latest, fetch, hidden	; Mark as hidden during compilation
	dq rbrac		; Enter compiling mode
dq exit
DEFFWORD ";", semicolon, F_IMM
	dq lit, exit, comma	; Compile exit and mark unhidden
	dq latest, fetch, hidden
	dq lbrac		; Return to interpreting mode
dq exit

; Branching
DEFAWORD "BRANCH", branch
	add ip, [ip]		; Skip [ip]/8 words
NEXT
DEFAWORD "0BRANCH", zero_branch
	POPDS rax
	test rax, rax		; Is ds_top zero?
	jz code_branch		; If so, jump according to the offset
	lodsq			; Otherwise, skip the offset and continue
NEXT

; Interpreter
DEFAWORD "COUNT", count
	mov al, byte [ds_top]
	inc ds_top
	PUSHDS rax
NEXT
DEFAWORD "CCOUNT", ccount		; convert [length+char-array] to ptr length 
	mov rax, ds_top
	add ds_top, 8
	PUSHDS rax
NEXT
DEFAWORD "SOURCE", src		; ( -- addr u ) returns string
	PUSHDS [var_src]
	PUSHDS [var_nsrc]
NEXT
DEFAWORD "SOURCE!", src_store	; ( addr u -- )
	POPDS [var_nsrc]
	POPDS [var_src]
NEXT
var_src: dq 0
var_nsrc: dq 0

DEFAWORD "STOP", stop
	int 0xf4
NEXT
DEFFWORD "EVALUATE", evaluate	; ( addr u -- ) interpret string
	dq src, to_r, to_r	; Store current SOURCE string
	dq src_id, fetch, to_r	; Save SOURCE-ID
	dq to_in, fetch, to_r	; Save position in current SOURCE string

	dq lit, -1, src_id, store	; Indicate we're reading from a string
	dq lit, 0, to_in, store	; Read from beginning
	dq src_store		; Point SOURCE to the string

.loop:
	dq src, swap, drop	; Get length of string
	dq to_in, fetch, cmp_g	; Get number of chars left
	dq zero_branch, (4*8)	; Skip interpret if string is empty
	dq interpret		; Otherwise call interpret (does one word)
	dq branch, -($-.loop+8)	; Loop

	dq from_r, to_in, store	; Restore >IN
	dq from_r, src_id, store	; Restore SOURCE-ID
	dq from_r, from_r, swap, src_store	; Restore SOURCE
dq exit

DEFCONST "TIB", tib, TIBBUF
DEFCONST "TIBSZ", tibsz, TIBSZ

DEFAWORD "INTERPRET", interpret
	call _word		; rcx=len, rdi=addr
	cmp rcx, 0
	jne .cont		; if string is 0 length, exit to quit
NEXT
.cont:	xor r11, r11		; r11 is a flag to determine if we're on a lit
	call _find		; find clobbers rbx, rcx
	test rax, rax		; rax,rdx=link ptr
	jz .lit			; If not in dictionary, do lit code
	mov rdi, rdx		; rdi=dict entry
	mov dl, [rdi+8]		; Get namelen+flags in dl (rdx)
	call _tcfa		; rdi=codeword pointer (xt)
	mov rax, rdi
	and dl, F_IMM		; Is immediate flag set?
	jnz .exec		; If so, execute it now
	jmp .compile		; Otherwise, continue with compilation
.lit:
	inc r11			; Indicate we have a literal
	call _number		; Returns parsed num in rax, rcx != 0 if error
	test rcx, rcx
	jnz .invalid
	mov rbx, rax		; If parsed correctly, store num in rbx and
	mov rax, lit		; codeword of LIT in rax to be compiled
.compile:
	test state, state	; If interpreting, execute the word now
	jz .exec		; Otherwise, compile it
	call _comma
	test r11, r11		; If we have a literal, then compile it
	jnz .clit
NEXT
.clit:
	mov rax, rbx		; Add the literal too
	call _comma
NEXT
.exec:				; While in execution mode:
	test r11, r11		; Do we have a lit?
	jnz .elit
	jmp [rax]		; If not, execute the codeword in rax
.elit:				; Two jumps because cannot conditional to [rax]
	PUSHDS rbx		; If we do, add lit to stack
NEXT
.invalid:			; If word not a number or in the dictionary
	push rsi
	mov rsi, wordbuf
	call printerr
	pop rsi
	int 0xfe
	jmp error
NEXT

DEFAWORD "EXECUTE", execute
	POPDS rax		; Execute a codeword from the stack
jmp [rax]			; TCO

DEFAWORD "BYE", bye		; Stop execution
	cli
	hlt

ds_underflow:
	pop r11			; We call to this function, so rip is on stack
	int 0xf0
	jmp error
rs_underflow:
	int 0xf1
error:
	;mov here, [var_to_in]	; Debugging
	;mov state, [var_latest]
	int 0xff
	mov dstackp, [var_sp0]	; Reset data stack and quit execution
	xor n_ds, n_ds		; Reset stack counters
	xor n_rs, n_rs
	mov here, freemem	; Reset user memory
	mov qword [var_latest], name_last
	mov qword [var_src_id], 0	; Read from kb
	mov qword [var_to_in], 0
	jmp start

;DEFAWORD "DOCOL", docol
;	PUSHRS ip		; Push ip to return to via EXIT
;	add rax, 8		; rax points to the next word
;	mov ip, rax		; Jump to next word
;NEXT

DEFFWORD "LAST", last, F_HIDDEN	; THIS MUST BE THE LAST DEFINITION IN THIS FILE
dq exit


;; INTERPRETER START
start:
	cld			; Ensure the stacks grow downwards
	mov state, 0		; Ensure we start in execution mode
	mov byte [var_base], 10	; Set base to 10 (decimal)
	mov here, freemem	; Point here to free memory
	mov [var_sp0], dstackp	; Store beginning of ds in SP0
	xor ds_top, ds_top	; Clear first element on the stack
	mov rstackp, RSBEGIN	; Point rsp to the start of the data stack
	mov qword [var_src], filestart	; Read from file
	mov qword [var_nsrc], (fileend-filestart)
	mov qword [var_src_id], 1
	mov ip, .coldstart
	NEXT
.coldstart:
	dq src
	dq evaluate		; Evaluate the file
	;dq quit			; Enter normal interpreting mode

docol:
	PUSHRS ip		; Push ip to return to via EXIT
	add rax, 8		; rax points to the next word
	mov ip, rax		; Jump to next word
NEXT

printerr:	; Takes count in rcx, str in rsi
	push rax
	push rdi
	mov ah, 0x1f
	mov rdi, 0xb8004
.loop:		lodsb
		or al, al
		jz .end
		mov [rdi], ax
		add rdi, 2
		jmp .loop
.end:	pop rdi
	pop rax
	ret


align 64			; Cache optimisation
wordbuf:
	resb WORDBUFLEN
TIBBUF:
	dq 0
	resb TIBSZ

align 512
filesize: dq (fileend-filestart)	; Size of file
filestart:
incbin "forth/core.fs"
;incbin "forth/maths.fs"
incbin "forth/exceptions.fs"
;incbin "forth/assembler.fs"
incbin "forth/graphics.fs"
;incbin "forth/font.fs"
incbin "forth/startup.fs"
fileend:

align 512
freemem:
