% 입력 이미지 데이터 (R, G, B)와 출력 데이터 (Y, Cb, Cr)를 가정합니다.
% wid는 이미지의 너비를 나타냅니다.
% d_bit는 고정 소수점 연산에 사용되는 비트 수를 나타냅니다.

R = 80;
G = 20;
B = 56;

Y_1 = floor((double(0.299) * 2^6)) / 2^6;
Y_2 = floor((double(0.587) * 2^6)) / 2^6;
Y_3 = floor((double(0.114) * 2^6)) / 2^6;

Cb_1 = floor((double(0.16874) * 2^6)) / 2^6;
Cb_2 = floor((double(0.33126) * 2^6)) / 2^6;
Cb_3 = floor((double(0.5) * 2^6)) / 2^6;

Cr_1 = floor((double(0.5) * 2^6)) / 2^6;
Cr_2 = floor((double(0.41869) * 2^6)) / 2^6;
Cr_3 = floor((double(0.08131) * 2^6)) / 2^6;
% Y 계산

        Y_t_f = Y_1 * double(R) + Y_2 * double(G) + Y_3 * double(B);
        Y_t_f = max(0, min(255, floor(Y_t_f))); % 반올림하여 정수로 변환
        Y = uint8(Y_t_f); % uint8 형식으로 변환하여 저장


% Cb 계산


        Cb_t_f = (- Cb_1 * double(R) - Cb_2 * double(G) + Cb_3 * double(B) + 128);
        Cb_t_f = max(0, min(255, floor(Cb_t_f)));
        Cb = uint8(Cb_t_f);


% Cr 계산
        Cr_t_f = (Cr_1 * double(R) - Cr_2 * double(G) - Cr_3 * double(B));
        Cr_t_f = max(0, min(255, floor(Cr_t_f)));
        Cr = uint8(Cr_t_f);
