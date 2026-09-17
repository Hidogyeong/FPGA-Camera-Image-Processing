%%

Ori_image = imread('Yuri.bmp');
laplacian_filter = [ 0, -1, 0; -1, 4, -1; 0, -1, 0 ];

%%  RGB to YCbCr

ycbcr_image = rgb2ycbcr(Ori_image);

Y_channel = ycbcr_image(:,:,1);
Ori_Y_Iamge(:,:,1) = Y_channel;
Ori_Y_Iamge(:,:,2) = Y_channel;
Ori_Y_Iamge(:,:,3) = Y_channel;

imwrite(Ori_Y_Iamge,'Ori_Y_Iamge.bmp');


%%

filterd_Y = imfilter(Y_channel,laplacian_filter);

filterd_Y_Iamge(:,:,1) = filterd_Y; 
filterd_Y_Iamge(:,:,2) = filterd_Y;
filterd_Y_Iamge(:,:,3) = filterd_Y;

imwrite(filterd_Y_Iamge,'filterd_Y_Iamge.bmp');

%%
filterd_Y = int16(filterd_Y);
Y_channel = int16(Y_channel);
%%
Y_Out_image = Y_channel + 0.8*filterd_Y;
Y_Out_image = max(Y_Out_image, 0);
Y_Out_image = min(Y_Out_image, 255);
Y_Out_image = uint8(Y_Out_image);

%%
temp_image = ycbcr_image;
temp_image(:,:,1) = Y_Out_image;


Out_image = ycbcr2rgb(temp_image);

imwrite(Out_image,'output.bmp');

temp_image(:,:,2) = Y_Out_image;
temp_image(:,:,3) = Y_Out_image;
imwrite(temp_image,'Y_output.bmp');