\ \\\ FORTH CORE DEFINITIONS
\
\ TODO:
\   Change error code so that is returns to QUIT
\   Fix DOES>


\ \\\ Logic
: TRUE -1 ;			\ Any non-zero value is true
: FALSE 0 ;
: NOT 0= ;			\ Logical not

 
\ \\\ Compiler
: LITERAL IMMEDIATE		\ Compile a literal from the stack
  ' LIT , , ;

\ TODO: Add syntax for defining individual characters
: ':' [ CHAR : ] LITERAL ;
: ';' [ CHAR ; ] LITERAL ;
: '(' [ CHAR ( ] LITERAL ;
: ')' [ CHAR ) ] LITERAL ;
: '>' [ CHAR > ] LITERAL ;
: '<' [ CHAR < ] LITERAL ;
: '"' [ CHAR " ] LITERAL ;
: 'A' [ CHAR A ] LITERAL ;
: '0' [ CHAR 0 ] LITERAL ;
: '+' [ CHAR + ] LITERAL ;
: '-' [ CHAR - ] LITERAL ;
: '.' [ CHAR . ] LITERAL ;
: '|' [ CHAR | ] LITERAL ;

: [COMPILE] IMMEDIATE		\ Compile an immediate word into the definition
  WORD FIND >CFA , ;
: RECURSE IMMEDIATE		\ Compiles the CFA of the word being defined
  LATEST @ >CFA , ;

: CREATE  \ ( addr c -- )
  \ Creates a dict entry with provided string as name and def behaviour returns
  \ a pointer to just past the end of the definition
  \ [ header | push addr | exit ] <-- addr points here
  WORD (CREATE) DOCOL ,  \ Create header
  ' LIT , HERE@ 16 + ,  \ Compile pointer (16 + increments by two cells)
  ' EXIT , ;

: DOES>  \ Inserts a jump inside a CREATE def into the current one
  R>  \ Get addr of the next word from the current def on the stack
  LATEST @ >DFA CELL+ CELL+  \ Point to EXIT from CREATE
  ! ;  \ Replace EXIT with a ptr into the current def

\ \\\ Loops
: BEGIN IMMEDIATE
  HERE@ ;
: UNTIL IMMEDIATE
  ' 0BRANCH , HERE@ - , ;
: AGAIN IMMEDIATE
  ' BRANCH , HERE@ - , ;
: WHILE IMMEDIATE
  ' 0BRANCH , HERE@ 0 , ;
: REPEAT IMMEDIATE
  ' BRANCH , SWAP HERE@ - , DUP HERE@ SWAP - SWAP ! ;

: DO IMMEDIATE
  HERE@				\ Current position to store at LOOP
  ' >R , ' >R , ;		\ Push loop params onto rstack
: LOOP IMMEDIATE
  ' R> , ' R> ,			\ Get params from rstack
  ' 1+ , ' 2DUP ,		\ Increment index
  ' = , ' 0BRANCH ,		\ If not equal, loop
  HERE@ - , ' 2DROP , ;		\ Compile position of LOOP and drop params

: +LOOP IMMEDIATE
  ' R> , ' R> ,			\ Get params from rstack
  ' + , ' 2DUP ,		\ Increment index
  ' = , ' 0BRANCH ,		\ If not equal, loop
  HERE@ - , ' 2DROP , ;		\ Compile position of LOOP and drop params

: I				\ Push index to dstack
  2 RPICK ;
: J				\ Push index to dstack
  4 RPICK ;
: K				\ Push index to dstack
  6 RPICK ;



\ \\\ Conditionals
: IF IMMEDIATE
  ' 0BRANCH ,			\ Compile 0BRANCH here
  HERE@				\ Put current location on the stack
  0 , ;				\ Compile a dummy offset

: THEN IMMEDIATE
  DUP				\ (HERE should be on the stack from IF)
  HERE@ SWAP -			\ Compute offset
  SWAP ! ;			\ Store after 0BRANCH in IF

: ELSE IMMEDIATE
  ' BRANCH , HERE@ 0 , SWAP DUP HERE@ SWAP - SWAP ! ;

: UNLESS IMMEDIATE
  ' NOT , [COMPILE] IF ;

: CASE IMMEDIATE  0 ;		\ Push 0 to mark bottom of stack

: OF IMMEDIATE  ' OVER , ' = , [COMPILE] IF ' DROP , ;
: ENDOF IMMEDIATE  [COMPILE] ELSE ;
: ENDCASE IMMEDIATE
  ' DROP , BEGIN
    ?DUP
  WHILE
    [COMPILE] THEN
  REPEAT ;


\ \\\ I/O
: EMIT  SEMIT ;			\ Stub to enable serial I/O for now
: CR  13 EMIT ;			\ Carriage return

: BL  32 ;			\ Space
: SPACE  BL EMIT ;
: SPACES
  BEGIN
    DUP 0>
  WHILE
    SPACE 1-
  REPEAT DROP ;


\ \\\ Comments
: ( IMMEDIATE
  1 BEGIN			\ The 1 allows for nested brackets (suck it, gforth)
    KEY DUP '(' = IF
      DROP 1+
    ELSE
      ')' = IF
	1-
      THEN
    THEN
  ?DUP 0= UNTIL ;


\ \\\ Stack manipulation
: NIP ( a b -- b ) SWAP DROP ;
: TUCK ( a b -- b a b ) SWAP OVER ;
: PICK  1+ CELL * SP@ + @ ;


\ \\\ Maths
: NEGATE 0 SWAP - ;		\ Negated form of number
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
\ WARNING - DOES NOT SAFELY HANDLE ERRORS!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
\ other warning - needs to check STATE, currently works for compiling mode
: % IMMEDIATE  BASE @ WORD BINARY  NUMBER DROP SWAP BASE ! ' LIT , , ;
: # IMMEDIATE  BASE @ WORD DECIMAL NUMBER DROP SWAP BASE ! ' LIT , , ;
: $ IMMEDIATE  BASE @ WORD HEX     NUMBER DROP SWAP BASE ! ' LIT , , ;

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

: UWIDTH			\ Get width for U.R
  BASE @ / ?DUP IF
    RECURSE 1+
  ELSE
    1
  THEN ;

: U.R				\ Space-padded U.
  SWAP DUP UWIDTH ROT SWAP - SPACES U. ;

: U.0				\ 0-padded U.
  SWAP DUP UWIDTH ROT SWAP -
  ?DUP IF 0 DO '0' EMIT LOOP THEN U. ;

: .R				\ Space-padded .
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
    DUP SP@ CELL+ >		\ TODO: remove cell+, use >=
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

: MIN  ( a b -- min(a, b) )
  2DUP < IF DROP ELSE NIP THEN ;


\ \\\ Memory
: HERE+! HERE@ + HERE! ;

: ALIGNED			\ Align to cell boundary
  7 + 7 INVERT AND ;

: ALIGN				\ Aligns HERE
  HERE@ ALIGNED HERE! ;

: ALLOT
  HERE@ SWAP HERE+! ;

: CELLS CELL * ;
: /CELL 8 / ;			\ Divides by cell size

: CONSTANT  CREATE , DOES> @ ;
\ WORD CREATE DOCOL , ' LIT , , ' EXIT , ;
: VARIABLE  CREATE 0 , ;



\ \\\ Strings
: C,				\ Compile byte
  HERE@ C! 1 HERE+! ;

: S" IMMEDIATE			\ Accept string from input and either compile or push
  STATE@ IF			\ Compiling?
    ' LITSTRING ,		\ Compile litstring
    HERE@ 0 , BEGIN		\ Compile dummy length
      KEY DUP '"' <>		\ Scan until we reach a '"'
    WHILE
      C,			\ Compile chars
    REPEAT DROP			\ Drop the '"' left over
    DUP HERE@ SWAP -		\ Calculate the length
    CELL- SWAP ! ALIGN		\ Store length
  ELSE				\ Interpreting?
    HERE@ BEGIN			\ Get start address of temp space
      KEY DUP '"' <>		\ Scan until we reach a '"'
    WHILE
      OVER C! 1+		\ Store chars
    REPEAT DROP			\ Drop the '"' left over
    HERE@ - HERE@ SWAP		\ Leave ( addr len )
  THEN ;

: TYPE				\ Prints a string from the stack
  BEGIN
    ?DUP			\ While length is >0
  WHILE
    1- SWAP			\ Decrement count
    DUP C@ EMIT 1+ SWAP		\ Print char and advance address by one
  REPEAT DROP ;

: ." IMMEDIATE			\ Prints a string literal
  STATE@ IF			\ Compiling?
    [COMPILE] S"		\ Compile the string
    ' TYPE ,			\ Compile TYPE
  ELSE				\ Interpreting?
    BEGIN
      KEY DUP '"' = IF		\ Exit word if we encounter a "
        DROP EXIT
      THEN EMIT			\ Otherwise, emit and repeat
    AGAIN
  THEN ;


\ \\\ Dictionary
: ID.				\ ( addr -- s_addr len )
  CELL+ DUP C@			\ Get the length+flags byte
  F_LENMASK AND			\ Strip the flags
  SWAP 1+ SWAP ;		\ Get string

: HIDDEN?			\ ( addr -- bool )
  CELL+ C@ F_HIDDEN AND	;
: IMMEDIATE?			\ ( addr -- bool )
  CELL+ C@ F_IMM AND ;

: WORDS				\ Print a list of all words in the dictionary
  CR LATEST @ BEGIN		\ Start at LATEST
    ?DUP			\ Stop when we reach the end (tos=0)
  WHILE
    DUP HIDDEN? NOT IF
      DUP ID. TYPE SPACE
    THEN @
  REPEAT ;

: FORGET
  WORD FIND DUP @		\ Find addr of word
  LATEST ! HERE! ;		\ Point latest and here to it, marking this mem as free

\ Decompilation
: CFA>				\ Guesses the definition corresponding to addr on stack
  LATEST @ BEGIN
    ?DUP
  WHILE
    2DUP SWAP
    < IF
      NIP EXIT
    THEN @
  REPEAT DROP 0 ;

: SEE				\ Print definition of a word
  WORD FIND			\ Get word to decompile
  DUP 0= IF ." INVALID WORD" EXIT THEN	\ If not in dict, error and return
  HERE@ LATEST @ BEGIN
    2 PICK OVER <>		\ Find next word on stack (for length of word)
  WHILE
    NIP DUP @
  REPEAT DROP SWAP		( end-of-word start-of-word )
  CR ." : " DUP ID. TYPE SPACE
  DUP IMMEDIATE? IF
    ." IMMEDIATE"
  THEN CR
  >CFA DUP @ DOCOL <> IF	\ If not a Forth word (defined in assembly)
    ." Assembly word ;" CR EXIT	\ If it is, say so and exit
  THEN CELL+ BEGIN		( end-of-def start-of-def)
    2DUP >			\ While still in bounds of def
  WHILE
    DUP @ CASE
      ' LIT OF
	CELL+ DUP @ .		\ If lit, get next word (the lit) and print it
	ENDOF
      ' LITSTRING OF
	[ CHAR S ] LITERAL EMIT	\ Print S"
	'"' EMIT SPACE
	CELL+ DUP @		\ Get word length
	SWAP CELL+ SWAP		\ Get string on stack
	2DUP TYPE		\ Print
	'"' EMIT SPACE
	+ ALIGNED CELL-		\ Ready for next word
	ENDOF
      ' 0BRANCH OF
	." 0BRANCH ( "
	CELL+ DUP @ /CELL .	\ Print offset
        ." )" ENDOF
      ' BRANCH OF
	." BRANCH ( "
	CELL+ DUP @ /CELL .	\ Print offset
        ." )" ENDOF
      ' ' OF
	[ CHAR ' ] LITERAL EMIT SPACE
	CELL+ DUP @		\ Get next codeword
	CFA> ID. TYPE		\ Convert it to a dict entry and print it
	ENDOF
      ' EXIT OF			\ EXIT can appear in the middle of a word
	2DUP CELL+ <> IF
	  ." EXIT"		\ If not at the end, then print EXIT
	THEN ENDOF
      ( default case )
        DUP CFA> ID. TYPE
      ENDCASE CELL+ SPACE
    REPEAT
  ';' EMIT CR 2DROP ;

: :NONAME			\ Creates anonymous word
  0 0 CREATE			\ Create word with empty string as the name
  HERE@ DOCOL , [ ;		\ Compile DOCOL, leave xt on stack & interpret

: ['] IMMEDIATE
  ' LIT , ;			\ Compile LIT


\ \\\ Interpreter rewritten
: ACCEPT  ( c-addr u1 -- u2 ) \ Write up to u1 chars into a buf. u2 is n wrote
  >R 0 BEGIN				\ Save max length on rstack
    DUP R> DUP >R <=			\ While the buffer isn't full
  WHILE
    SKEY CASE
      13 OF NIP R> DROP EXIT ENDOF
      8  OF DUP IF			\ If len<>0 (there are chars to delete)
              2DUP + 0 SWAP C! 1-	\ Overwrite char with 0 and go back by 1
	      8 SEMIT SPACE 8 SEMIT	\ Remove previous char from screen
	    THEN ENDOF
      ( default ) >R 2DUP +		\ Get adress
                  R> DUP ROT C!		\ Store character
		  SWAP 1+ SWAP		\ Increment character position
		  DUP SEMIT		\ Echo character
    ENDCASE
  REPEAT NIP ;				\ Drop address

: STATUS  CR ." > " ;
: DONEPROMPT
  STATE@ NOT IF
    SPACE ." ok"
  ELSE
    SPACE ." compiled"
  THEN ;

: QUIT
  0 SOURCE-ID !			\ Get input from user
  [COMPILE] [			\ Ensure interpreting mode
  RP0 RP!			\ Reset return stack
  BEGIN
    STATUS
    TIB DUP TIBSZ ACCEPT	\ Get string from user
    SPACE			\ Space output from input
    EVALUATE			\ Evaluate string
    DONEPROMPT
  AGAIN ;

HIDE DONEPROMPT
HIDE STATUS
