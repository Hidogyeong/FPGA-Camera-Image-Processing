% 랜덤 데이터 개수
numData = 130560;

% 16비트 랜덤 데이터 생성
randData = randi([0, 65535], 1, numData, 'uint16');

% 데이터를 파일에 쓰기
filePath = 'tb_data.txt';
dlmwrite(filePath, randData, 'delimiter', '\n');

disp('데이터 저장이 완료되었습니다.');
