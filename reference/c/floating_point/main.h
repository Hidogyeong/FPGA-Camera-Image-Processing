#include <windows.h>
#include <stdio.h>
#include <math.h>

#define BitDepth 8
#define PixRange (1 << BitDepth)
#define MinVal    0
#define MaxVal    (1 << BitDepth) - 1
#define filter_size 9

typedef struct Image {
	BYTE* data;
	BITMAPFILEHEADER fh;
	BITMAPINFOHEADER ih;
	DWORD wStep;
}Image;


void readimage(Image* in);
void writeimage(Image* in);

void RtoY(Image* in, Image* out);
void YtoR(Image* in, Image* out);

void filtering(Image* in, Image* out);

