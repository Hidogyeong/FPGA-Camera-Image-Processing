#include "main.h"

void filtering(Image* in, Image* out) {
	

	double log_filter[9] = { 0, -1, 0,
							-1, 4, -1,
							0, -1, 0};

	out->fh = in->fh;
	out->ih = in->ih;
	out->wStep = in->wStep;
	out->data = in->data;


	int wid = in->ih.biWidth;
	int hei = in->ih.biHeight;
	int wStep = in->wStep;

	
	int MaskSize = 3;
	int AddSize = (MaskSize / 2) * 2;
	
	int jump = MaskSize / 2;

	int Pwid = wid + AddSize;
	int Phei = wid + AddSize;


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
	double result;

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
			result = 0.5*result + Padding_image[(y + jump) * Pwid + (x + jump)];
			result = (result < 0) ? 0 : (result > (1 << 8) - 1) ? (1 << 8) - 1 : result;
			out->data[y * wStep + 3 * x] = (BYTE)result;

		}
	}


}