% 원본 BMP 파일 경로
inputFilePath = 'DE_fixed_image.bmp';

% 결과 BMP 파일 경로
outputFilePath = 'tb_image_480_272.bmp';

% 원본 BMP 파일 읽기
img = imread(inputFilePath);

% 원하는 크기로 이미지 크기 변경
resizedImg = imresize(img, [272, 480]);

% 크기 변경된 이미지를 새로운 BMP 파일로 저장
imwrite(resizedImg, outputFilePath, 'bmp');

disp('크기 변경이 완료되었습니다.');
