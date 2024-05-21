#ifndef GDT_HEADER
#define GDT_HEADER 1

#include "kernel.h"

typedef struct gdt
{
    union
    {
        uint64_t entry64;
        uint32_t entry32[2];
        uint16_t entry16[4];
        uint8_t  entry8[8];
    };
}gdt_t;

int gdtinit();

#endif