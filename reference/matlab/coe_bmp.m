% 입력 파일과 출력 파일의 경로 설정
inputFilePath = 'output2.ceo';
outputFilePath = 'new_output2.ceo';

% 입력 파일 열기
fidIn = fopen(inputFilePath, 'rb');
if fidIn == -1
    error('입력 파일을 열 수 없습니다.');
end

% 출력 파일 열기
fidOut = fopen(outputFilePath, 'wb');
if fidOut == -1
    fclose(fidIn);
    error('출력 파일을 열 수 없습니다.');
end

try
    % 16비트 데이터 읽기
    data16bit = fread(fidIn, 130560, 'int16');

    % 16비트 데이터를 32비트로 확장
    data32bit = int32(data16bit);

    % 32비트 데이터 쓰기
    fwrite(fidOut, data32bit, 'int32');

    % 파일 닫기
    fclose(fidIn);
    fclose(fidOut);

    disp('파일 변환이 완료되었습니다.');

catch
    % 오류 발생 시 파일 닫기
    fclose(fidIn);
    fclose(fidOut);
    error('파일 변환 중 오류가 발생했습니다.');
end