CC_PATH = $(CROSS_PATH)/$(GCC_TARGET)-gcc
AS_PATH = $(CROSS_PATH)/$(GCC_TARGET)-as
CC_FLAGS = -std=gnu99 -ffreestanding -O2 -Wall -Wextra -mcmodel=large -mno-red-zone -fno-asynchronous-unwind-tables
TMP_PATH = ../../tmp/src/kernel
OBJECTS = $(addprefix $(TMP_PATH)/,$(patsubst %.c,%.o,$(wildcard *.c))) $(TMP_PATH)/boot.o $(TMP_PATH)/utils.o
#OBJECTS = $(TMP_PATH)/boot.o $(TMP_PATH)/halmain.o $(TMP_PATH)/console.o

usage:
	@echo "hello"

compile: tmpdir $(OBJECTS)
#	mkdir -p $(TMP_PATH)
#	nasm -o $(TMP_PATH)/boot.o -felf64 boot.asm
#	$(CC_PATH) -c halmain.c -o tmp/halmain.o $(CC_FLAGS)
#	$(CC_PATH) -c console.c -o tmp/console.o $(CC_FLAGS)
#	$(CC_PATH) -c *.c -o $(TMP_PATH)/hal.o $(CC_FLAGS)
#	cp linker.ld tmp/linker.ld
#	cd tmp && $(CC_PATH) -T linker.ld -o hal.bin -ffreestanding -O2 -nostdlib *.o -lgcc
#	grub-file --is-x86-multiboot2 tmp/hal.bin && echo $$?
#	cp tmp/boot.o ../tmp/boot.o
#	cp tmp/hal.o ../tmp/hal.o
#	rm -r tmp

$(TMP_PATH)/boot.o: boot.asm  multiboot2.asm x86_64.asm
	nasm -o $(TMP_PATH)/boot.o -felf64 boot.asm
	
$(TMP_PATH)/utils.o: utils.asm
	nasm -o $(TMP_PATH)/utils.o -felf64 utils.asm

$(TMP_PATH)/kmain.o: kmain.c multiboot2.h x86_64.h console.h
	$(CC_PATH) -c kmain.c -o $(TMP_PATH)/kmain.o $(CC_FLAGS)

$(TMP_PATH)/console.o: console.c console.h
	$(CC_PATH) -c console.c -o $(TMP_PATH)/console.o $(CC_FLAGS)

$(TMP_PATH)/gdt.o: gdt.c
	$(CC_PATH) -c gdt.c -o $(TMP_PATH)/gdt.o $(CC_FLAGS)

$(TMP_PATH)/page.o: page.c
	$(CC_PATH) -c page.c -o $(TMP_PATH)/page.o $(CC_FLAGS)

$(TMP_PATH)/memory.o: memory.c
	$(CC_PATH) -c memory.c -o $(TMP_PATH)/memory.o $(CC_FLAGS)

tmpdir:
	mkdir -p $(TMP_PATH)