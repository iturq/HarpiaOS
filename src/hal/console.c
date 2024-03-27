#include "console.h"

struct frameBufferInfo fbInfo;

void consoleInitFrameBuffer(const void * addr, int width, int height)
{
    fbInfo.fbAddr = (struct frameCharacter *) addr;
    fbInfo.width = width;
    fbInfo.height = height;
    fbInfo.curX = 0;
    fbInfo.curY = 0;

    int i, k;
    for (i = 0; i < fbInfo.width; i++)
    {
        for (k = 0; k < fbInfo.height; k++)
        {
            (fbInfo.fbAddr + 2*(i*fbInfo.width + k))->character = 0;
            (fbInfo.fbAddr + 2*(i*fbInfo.width + k) + 1)->attributes = 7;
        }
    }
}

int strlen(const char* str) 
{
	int len = 0;
	while (str[len])
		len++;
	return len;
}

int consolePuts(const char *str)
{
    int i, len;

    len = strlen(str);
    for (i = 0; i < len; i++)
    {
        consolePutchar(str[i]);
    }
    return i - 1;
}

int consolePutchar(int character)
{
    if(character == '\n')
    {
        fbInfo.curX = 0;
        fbInfo.curY++;
    }
    else
    {
        (fbInfo.fbAddr + fbInfo.width*fbInfo.curY + fbInfo.curX)->character = character;
        if (++fbInfo.curX == fbInfo.width) {
            fbInfo.curX = 0;
            if (++fbInfo.curY == fbInfo.height)
                fbInfo.curY = 0;
        }
    }

    return character;
}

int consolePutInt(unsigned int value, int base)
{
    char buffer[32];
    int buflen, i;
    unsigned int ival, digi;

    buflen = 32;
    ival = value;

    if(base <= 0)
    {
        return -1;
    }

    for (i = buflen - 1; i >= 0 && ival != 0; i--)
    {
        digi = ival % base;
        if(digi < 0xA)
        {
            buffer[i] = '0' + digi;
        }
        else
        {
            buffer[i] = 'A' + digi - 0xA;
        }
        ival /= base;
    }

    for (i++; i < buflen; i++)
    {
        consolePutchar(buffer[i]);
    }

    return 0;
}