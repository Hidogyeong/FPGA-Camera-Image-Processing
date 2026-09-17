% Load two BMP images
img1 = imread('lena.bmp');
img2 = imread('DE_image.bmp');
% Convert images to grayscale if they are RGB
if size(img1, 3) == 3
    img1 = rgb2gray(img1);
end
if size(img2, 3) == 3
    img2 = rgb2gray(img2);
end

% Calculate Michelson contrast for both images
max_intensity1 = double(max(img1(:)));
min_intensity1 = double(min(img1(:)));
michelson_contrast1 = (max_intensity1 - min_intensity1) / (max_intensity1 + min_intensity1);

max_intensity2 = double(max(img2(:)));
min_intensity2 = double(min(img2(:)));
michelson_contrast2 = (max_intensity2 - min_intensity2) / (max_intensity2 + min_intensity2);

% Display the Michelson contrast values
fprintf('Michelson Contrast of Image 1: %.2f', michelson_contrast1);
fprintf('Michelson Contrast of Image 2: %.2f', michelson_contrast2);

% Compare the Michelson contrast
if michelson_contrast1 > michelson_contrast2
    fprintf('Image 1 has higher Michelson contrast than Image 2.');
elif michelson_contrast1 < michelson_contrast2
    fprintf('Image 2 has higher Michelson contrast than Image 1.');
else
    fprintf('Both images have equal Michelson contrast.');
end