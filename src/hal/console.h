#ifndef CONSOLE_HEADER
#define CONSOLE_HEADER 1

struct frameCharacter
{
    char character;
    char attributes;
};

struct frameBufferInfo
{
    struct frameCharacter * fbAddr;
    int width;
    int height;
    int curX;
    int curY;
};

void consoleInitFrameBuffer(const void * addr, int width, int height);

int consolePutchar(int character);
int consolePuts(const char *str);
int consolePutInt(unsigned int value, int base);

#endif