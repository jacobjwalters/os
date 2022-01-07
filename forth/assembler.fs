\ \\\ Assembler - this assembler is 64-bit only
HEX
: NEXT IMMEDIATE  AD C, FF C, 20 C, ;   \ Equivalent to NEXT macro
: ;CODE IMMEDIATE
  [COMPILE] NEXT
  ALIGN LATEST @ DUP HIDDEN     \ Mark as not hidden
  DUP >DFA SWAP >CFA !          \ Change from DOCOL to asm pointer
  [COMPILE] [ ;                 \ Return to interpreting mode

: REX.W  48 ;                   \ 64-bit encoding
: REX.R  44 ;                   \ Extension to MODRM.reg field (MSB)
: REX.X  42 ;                   \ Extension to SIB.index field (MSB)
: REX.B  41 ;                   \ Extension to MODRM.rm field (MSB)
: RAX IMMEDIATE  0 ;
: RCX IMMEDIATE  1 ;
: RDX IMMEDIATE  2 ;
: RBX IMMEDIATE  3 ;
: RSP IMMEDIATE  4 ;
: RBP IMMEDIATE  5 ;
: RSI IMMEDIATE  6 ;
: RDI IMMEDIATE  7 ;
: R8  IMMEDIATE  0 REX.W C, ;
: R9  IMMEDIATE  1 REX.W C, ;
: R10 IMMEDIATE  2 REX.W C, ;
: R11 IMMEDIATE  3 REX.W C, ;
: R12 IMMEDIATE  4 REX.W C, ;
: R13 IMMEDIATE  5 REX.W C, ;
: R14 IMMEDIATE  6 REX.W C, ;
: R15 IMMEDIATE  7 REX.W C, ;



\ Logic instrs

\ Stack instrs
: ,PUSH IMMEDIATE  50 + C, ;    \ Not equivalent to PUSHDS macro; no checking!
: ,POP IMMEDIATE  58 + C, ;
: ,INCDS IMMEDIATE  49 C, FF C, C4 C, ; \ Increment DS
: ,DECDS IMMEDIATE  49 C, FF C, CC C, ; \ Decrement DS
: ,PUSHTOP IMMEDIATE  41 C, 50 C, ;     \ Pushes ds_top onto the stack for asm
: ,POPTOP IMMEDIATE  41 C, 58 C, ;      \ Pops TOS back into ds_top for forth
: ,HLT IMMEDIATE CD C, F3 C, ;			\ Equivalent to HLT

\ Timing instrs
: ,RDTSC IMMEDIATE  0F C, 31 C, ;       \ Reads timestamp into RDX:RAX
: ,LFENCE IMMEDIATE  0F C, AE C, E8 C, ;        \ LFENCE synchronises from OoOE

: ,TSC@ ,LFENCE ,RDTSC			\ Synch and read
  [ 48 C, 0F C, A4 C, C2 C, 20 C, ]	\ shld rdx, rax, 0x20 - pack into rdx
  [ 48 C, 01 C, C2 C, ]			\ add rdx, rax
  \ [ HLT ] HLT,
  ,PUSHTOP ,INCDS
  [ 49 C, 89 C, D0 C, ] ;CODE	\ mov ds_top, rdx
: TSC@ 0 ,TSC@ QUIT NIP ;	\ Fix for pushing when stack empty

\ Port I/O
: ,IN IMMEDIATE  EC C, ;        \ in al, dx
: ,OUT IMMEDIATE  EE C, ;       \ out dx, al
: PORT@  ( port -- val )
  ,PUSHTOP RDX ,POP             \ Get port in rdx
  ,IN                           \ al contains our value
  RAX ,PUSH ,POPTOP ;CODE       \ Push result back on stack
: PORT!  ( val port -- )
  ,PUSHTOP
  RDX ,POP
  RAX ,POP ,OUT
  ,DECDS ,DECDS ,POPTOP ;CODE

\ Misc.
: PUSHRAX  ,PUSHTOP [ 49 C, 89 C, C0 C, ] ,INCDS ;CODE
: =NEXT                         ( addr -- next? ) \ Are we looking at NEXT?
  DUP C@ AD <> IF DROP FALSE EXIT THEN 1+
  DUP C@ FF <> IF DROP FALSE EXIT THEN 1+
      C@ 20 <> IF      FALSE EXIT THEN TRUE ;

DECIMAL


\ \\\ Inlining
: (ASM-INLINE)                  ( cfa -- )
  @ BEGIN                       \ Get code and start copying
    DUP =NEXT NOT               \ Run until NEXT reached
  WHILE
    DUP C@ C, 1+                \ Copy bytes
  REPEAT DROP ;

: (FORTH-INLINE)  ( cfa -- )
  ." Can only inline assembler words!" CR ABORT ;
  \ CELL+ BEGIN			\ Skip DOCOL
    

: INLINE IMMEDIATE
  WORD FIND >CFA                \ Get codeword from name
  DUP @ DOCOL = IF              \ If DOCOL is found, it's a Forth word
    (FORTH-INLINE)
  ELSE				\ Otherwise, it's an assembly word
    (ASM-INLINE)
  THEN ;
HIDE =NEXT
