#ifndef CONSOLE_HEADER
#define CONSOLE_HEADER 1

#include "kernel.h"

void consoleInitFrameBuffer();

int consolePutchar(int character);
int consolePuts(const char *str);
int consolePutInt(uint64_t value, int base);

#endif