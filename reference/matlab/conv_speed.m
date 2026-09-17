% 이미지 크기와 필터 정의
imageSize = [330, 330];
numConvolutions = 330;
filterSize = [3, 3];

% 랜덤 이미지와 필터 생성 (GPU 배열로 변환)
imageChannel = gpuArray(rand(imageSize(1), imageSize(2)));
filter = gpuArray(rand(filterSize(1), filterSize(2)));

% 시간 측정 시작
tic;

% 채널에 대한 컨볼루션 연산 수행
result = zeros(imageSize(1), imageSize(2), 'gpuArray');
for i = 1:numConvolutions
    result = conv2(imageChannel, filter, 'same');
end

% 시간 측정 종료 및 결과 확인 (예제에서는 결과를 사용하지 않음)
elapsedTime = toc;
disp(['컨볼루션 연산이 완료되었습니다. 소요된 시간: ', num2str(elapsedTime), ' 초']);
