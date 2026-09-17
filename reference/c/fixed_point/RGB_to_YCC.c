#include "main.h"


void RtoY(Image* in, Image* out) {

	out->fh = in->fh;
	out->ih = in->ih;
	out->wStep = in->wStep;

	int wid = in->ih.biWidth;
	int hei = in->ih.biHeight;
	int wStep = in->wStep;

	BYTE* R = (BYTE*)calloc(wid * hei, 1); // 8(u,8,0)
	BYTE* G = (BYTE*)calloc(wid * hei, 1);
	BYTE* B = (BYTE*)calloc(wid * hei, 1);

	BYTE* Y = (BYTE*)calloc(wid * hei, 1);
	BYTE* Cb = (BYTE*)calloc(wid * hei, 1);
	BYTE* Cr = (BYTE*)calloc(wid * hei, 1);

	
	for (int i = 0; i < hei; i++) {
		for (int j = 0; j < wid; j++) {
			R[i * wid + j] = in->data[i * wStep + j * 3+2];
			G[i * wid + j] = in->data[i * wStep + j * 3+1];
			B[i * wid + j] = in->data[i * wStep + j * 3];
		}
	}

	double err = 0;
	double Y_t;
	double Cb_t;
	double Cr_t;
	double Y_t_f;
	double Cb_t_f;
	double Cr_t_f;

	for (int i = 0; i < hei; i++) {
		for (int j = 0; j < wid; j++) {
			
			
			Y_t_f = (fixed(0.299,d_bit) * (double)R[i * wid + j] + (fixed(0.587, d_bit) * (double)G[i * wid + j]) + (fixed(0.114, d_bit) * (double)B[i * wid + j]));
			// 16(u,10,6) = 14(u,8,6) + 14(u,8,6) + 14(u,8,6)
			Y_t_f = max(0, min(255, Y_t_f));// 14(u, 8, 6);
			Y[i * wid + j] = (BYTE)Y_t_f;// 8(u, 8, 0);

			
			Cb_t_f = ((fixed(-0.16874, d_bit) * (double)R[i * wid + j]) - (fixed(0.33126, d_bit) * (double)G[i * wid + j]) + (fixed(0.5, d_bit) * (double)B[i * wid + j]) + 128);
			// 6(s,0,6) * 8(u,8,0) = 15(s,9,6)
			// 16(u, 10, 6) = 15(s,9,6) + 15(s,9,6) + 14(u, 8, 6) + 8(u,8,0) = 18(s,12,6)
			Cb_t_f = max(0, min(255, Cb_t_f));
			Cb[i * wid + j] = (BYTE)Cb_t_f;

			
			Cr_t_f = ((fixed(0.5, d_bit) * (double)R[i * wid + j]) - (fixed(0.41869, d_bit) * (double)G[i * wid + j]) - (fixed(0.08131, d_bit) * (double)B[i * wid + j]) + 128);
			Cr_t_f = max(0, min(255, Cr_t_f));
			Cr[i * wid + j] = (BYTE)Cr_t_f;

		} 
	}


	out->data = (BYTE*)calloc(wStep * hei,1);

	for (int j = 0; j < hei; j++) {
		for (int i = 0; i < wid; i++) {
				out->data[j*wStep + 3*i] = Y[j* wid + i];
				out->data[j * wStep + 3 * i+1] = Cb[j * wid + i];
				out->data[j * wStep + 3 * i+2] = Cr[j * wid + i];
		}
	}

	free(R);
	free(G);
	free(B);
	free(Y);
	free(Cr);
	free(Cb);
}

void YtoR(Image* in, Image* out) {

	out->fh = in->fh;
	out->ih = in->ih;
	out->wStep = in->wStep;
	out->data = in->data;

	int wid = in->ih.biWidth;
	int hei = in->ih.biHeight;
	int wStep = in->wStep;

	BYTE* R = (BYTE*)calloc(wid * hei, 1);
	BYTE* G = (BYTE*)calloc(wid * hei, 1);
	BYTE* B = (BYTE*)calloc(wid * hei, 1);

	BYTE* Y = (BYTE*)calloc(wid * hei, 1);
	BYTE* Cb = (BYTE*)calloc(wid * hei, 1);
	BYTE* Cr = (BYTE*)calloc(wid * hei, 1);


	for (int i = 0; i < hei; i++) {
		for (int j = 0; j < wid; j++) {
			Y[i * wid + j] = in->data[i * wStep + j * 3];
			Cb[i * wid + j] = in->data[i * wStep + j * 3 + 1];
			Cr[i * wid + j] = in->data[i * wStep + j * 3 + 2];
		}
	}

	double R_t;
	double G_t;
	double B_t;


	for (int i = 0; i < wid * hei; i++) {
		R_t = (fixed((double)Y[i],d_bit) + (fixed(1.40200, d_bit) * (double)(Cr[i] -128)));
		R_t = max(0, min(255, R_t));
		R[i] = (BYTE)R_t;

		G_t = (fixed((double)Y[i],d_bit) - (fixed(0.34414, d_bit) * (double)(Cb[i] - 128)) - (fixed(0.71414, d_bit) * (double)(Cr[i] - 128)));
		G_t = max(0, min(255, G_t));
		G[i] = (BYTE)G_t;

		B_t = (fixed((double)Y[i],d_bit) + (fixed(1.772, d_bit) * (double)(Cb[i] - 128)));
		B_t = max(0, min(255, B_t));
		B[i] = (BYTE)B_t;
	}


	out->data = (BYTE*)calloc(wStep * hei, 1);



	for (int j = 0; j < hei; j++) {
		for (int i = 0; i < wid; i++) {
				out->data[j * wStep + 3*i] = B[j* wid + i];
				out->data[j * wStep + 3*i+1] = G[j * wid + i];
				out->data[j * wStep + 3*i+2] = R[j * wid + i];
		}
	}

	free(R);
	free(G);
	free(B);
	free(Y);
	free(Cr);
	free(Cb);
}