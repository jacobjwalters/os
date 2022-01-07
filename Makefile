TARGET=stage2
QEMU_CMD=qemu-system-x86_64 -drive if=floppy,index=0,file=$(TARGET),format=raw -m 128 -d int -no-reboot -drive if=ide,index=0,file=disk.img

all:
	yasm -f bin $(TARGET).asm -Worphan-labels

clean:
	rm $(TARGET)
	
run:	all
	$(QEMU_CMD)

dbg:	all
	$(QEMU_CMD) -s -S & sleep 1 && r2 -d -e dbg.bpinmaps=false gdb://localhost:1234

