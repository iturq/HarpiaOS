#include "kernel.h"
#include "multiboot2.h"
#include "utils.h"
#include "console.h"
#include "gdt.h"
#include "page.h"
#include "memory.h"
#include "ioport.h"

#include <cpuid.h>

kinfo_t *kernelinfo;

int readmultiboot2(struct multiboot_tag *mbtag, uint32_t size)
{
    uint64_t memorysize = 0;
    struct multiboot_tag *tag;
    tag = mbtag;
    
    // Extract Multiboot2 info
    while (tag->type != MULTIBOOT_TAG_TYPE_END)
    {
        switch (tag->type)
        {
        case MULTIBOOT_TAG_TYPE_FRAMEBUFFER:
            struct multiboot_tag_framebuffer *framebufferinfo = (struct multiboot_tag_framebuffer *)tag;
            uint8_t *fb;
            fb = (uint8_t *)framebufferinfo->common.framebuffer_addr;
            fb += kernelinfo->highmap;

            kernelinfo->fbinfo.fbaddr = (struct frameCharacter *)fb;
            kernelinfo->fbinfo.height = framebufferinfo->common.framebuffer_height;
            kernelinfo->fbinfo.width = framebufferinfo->common.framebuffer_width;
/*
            consoleInitFrameBuffer(
                fb,
                framebufferinfo->common.framebuffer_width,
                framebufferinfo->common.framebuffer_height);
*/
            break;
        case MULTIBOOT_TAG_TYPE_MMAP:
            multiboot_memory_map_t *mmap;

            for (
                mmap = ((struct multiboot_tag_mmap *)tag)->entries;
                (multiboot_uint8_t *)mmap < (multiboot_uint8_t *)tag + tag->size;
                mmap = (multiboot_memory_map_t *)((unsigned long)mmap +
                                                  ((struct multiboot_tag_mmap *)tag)->entry_size))
            {
                if(memorysize < mmap->addr + mmap->len)
                {
                    memorysize = mmap->addr + mmap->len;
                }

                uint8_t type = MEMORY_TYPE_BADRAM;
                switch (mmap->type)
                {
                case MULTIBOOT_MEMORY_AVAILABLE:
                    type = MEMORY_TYPE_FREE;
                    break;
                case MULTIBOOT_MEMORY_RESERVED:
                    type = MEMORY_TYPE_RESERVED;
                    break;
                case MULTIBOOT_MEMORY_ACPI_RECLAIMABLE:
                    type = MEMORY_TYPE_ACPI_RECLAIMABLE;
                    break;
                case MULTIBOOT_MEMORY_NVS:
                    type = MEMORY_TYPE_NVS;
                    break;
                case MULTIBOOT_MEMORY_BADRAM:
                    type = MEMORY_TYPE_BADRAM;
                    break;
                }
                
                kernelinfo->mmap[kernelinfo->mmapsize].address = mmap->addr;
                kernelinfo->mmap[kernelinfo->mmapsize].size = mmap->len;
                kernelinfo->mmap[kernelinfo->mmapsize].type = type;
                kernelinfo->mmapsize++;
            }

            //pageinit(memorysize);
            kernelinfo->maxmem = memorysize;

            break;
        }

        tag = (struct multiboot_tag *)((multiboot_uint8_t *)tag + ((tag->size + 7) & ~7));
    }
    
    return 0;
}

void kernelinfoinit(uint64_t highmap, uint64_t baseaddress, uint64_t topaddress)
{
    kernelinfo->numcores = 1;
    kernelinfo->kernelbase = baseaddress;
    kernelinfo->kerneltop = topaddress;
    kernelinfo->highmap = highmap;
    kernelinfo->cr3 = readcr3();
    kernelinfo->mmapsize = 0;
    kernelinfo->pagesize = NUM_2MB;
}

void printmemmap()
{
    int i;
    consolePuts("memory map:\n");
    for (i = 0; i < kernelinfo->mmapsize; i++)
    {
        if(kernelinfo->mmap[i].size > 0)
        {
            consolePuts("Addr: ");
            consolePutInt((uint64_t)kernelinfo->mmap[i].address, 16);
            consolePuts(", size: ");
            consolePutInt((uint64_t)kernelinfo->mmap[i].size, 16);
            consolePuts(", size: ");
            consolePutInt((uint64_t)kernelinfo->mmap[i].type, 10);
            consolePutchar('\n');
        }
    }
    
}

int kmain(uint64_t magic, uint64_t addr, uint64_t highmap, uint64_t baseaddress, uint64_t topaddress)
{
    if(magic != 0x36D76289)
    {
        return -1;
    }

    kernelinfo = (kinfo_t*)(highmap + 0x0500);
    kernelinfoinit(highmap, baseaddress, topaddress);

    //Init memory info so we can alloc
    //memoryinit(baseaddress, topaddress);

    //read multiboot2 structure and write info to kernelinfo strucutre
    readmultiboot2((struct multiboot_tag *)(addr + 8), *(uint32_t *)addr);
    //init framebuffer
    consoleInitFrameBuffer();
    //We can print messages
    consolePuts("Hello from kmain.\n");

    memoryinit();

    printmemmap();

    return 0;
}
