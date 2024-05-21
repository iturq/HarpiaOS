/* The bootloader will look at this image and start execution at the symbol
   designated as the entry point. */
ENTRY(_start)
 
/* Tell where the various sections of the object files will be put in the final
   kernel image. */
SECTIONS
{
	/* It used to be universally recommended to use 1M as a start offset,
	   as it was effectively guaranteed to be available under BIOS systems.
	   However, UEFI has made things more complicated, and experimental data
	   strongly suggests that 2M is a safer place to load. In 2016, a new
	   feature was introduced to the multiboot2 spec to inform bootloaders
	   that a kernel can be loaded anywhere within a range of addresses and
	   will be able to relocate itself to run from such a loader-selected
	   address, in order to give the loader freedom in selecting a span of
	   memory which is verified to be available by the firmware, in order to
	   work around this issue. This does not use that feature, so 2M was
	   chosen as a safer option than the traditional 1M. */
	. = 2M;
 
	/* First put the multiboot header, as it is required to be put very early
	   in the image or the bootloader won't recognize the file format.
	   Next we'll put the .text section. */

	high_base_addr = 0x010000000000;
	base_address = . + high_base_addr;

	.boottext ALIGN(4K) : ALIGN(4K)
	{
		*boot.o(.text)
		*boot.o(.data)
	}
	.bootbss ALIGN(4K) : ALIGN(4K)
	{
		*boot.o(.bss)
	}
	. = ALIGN(4K);
	HIDDEN(boot_end = .);

	/*High kernel map*/
	. += high_base_addr;
	.text ALIGN(4K) : AT(boot_end) ALIGN(4K)
	{
		*(.text)
	}
	. = ALIGN(4K);
	HIDDEN(text_end = . - high_base_addr);
 
	/* Read-only data. */
	.rodata ALIGN(4K) : AT(text_end) ALIGN(4K)
	{
		*(.rodata*)
	}
	. = ALIGN(4K);
	HIDDEN(rodata_end = . - high_base_addr);
 
	/* Read-write data (initialized) */
	.data ALIGN(4K) : AT(rodata_end) ALIGN(4K)
	{
		*(.data)
	}
	. = ALIGN(4K);
	HIDDEN(data_end = . - high_base_addr);
 
	/* Read-write data (uninitialized) and stack */
	.bss ALIGN(4K) : AT(data_end) ALIGN(4K)
	{
		*(COMMON)
		*(.bss)
	}
	. = ALIGN(4K);
	HIDDEN(bss_end = . - high_base_addr);

	top_address = . ;
 
	/* The compiler may produce other sections, by default it will put them in
	   a segment with the same name. Simply add stuff here as needed. */
}