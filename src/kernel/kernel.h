#ifndef KERNEL_HEADER
#define KERNEL_HEADER 1

#include <stdint.h>
#include <stdbool.h>
#include <stddef.h>

struct frameCharacter
{
    char character;
    char attributes;
};

typedef struct framebufferinfo
{
    struct frameCharacter * fbaddr;
    int width;
    int height;
    int curX;
    int curY;
} framebufferinfo_t;

typedef struct memorymap
{
    uint64_t address;
    uint64_t size;
    int16_t type;
} memorymap_t;

typedef struct pagephysmap
{
    uint8_t entry;
} pagephysmap_t;

typedef struct cpuinfo
{
    uint64_t stackbase;
    uint64_t stacktop;
} cpuinfo_t;

typedef struct kinfo
{
    uint64_t kernelbase;
    uint64_t kerneltop;
    uint8_t numcores;
    //memory
    uint64_t maxmem;
#define MEMORY_MAP_SIZE  32
    memorymap_t mmap[MEMORY_MAP_SIZE];
    uint8_t mmapsize;
    //framebuffer
    framebufferinfo_t fbinfo;
    //page
    uint64_t highmap;
    uint64_t cr3;
    uint32_t pagesize;
    pagephysmap_t physmap[32];
    //gdt
    uint64_t gdtaddr;
    uint8_t idtindex;
    uint8_t tssindex;
#define MAX_CORES   1
    cpuinfo_t cpuinfo[MAX_CORES];
} kinfo_t;

extern kinfo_t *kernelinfo;

#endif