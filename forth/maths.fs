\ \\\ Maths
: NEGATE 0 SWAP - ;             \ Negated form of number
: / /MOD SWAP DROP ;
: MOD /MOD DROP ;

\ Number bases
: BINARY 2 BASE ! ;
: BIN 2 BASE ! ;
: TERNARY 3 BASE ! ;
: PENTAL 5 BASE ! ;
: SEXIMAL 6 BASE ! ;
: OCTAL 8 BASE ! ;
: DECIMAL 10 BASE ! ;
: DEC 10 BASE ! ;
: DUODECIMAL 12 BASE ! ;
: DOZENAL 12 BASE ! ;
: HEXADECIMAL 16 BASE ! ;
: HEX 16 BASE ! ;

\ Prefix - parse next number in given base
\ WARNING - DOES NOT HANDLE ERRORS PROPERLY!!!!!!!!!!!!!!!!!!!
: $  BASE @ WORD BINARY  NUMBER DROP SWAP BASE ! ;
: #  BASE @ WORD DECIMAL NUMBER DROP SWAP BASE ! ;
: %  BASE @ WORD HEX     NUMBER DROP SWAP BASE ! ;

\ Not SI prefixes!
: KILO 1024 * ;
: MEGA KILO 1024 * ;
: GIGA MEGA 1024 * ;

\ \\\ Numerical I/O
: U.
  BASE @ /MOD ?DUP IF
    RECURSE
  THEN DUP 10 < IF
    '0'
  ELSE
    10 - 'A'
  THEN + EMIT ;

: UWIDTH                        \ Get width for U.R
  BASE @ / ?DUP IF
    RECURSE 1+
  ELSE
    1
  THEN ;

: U.R                           \ Space-padded U.
  SWAP DUP UWIDTH ROT SWAP - SPACES U. ;

: .R                            \ Space-padded .
  SWAP DUP 0< IF
    NEGATE 1 SWAP ROT 1-
  ELSE
    0 SWAP ROT
  THEN SWAP DUP UWIDTH ROT SWAP - SPACES SWAP IF
    '-' EMIT
  THEN U. ;

: DEPTH #DS ;

: .S
  '<' EMIT DEPTH U. '>' EMIT SPACE
  SP0 @ CELL- BEGIN
    DUP SP@ CELL+ >             \ TODO: remove cell+, use >=
  WHILE
    DUP @ 0 .R SPACE CELL-
  REPEAT DROP ;
: R.S
  '<' EMIT #RS U. '>' EMIT SPACE
  HEX RP0 CELL- BEGIN
    DUP RP@ CELL+ >
  WHILE
    DUP @ 0 .R SPACE CELL-
  REPEAT DROP DEC ;

: U. U. SPACE ;
: . 0 .R SPACE ;
: ? @ . ;

: WITHIN  ( a x y -- bool \ true if x<=a<y )
  -ROT OVER <= IF
    > IF
      TRUE
    ELSE
      FALSE
    THEN
  ELSE
    2DROP FALSE
  THEN ;
