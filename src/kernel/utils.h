#ifndef UTILS_ASM_HEADER
#define UTILS_ASM_HEADER 1

#include "kernel.h"

extern void interruptenable();
extern void interruptdisable();

extern uint64_t readcr0();
extern uint64_t readcr2();
extern uint64_t readcr3();
extern uint64_t readcr4();
extern uint64_t readcr8();

extern void writecr0(uint64_t flags);
//extern void writecr2(uint64_t flags);
extern void writecr3(uint64_t pageaddress);
extern void writecr4(uint64_t flags);
extern void writecr8(uint64_t flags);

extern int memcmp(const void * ptr1, const void * ptr2, int num);
extern void* memcpy(void * destination, const void * source, int num);
extern void* memmove(void * destination, const void * source, int num);
extern void* memset(void * ptr, int value, int num);
extern int strlen(const char * str);

#endif