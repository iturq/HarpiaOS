#include "multiboot2.h"
#include "x86_64.h"
#include "console.h"

struct multiboot_tag_framebuffer *framebufferinfo;

int halmain(unsigned long magic, unsigned long addr)
{
    struct multiboot_tag *tag;
    unsigned int size;
    
    //Extract Multiboot2 info
    size = *(unsigned int*)addr;
    tag = (struct multiboot_tag*) (addr + 8);
    while (tag->type != MULTIBOOT_TAG_TYPE_END)
    {
        switch (tag->type)
        {
        case MULTIBOOT_TAG_TYPE_FRAMEBUFFER:
            framebufferinfo = (struct multiboot_tag_framebuffer*)tag;
            break;
        }

        //tag = (struct multiboot_tag*) ((multiboot_uint32_t *)tag + ((tag->size + 7) & ~7));
        tag = (struct multiboot_tag*) ((multiboot_uint8_t *) tag + ((tag->size + 7) & ~7));
    }
    
    consoleInitFrameBuffer(
        framebufferinfo->common.framebuffer_addr,
        framebufferinfo->common.framebuffer_width,
        framebufferinfo->common.framebuffer_height
        );

    consolePuts("Hello World!\n");
    
    //Extract Multiboot2 info
    size = *(unsigned int*)addr;
    tag = (struct multiboot_tag*) (addr + 8);
    while (tag->type != MULTIBOOT_TAG_TYPE_END)
    {
        switch (tag->type)
        {
        case MULTIBOOT_TAG_TYPE_MMAP:
          {
            multiboot_memory_map_t *mmap;

            consolePuts("mmap\n");
      
            for (mmap = ((struct multiboot_tag_mmap *) tag)->entries;
                 (multiboot_uint8_t *) mmap 
                   < (multiboot_uint8_t *) tag + tag->size;
                 mmap = (multiboot_memory_map_t *) 
                   ((unsigned long) mmap
                    + ((struct multiboot_tag_mmap *) tag)->entry_size))
            {
                consolePuts("base = 0x");
                consolePutInt(mmap->addr, 16);
                consolePuts(", len = ");
                consolePutInt((mmap->len / 1024), 10);
                consolePuts("kB, type = 0x");
                consolePutInt(mmap->type, 16);
                consolePutchar('\n');
            }
          }
          break;
        }

        //tag = (struct multiboot_tag*) ((multiboot_uint32_t *)tag + ((tag->size + 7) & ~7));
        tag = (struct multiboot_tag*) ((multiboot_uint8_t *) tag + ((tag->size + 7) & ~7));
    }
    
    return 0;
}
