#include "memory.h"
#include "page.h"

uint8_t* allocbase;
uint8_t* alloctop;

typedef struct memoryblock
{
    struct memoryblock *next;
    uint32_t size;
#define MEMORY_BLOCK_MIN_SIZE                       16
    int8_t flag;
#define MEMORY_BLOCK_FLAG_ALLOCATED                 1
#define MEMORY_BLOCK_SET_FLAG(flag, field)          (flag | field)
#define MEMORY_BLOCK_CLEAR_FLAG(flag, field)        (flag & ~field)
#define MEMORY_BLOCK_IS_FREE(flag)                  (!(flag & MEMORY_BLOCK_FLAG_ALLOCATED))
#define MEMORY_BLOCK_IS_ALLOCATED(flag)             (flag & MEMORY_BLOCK_FLAG_ALLOCATED)
    uint8_t *data;
} memoryblock_t;

memoryblock_t *memblockroot;

int memoryinit()
{
    uint64_t tmp;

    allocbase = (uint8_t*)kernelinfo->kerneltop;
    tmp = (uint64_t)allocbase;
    alloctop = (uint8_t *)((tmp + kernelinfo->pagesize - 1) & ~(kernelinfo->pagesize - 1));

    memblockroot = (memoryblock_t *)allocbase;
    memblockroot->next = NULL;
    memblockroot->size = alloctop - allocbase - sizeof(memoryblock_t);
    memblockroot->flag = 0;
    memblockroot->data = allocbase + sizeof(memoryblock_t);

    return 0;
}

int memorymapset(uint64_t baseaddress, uint64_t lenght, uint8_t type)
{
    memorymap_t *memmap = kernelinfo->mmap;
    uint8_t memmapentries = kernelinfo->mmapsize;

    if(memmapentries == MEMORY_MAP_SIZE)
    {
        return -1;
    }

    memmap[memmapentries].address = baseaddress;
    memmap[memmapentries].size = lenght;
    memmap[memmapentries].type = type;

    kernelinfo->mmapsize++;

    return 0;
}

uint8_t * memoryalloc(uint64_t size)
{
    uint8_t *retmem = NULL;
    memoryblock_t *mblock = memblockroot;

    for(mblock = memblockroot; mblock->next != NULL && retmem == NULL; mblock = mblock->next)
    {
        if(MEMORY_BLOCK_IS_FREE(mblock->flag) && mblock->size > size)
        {
            if(mblock->size > size + sizeof(memoryblock_t) + MEMORY_BLOCK_MIN_SIZE)
            {
                memoryblock_t *newblock;
                uint8_t *tmp;
                uint32_t dist;

                dist = size % MEMORY_BLOCK_MIN_SIZE;
                dist = size + MEMORY_BLOCK_MIN_SIZE - dist;
                tmp = mblock->data + dist;
                newblock = (memoryblock_t *)tmp;

                newblock->flag = MEMORY_BLOCK_CLEAR_FLAG(newblock->flag, MEMORY_BLOCK_FLAG_ALLOCATED);
                newblock->size = mblock->size - dist - sizeof(memoryblock_t);
                newblock->data = tmp + sizeof(memoryblock_t);
                newblock->next = mblock->next;

                mblock->next = newblock;
                mblock->size = dist;
            }
            else
            {
                mblock->flag = MEMORY_BLOCK_FLAG_ALLOCATED;
            }
            retmem = mblock->data;
        }
    }

    return retmem;
}

void free(uint8_t *address)
{
    memoryblock_t *mblock, *prev = NULL;

    //find block with address
    for(mblock = memblockroot; mblock->next != NULL; mblock = mblock->next)
    {
        if(mblock->data <= address && address < mblock->data + mblock->size)
        {
            //Found block
            mblock->flag = MEMORY_BLOCK_CLEAR_FLAG(mblock->flag, MEMORY_BLOCK_FLAG_ALLOCATED);

            //Check if next is free too
            if(MEMORY_BLOCK_IS_FREE(mblock->next->flag))
            {
                mblock->size = mblock->next->size + sizeof(memoryblock_t);
                mblock->next = mblock->next->next;
            }
            //Check if previous is free too
            if(prev != NULL && MEMORY_BLOCK_IS_FREE(prev->flag))
            {
                prev->size = mblock->size + sizeof(memoryblock_t);
                prev->next = mblock->next;
            }
        }
        prev = mblock;
    }
}