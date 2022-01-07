\ \\\ VGA Mode 0x12
\ This mode is 640x480, with 16 colours (4-bit).
\ Each pixel onscreen is mapped to a single bit in memory, and each colour gets
\ a plane. However, we only have 96KB to work with, and since each plane is
\ (640*480/8/1024)=37KB, we can't access all colour planes at once.

\ We define the screen as having (0, 0) in the top-left and (639, 479) in the
\ bottom-right.

\ Currently, we get around this by only using the intensity plane, which means
\ we can only draw white pixels to the screen.

\ Due to the fact that pixels have bit offsets, we represent a pixel as:
\ <pixel> = ( addr bitmask )

\ Also owing to this fact is how slow drawing is in this mode; many more calculations are required per pixel than most other graphics modes.


( : XY>PIXEL  ( x y -- <pixel> )	\ Converts y-value to memory offset
  SWAP 8 /MOD SWAP 7 SWAP 1 SWAP - <<	\ Compute bitmask
  .S
  -ROT .S 80 * + SWAP $ A0000 + ;	\ Compute offset
)
: XY>PIXEL  ( x y -- <pixel> )
  80 * $ A0000 + SWAP		\ Compute y-offset
  8 /MOD ROT + SWAP		\ Add x-offset
  7 SWAP - 1 SWAP << ;		\ Compute bitmask

: DRAW-PIXEL  ( x y -- )	\ draws a pixel
  XY>PIXEL OVER C@ OR SWAP C! ;

: CLEAR-PIXEL  ( x y -- )	\ removes a pixel from the screen
  XY>PIXEL INVERT OVER C@ AND C! ;

: DRAW-CHAR  ( x y c -- )	\ Print a bitpattern starting from (x, y)
  -ROT 80 * + $ A0000 + C! ;

: FILL-SCREEN  ( bitpattern -- )
  $ A0000 640 480 * ROT FILL ;

: BLACK-SCREEN
  0 FILL-SCREEN ;
: WHITE-SCREEN
  $ FF FILL-SCREEN ;

: DRAW-LINE  ( from(x, y) to(x, y) -- )	\ Draw a straight line
  ;
