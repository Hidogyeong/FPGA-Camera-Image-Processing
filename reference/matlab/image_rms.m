floating_image = imread("DE_image.bmp");
fixed_image = imread("DE_fixed_image.bmp");

diff = double(floating_image) - double(fixed_image);

% Root Mean Square (RMS) 계산
rms_value = sqrt(mean(diff(:).^2));