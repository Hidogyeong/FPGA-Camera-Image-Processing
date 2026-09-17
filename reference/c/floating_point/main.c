#include "main.h"


int main() {


	Image in_image; //72(u,72,0)
	Image YCbCr_image; //72(u,72,0)
	Image filtered_image;
	Image Out_image;

	readimage(&in_image);

	RtoY(&in_image, &YCbCr_image);

	filtering(&YCbCr_image,&filtered_image);

	YtoR(&filtered_image, &Out_image);
	
	writeimage(&Out_image);

	return 0;
}
