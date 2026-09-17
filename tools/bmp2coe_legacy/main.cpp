#include <stdio.h>
#include <stdlib.h>
#include <Windows.h>

#define FILENAME "lena_480x272.bmp"
#define COE_FILE "lena_480x272.coe"



BITMAPFILEHEADER hf;
BITMAPINFOHEADER hInfo;
RGBTRIPLE* data;//색 정보
RGBTRIPLE* rev;
int pixel;
int width, height;
unsigned short bytepi; //픽셀당 바이트 수?

int main() {
	FILE* infile;
	FILE* out;
	FILE* out2;
	int size;
	//fopen_s(&infile, "lena480_272.bmp", "rb+"); //바이너리 읽기모드
	fopen_s(&infile, FILENAME, "rb+");
	if (infile == NULL) { printf("image does not exist!\n"); return 1; }

	fread(&hf, sizeof(BITMAPFILEHEADER), 1, infile); // 파일 헤더 읽기
	fread(&hInfo, sizeof(BITMAPINFOHEADER), 1, infile); //비트맵info header 읽기


	width = hInfo.biWidth; //길이
	height = hInfo.biHeight; //높이
	bytepi = hInfo.biBitCount / 8; // 픽셀당 바이트수
	pixel = hInfo.biWidth * hInfo.biHeight; //픽셀의 갯수
	size = 3 * pixel; //RGB 세종류

	//unsigned char는 8bit 자료형 
	data = (RGBTRIPLE*)malloc(sizeof(RGBTRIPLE) * size); // data 동적할당
	rev = (RGBTRIPLE*)malloc(sizeof(RGBTRIPLE) * size); // rev  동적할당
	fread(data, 1, size, infile); //이미지 데이터 읽어오기
	fclose(infile);

	printf("width = %d \nheight = %d\nbytepi = %d\npixel = %d\nsize = %d\n", width, height, bytepi, pixel, size);

	//값 확인
	for (int i = 0; i < pixel; i++) {
		/*printf("%02x", data[i].rgbtRed);
		printf("%02x", data[i].rgbtGreen);
		printf("%02x", data[i].rgbtBlue);
		printf("\n");*/
		//printf("%d\n", i);
	}
	printf("\n");


	// 값 변환


	// raw출력 
	fopen_s(&out2, COE_FILE, "wb+");
	fprintf(out2, "memory_initialization_radix=16;\n");
	fprintf(out2, "memory_initialization_vector= ");

	//fwrite(data, 1, size, infile);           // 이미지 데이터 저장
	
	for (int i = 0; i < pixel;i++) {
		fprintf(out2,"%02x",(unsigned char)data[i].rgbtRed);
		fprintf(out2,"%02x",(unsigned char)data[i].rgbtGreen);
		fprintf(out2,"%02x",(unsigned char)data[i].rgbtBlue);
		fprintf(out2,", ");
		//printf("%d\n",i);
		
	}
	fprintf(out2, ";");


	//fwrite(&hf, sizeof(BITMAPFILEHEADER), 1, infile); // 파일헤더 저장 
	//fwrite(&hInfo, sizeof(BITMAPINFOHEADER), 1, infile); // 정보헤더 저장

	//fwrite(rev, 1, size, infile);           // 이미지 데이터 저장

	free(rev);
	fclose(out2);

/*
	// 입력 그대로 출력
	fopen_s(&out, "test_800x480.bmp", "wb+");
	fwrite(&hf, sizeof(BITMAPFILEHEADER), 1, infile); // 파일헤더 저장 
	fwrite(&hInfo, sizeof(BITMAPINFOHEADER), 1, infile); // 정보헤더 저장

	fwrite(data, 1, size, infile);           // 이미지 데이터 저장

	free(data);
	fclose(out);
*/

	return 0;
}
