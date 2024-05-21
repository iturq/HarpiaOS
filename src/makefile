CC_PATH = $(CROSS_PATH)/$(GCC_TARGET)-gcc
AS_PATH = $(CROSS_PATH)/$(GCC_TARGET)-as
CC_FLAGS = -std=gnu99 -ffreestanding -O2 -Wall -Wextra
TMP_PATH = ../tmp/src
#C_SOURCE = $(wildcard *.c)
C_SOURCE = $(wildcard kernel/*.c)
#ASM_SOURCE += $(wildcard hal/*.asm)
#OBJECTS = $(patsubst %.c,%.o,$(C_SOURCE)) hal/boot.o
#OBJECT += $(patsubst %.asm,%.o,$(ASM_SOURCE))
OBJECTS = $(addprefix $(TMP_PATH)/,$(patsubst %.c,%.o,$(C_SOURCE)) kernel/boot.o )
#kernel/utils.o)

usage:
	@echo "hello"

compile:
	mkdir -p $(TMP_PATH)
#	$(AS_PATH) boot.s -o tmp/boot.o
#	nasm -o tmp/boot.o -felf32 boot.asm
#	$(CC_PATH) -c main.c -o tmp/main.o $(CC_FLAGS)
#	cp linker.ld tmp/linker.ld
#	cd tmp && $(CC_PATH) -T linker.ld -o harpiaos.bin -ffreestanding -O2 -nostdlib *.o -lgcc
#	grub-file --is-x86-multiboot2 tmp/harpiaos.bin && echo $$?
	cd kernel && $(MAKE) compile
	cp linker.ld $(TMP_PATH)/linker.ld
#	cd $(TMP_PATH) && $(CC_PATH) -T linker.ld -o harpiaos.bin -ffreestanding -O2 -nostdlib $(OBJECTS) -lgcc
	$(CC_PATH) -T $(TMP_PATH)/linker.ld -o $(TMP_PATH)/harpiaos.bin -ffreestanding -O2 -nostdlib $(OBJECTS) -lgcc
	grub-file --is-x86-multiboot2 $(TMP_PATH)/harpiaos.bin && echo $$?
	mkdir -p ../boot/grub
	cp $(TMP_PATH)/harpiaos.bin ../boot/harpiaos.bin
	cp grub.cfg ../boot/grub/grub.cfg
#	rm -r tmp

$(TMP_PATH)/%.o: %.c
	$(CC_PATH) -c $< -o $@ $(CC_FLAGS)

$(OBJECTS): | tmpdir

tmpdir:
	mkdir -p $(TMP_PATH)

createdisk:
	dd if=/dev/zero of=disk.img bs=512 count=20480
	sfdisk disk.img < disk.sfdisk
	losetup /dev/loop0 disk.img
	losetup /dev/loop1 disk.img -o 1048576
	mkdosfs -F32 -f 2 /dev/loop1
	mount /dev/loop1 /mnt
	grub-install --root-directory=/mnt --no-floppy --modules="normal part_msdos fat exfat ext2 multiboot2" /dev/loop0
	losetup -d /dev/loop0
	umount /mnt
	losetup -d /dev/loop1
	cp disk.img ../clear.img
	rm disk.img