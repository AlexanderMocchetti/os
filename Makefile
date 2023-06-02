SIZE=5
CC=i686-elf-gcc
AS=i686-elf-as
LD=i686-elf-ld
OBJCPY=i686-elf-objcopy
EMU=qemu-system-i386
EMUFLAGS=-drive format=raw,file=$(ISO)
DEBUGFLAGS=-g
CCFLAGS=-std=c11 -Wall -Wextra -Wpedantic -Wstrict-aliasing -Wno-pointer-arith -Wno-unsed-parameter -nostdlib -nostdinc -ffreestanding -fno-builtin-function -fno-builtin
BINS=bin
SRC=src
SYMS=syms
BOOTSECT_SRCS=$(SRC)/boot.s
BOOTSECT_OBJS=$(BOOTSECT_SRCS:.s=.o)
BOOTSECT=$(BINS)/bootsect.bin
BOOTSECT_DEBUG=$(BINS)/bootsect_db.bin
ISO=boot.iso


all: run 

debug: iso
	$(EMU) -s -S $(EMUFLAGS) 
	osascript -e 'Tell application "Terminal" to do script "$(PWD)/.dumbshit/db.sh"'

clean:
	$(RM) ./**/*.o
	$(RM) ./*.iso
	$(RM) ./**/*.elf
	$(RM) ./**/*.bin 
	$(RM) ./**/*.sym
	
dirs: 
	mkdir -p $(SRC) $(BINS) $(SYMS)

$(SRC)/%.o: $(SRC)/%.s
	$(AS) -o $@ $< $(DEBUGFLAGS)
 
bootsect: $(BOOTSECT_OBJS)
	$(LD) -o ./$(BOOTSECT_DEBUG) $^ -Ttext=0x7C00
	$(OBJCPY) --only-keep-debug ./$(BOOTSECT_DEBUG) $(SYMS)/bootsect.sym
	$(OBJCPY) -O binary $(BOOTSECT_DEBUG) $(BOOTSECT)

iso: dirs bootsect
	dd if=/dev/zero of=$(ISO) bs=512 count=$(SIZE)
	dd if=./$(BOOTSECT) of=$(ISO) conv=notrunc bs=512 seek=0 count=1  #possible error coming from bootsect/bins variable

run: iso
	$(EMU) $(EMUFLAGS)
