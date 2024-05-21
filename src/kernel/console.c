#include "console.h"
#include "utils.h"

//struct frameBufferInfo fbInfo;

void consoleInitFrameBuffer()
{
    framebufferinfo_t *fbinfo = &(kernelinfo->fbinfo);

    fbinfo->curX = 0;
    fbinfo->curY = 0;

    int i, k;
    for (i = 0; i < fbinfo->width; i++)
    {
        for (k = 0; k < fbinfo->height; k++)
        {
            (fbinfo->fbaddr + 2*(i*fbinfo->width + k))->character = 0;
            (fbinfo->fbaddr + 2*(i*fbinfo->width + k) + 1)->attributes = 7;
        }
    }
}

/*
int strlen(const char* str) 
{
	int len = 0;
	while (str[len])
		len++;
	return len;
}
*/

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
    framebufferinfo_t *fbinfo = &(kernelinfo->fbinfo);

    if(character == '\n')
    {
        fbinfo->curX = 0;
        fbinfo->curY++;
    }
    else
    {
        (fbinfo->fbaddr + fbinfo->width*fbinfo->curY + fbinfo->curX)->character = character;
        if (++fbinfo->curX == fbinfo->width) {
            fbinfo->curX = 0;
            if (++fbinfo->curY == fbinfo->height)
                fbinfo->curY = 0;
        }
    }

    return character;
}

int consolePutInt(uint64_t value, int base)
{
    char buffer[32];
    int buflen, i;
    uint64_t ival, digi;

    buflen = 32;
    ival = value;

    if(base <= 0)
    {
        return -1;
    }

    if(value == 0)
    {
        consolePutchar('0');
        return 0;
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