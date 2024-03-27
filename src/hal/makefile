CC_PATH = $(CROSS_PATH)/$(GCC_TARGET)-gcc
AS_PATH = $(CROSS_PATH)/$(GCC_TARGET)-as
CC_FLAGS = -std=gnu99 -ffreestanding -O2 -Wall -Wextra

usage:
	@echo "hello"

compile:
	mkdir tmp
	nasm -o tmp/boot.o -felf64 boot.asm
	$(CC_PATH) -c halmain.c -o tmp/halmain.o $(CC_FLAGS)
	$(CC_PATH) -c console.c -o tmp/console.o $(CC_FLAGS)
	cp linker.ld tmp/linker.ld
	cd tmp && $(CC_PATH) -T linker.ld -o hal.bin -ffreestanding -O2 -nostdlib *.o -lgcc
	grub-file --is-x86-multiboot2 tmp/hal.bin && echo $$?
	cp tmp/hal.bin ../tmp/hal.bin
	rm -r tmp