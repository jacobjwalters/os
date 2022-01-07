\ \\\ Exceptions

: EXCEPTION-MARKER              \ Mark return point on rs
  RDROP 0 ;

: CATCH
  SP@ CELL+ >R                  \ Save data stack pointer on rs
  ' EXCEPTION-MARKER CELL+ >R   \ Push addr of RDROP in E-M to act as a return
  EXECUTE ;                     \ Execute nested word

: THROW ( n -- )
  ?DUP IF                       \ Only act if exception code <>0
    RP@ BEGIN
      DUP RP0 CELL+ <           \ While RSP < RP0 (lt as stack grows down)
    WHILE
      DUP @                     \ Get rs entry
      ' EXCEPTION-MARKER CELL+ = IF     \ If it's the E-M (if CATCH used)
        CELL+ RP!               \ Skip it and restore the rsp
        DUP DUP DUP             \ Reserve stack space for this word
        R> CELL-                \ Get the saved dsp and reserve space on stack
        SWAP OVER !             \ Write n on the stack
        SP! EXIT                \ Restore dsp, and EXIT to CATCH
      THEN CELL+                \ Advance to next rs entry
    REPEAT DROP CASE            \ No matching CATCH -- error and reset
      -1 OF ." ABORTED" CR      \ -1 is ABORT
        ENDOF
    ( default )
        ." UNCAUGHT THROW"
        DUP . CR                \ Print THROW code
    ENDCASE QUIT                \ Reset
  THEN ;

: ABORT -1 THROW ;

: TRACE.                        \ Print stack trace by walking up the stack
  RP@ BEGIN                     \ Start at caller of .TRACE
    DUP RP0 CELL- <             \ RSP < RP0
  WHILE
    DUP @ CASE                  \ Get rs entry
      ' EXCEPTION-MARKER CELL+ OF
        ." CATCH ( SP="
        CELL+ DUP @ U. ." )"    \ Print saved stack pointer
        ENDOF
      ( default case )
        DUP CFA> ?DUP IF        \ Print dict entry
          2DUP ID. TYPE
          [ CHAR + ] LITERAL EMIT
          SWAP >DFA CELL+ - .   \ Print offset
      THEN
    ENDCASE CELL+
  REPEAT DROP CR ;

: BRK
  CR ." Breakpoint hit at" TRACE.
  ." Stack contents:" .S
  ." Press <SPACE> to continue."
  BEGIN KEY 32 <> WHILE REPEAT ;

: DUMP-BYTES  ( addr len )
  BEGIN
    ?DUP
  WHILE
    SWAP DUP C@			\ Get byte
    2 U.0 SPACE			\ Print byte
    1+ SWAP 1-
  REPEAT DROP ;

: DUMP-CHARS  ( addr len )
  BEGIN
    ?DUP			\ While there's bytes to print
  WHILE
    SWAP DUP C@			\ Get byte
    DUP 20 128 WITHIN		\ Is it a printable char?
    IF
      EMIT			\ If so, print it
    ELSE
      DROP '.' EMIT		\ Else, print a .
    THEN
    1+ SWAP 1-			\ Iterate through string
  REPEAT DROP ;

: DUMP-LINE  ( addr len )
  CR OVER 8 U.0 SPACE '|' EMIT SPACE	\ Print address
  OVER 8 DUMP-BYTES SPACE	\ Print the bytes with a 2 space gap in between
  OVER CELL+ OVER CELL- DUMP-BYTES
  DUP 16 SWAP - 3 * SPACES	\ Pad out shorter lines with spaces
  '|' EMIT DUMP-CHARS		\ Print ASCII representation
  '|' EMIT ;

: DUMP				\ Hexdump ( addr len -- )
  BASE @ -ROT HEX		\ Save base at the bottom ds and switch to hex
  BEGIN
    DUP 0>			\ While len > 0
  WHILE
    2DUP 16 MIN			\ Calculate length of line to print
    DUMP-LINE			\ Print it
    16 - SWAP 16 + SWAP		\ Iterate to next line
  REPEAT 2DROP BASE ! ;		\ Restore base

HIDE DUMP-BYTES
HIDE DUMP-CHARS
HIDE DUMP-LINE

: DUMPWORD			\ Hexdump of word
  WORD FIND			\ Get word to decompile
  DUP 0= IF ." INVALID WORD" EXIT THEN	\ If not in dict, error and return
  HERE@ LATEST @ BEGIN
    2 PICK OVER <>		\ Find next word on stack (for length of word)
  WHILE
    NIP DUP @
  REPEAT DROP OVER - DUMP ;

: WHO  ( addr )			\ Prints name of word for a given address
  DUP DOCOL = IF ." DOCOL" DROP ELSE	\ Hack for DOCOL not being a real word
  DUP CFA> DUP CELL+ COUNT $ 3F AND TYPE	\ Print word name
  - '+' EMIT . THEN ;		\ Print offset (in bytes)
