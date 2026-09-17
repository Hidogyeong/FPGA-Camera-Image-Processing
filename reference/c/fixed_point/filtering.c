#include "main.h"
#include <time.h>

void filtering(Image* in, Image* out) {
	

	double log_filter[9] = { 0, -1, 0,
							-1, 4, -1,
							0, -1, 0};
	//9 * 3(u,3,0)

	out->fh = in->fh;
	out->ih = in->ih;
	out->wStep = in->wStep;
	out->data = in->data;

	//LCD Spec. 480 * 272
	int wid = in->ih.biWidth; // 9(u,9,0)
	int hei = in->ih.biHeight; // 9(u,9,0)
	int wStep = in->wStep; // 10(u,10,0)

	
	int MaskSize = 3; // 2(u,2,0)
	int AddSize = (MaskSize / 2) * 2; // 2(u,2,0)
	
	int jump = MaskSize / 2; // 1(u,1,0)

	int Pwid = wid + AddSize; // 9(u,9,0)
	int Phei = wid + AddSize; // 9(u,9,0)


	BYTE* Padding_image;


	Padding_image = (BYTE*)calloc((Pwid) * (Phei), 1);



	//////////////////////////////////Padding/////////////////////////////////////////////////

	for (int y = 0; y < Phei; y++) {
		for (int x = 0; x < Pwid; x++) {
			Padding_image[y * Pwid + x] = 0;
		}
	}


	//ori 
	for (int y = 0; y < hei; y++) {
		for (int x = 0; x < wid; x++) {
			Padding_image[(y + jump) * Pwid + (x + jump)] = in->data[y * wStep + 3*x];
		}
	}
	
	//x padding
	for (int x = 0; x < wid; x++) {
			Padding_image[x+jump] = Padding_image[Pwid + x + jump];
			Padding_image[Pwid*(Phei-1) + x + jump] = Padding_image[Pwid * (Phei - 2) + x + jump];
	}
	
	//y padding
	for (int y = 0; y < hei; y++) {
		Padding_image[(y+jump)*Pwid] = Padding_image[(y + jump) * Pwid + jump];
		Padding_image[(y+jump)*Pwid-1] = Padding_image[(y + jump) * Pwid-1-jump];
	}
	
	//edge padding
	Padding_image[0] = Padding_image[1];
	Padding_image[Pwid-1] = Padding_image[Pwid-2];
	Padding_image[(Phei-1) * Pwid] = Padding_image[(Phei-2)*Pwid];
	Padding_image[Phei * Pwid-1] = Padding_image[Phei*Pwid-2];
	
	
	//////////////////////////////////filtering/////////////////////////////////////////////////
	int point;
	double result; // 8(u,8,0) * 3(u,3,0) = 12(u,12,0)
	clock_t start = clock();
	for (int y = 0; y < hei; y++) {
		for (int x = 0; x < wid; x++) {
			result = 0;
			point = y * Pwid + x;
			for (int j = 0; j < MaskSize; j++) {
				for (int i = 0; i < MaskSize; i++) {
					result += Padding_image[j*Pwid+i + point] * log_filter[j * MaskSize + i];
				}
			}
			result = (result < 0) ? 0 : (result > (1 << 8) - 1) ? (1 << 8) - 1 : result;
			result = fixed(fixed(0.5,d_bit)*result, d_bit) + Padding_image[(y + jump) * Pwid + (x + jump)];
			// 12(u,12,0) * 6(u,0,6) = 18(u,12,6)
			result = (result < 0) ? 0 : (result > (1 << 8) - 1) ? (1 << 8) - 1 : result;
			out->data[y * wStep + 3 * x] = (BYTE)result;

		}
	}
	clock_t end = clock();
	printf("filtering_time : %lf\n", (double)(end - start)/CLOCKS_PER_SEC);

}