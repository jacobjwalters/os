for i=0,255 do print("\
	; Entry "..string.format("%02x",i).."\
	dw isr_"..string.format("%02x",i).."\
	dw 0x0008\
	db 0\
	db 10001110b\
	dw 0\
	dq 0") end
