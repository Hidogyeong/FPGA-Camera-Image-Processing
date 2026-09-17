#include "main.h"

void readimage(Image* in) {

	
	FILE* fp; //32(u,32,0)

	fopen_s(&fp, "lena.bmp", "rb");

	if (&fp == NULL) {
		printf("Can't Open\n");
		return -1;
	}
	else {
		printf("Open File\n");


		fread(&in->fh, sizeof(BITMAPFILEHEADER), 1, fp); //14(u,14,0)
		if (in->fh.bfType != 0x4D42) { // BMP FILE이 아닌 경우
			return -1;
		}

		else {

			//printf("%c%c\n", in->fh.bfType); BMP FILE인지 확인

			fread(&in->ih, sizeof(BITMAPINFOHEADER), 1, fp); //40(u,40,0)
			printf("Image Size: (%3dx%3d)\n", in->ih.biWidth, in->ih.biHeight);
			printf("BitCount: %2d\n", in->ih.biBitCount);

			in->wStep = (DWORD)(in->ih.biWidth * 3 + 3) & ~3; //32(u,32,0)

			fseek(fp, in->fh.bfOffBits, SEEK_SET);

			in->data = (BYTE*)malloc(in->wStep * in->ih.biHeight); // 4(u,4,0) * 992 * 330

			fread(in->data, in->wStep * in->ih.biHeight, 1, fp);

			fclose(fp);

			//printf("offbits = %d\n", in->fh.bfOffBits); bit 시작 위치 확인

			printf("read success\n");
			printf("\n");
		}
	}
}

void writeimage(Image* in) {

	FILE* fp;

	printf("write start\n");
	fopen_s(&fp, "DE_image.bmp", "wb");
	fwrite(&in->fh, sizeof(BITMAPFILEHEADER), 1, fp);
	fwrite(&in->ih, sizeof(BITMAPINFOHEADER), 1, fp);

	fseek(fp, in->fh.bfOffBits, SEEK_SET);

	fwrite(in->data, in->wStep * in->ih.biHeight, 1, fp);


	printf("write success\n");
	fclose(fp);

}