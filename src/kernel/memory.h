#ifndef MEMORY_HEADER
#define MEMORY_HEADER 1

#include "kernel.h"

#define MEMORY_TYPE_FREE                        0
#define MEMORY_TYPE_SYSTEM                      1
#define MEMORY_TYPE_DEVICE                      2
#define MEMORY_TYPE_SERVICE                     3
#define MEMORY_TYPE_USER                        4
#define MEMORY_TYPE_HARDWARE                    6
#define MEMORY_TYPE_RESERVED                    7
#define MEMORY_TYPE_ACPI_RECLAIMABLE            8
#define MEMORY_TYPE_NVS                         9
#define MEMORY_TYPE_BADRAM                      10

int memoryinit();
int memorymapset(uint64_t baseaddress, uint64_t lenght, uint8_t type);
uint8_t * memoryalloc(uint64_t size);
void free(uint8_t *);

#endif