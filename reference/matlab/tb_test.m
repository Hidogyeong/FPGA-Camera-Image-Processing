% 파일 경로0.1
filePath = 'tb_data.txt';

% 파일 읽기
data = importdata(filePath);

disp('데이터 읽기가 완료되었습니다.');

%%
%RGB 나누기

R5 = zeros(1,130560);
G6 = zeros(1,130560);
B5 = zeros(1,130560);

for i = 1:130560

    R5(i) = bitshift(data(i),-11);
    G6(i) = mod(bitshift(data(i),-5),pow2(6));
    B5(i) = mod(data(i),pow2(5));

end

%%
%RGB565_to_RGB888
% 8(u,8,0)

R8 = zeros(1,130560);
G8 = zeros(1,130560);
B8 = zeros(1,130560);


for i = 1:130560

    R8(i) = bitshift(R5(i),3);
    G8(i) = bitshift(G6(i),2);
    B8(i) = bitshift(B5(i),3);

end

%%
%RGB888_to_YUV_step1
% 6(u,0,6)

Y_1 = floor(pow2(0.299,6));
Y_2 = floor(pow2(0.587,6));
Y_3 = floor(pow2(0.114,6));

Cb_1 = floor(pow2(0.16874,6));
Cb_2 = floor(pow2(0.33126,6));
Cb_3 = floor(pow2(0.5,6));

Cr_1 = floor(pow2(0.5,6));
Cr_2 = floor(pow2(0.41869,6));
Cr_3 = floor(pow2(0.08131,6));

% 14(u,8,6)
fixed_128 = pow2(128,6);

%%
%RGB888_to_YUV_step2
% 14(u,8,6) + 14(u,8,6) + 14(u,8,6) + 14(u,8,0)
% 17(u,11,6)

Y = zeros(1,130560);
Cb = zeros(1,130560);
Cr = zeros(1,130560);

for i = 1:130560

    Y(i) = Y_1*R8(i) + Y_2*G8(i) + Y_3*B8(i);
    Cb(i) = -Cb_1*R8(i) - Cb_2*G8(i) + Cb_3*B8(i) + fixed_128;
    Cr(i) = Cr_1*R8(i) - Cr_2*G8(i) - Cr_3*B8(i) + fixed_128;

end

%%
%RGB888_to_YUV_step3
% 8(u,8,0)

Y8 = zeros(1,130560);
Cb8 = zeros(1,130560);
Cr8 = zeros(1,130560);

for i = 1:130560

    Y8(i) = bitshift(Y(i),-6);
    Cb8(i) = bitshift(Cb(i),-6);
    Cr8(i) = bitshift(Cr(i),-6);

end
zeroIndicesY8 = find(Y8 == 0);
zeroIndicesCb8 = find(Cb8 == 0);
zeroIndicesCr8 = find(Cr8 == 0);

% Display or use the indices as needed
disp('Indices where Y8 values are 0:');
disp(zeroIndicesY8);

disp('Indices where Cb8 values are 0:');
disp(zeroIndicesCb8);

disp('Indices where Cr8 values are 0:');
disp(zeroIndicesCr8);

%%
%filtering_step1
%중간 픽셀 빼고 전부 뺄셈
%4(u,4,0)
laplace = [0, 1, 0, 1, 4, 1, 0, 1, 0];
sharpening = [1, 1, 1, 1, 9, 1, 1, 1 ,1];

 
Y_fd = zeros(1,130560);
% 데이터를 GPU로 이동
Y8_gpu = gpuArray(Y8);

tic;

elapsed_time = toc;
fprintf('코드 실행 시간: %f 초\n', elapsed_time);

% 결과를 CPU로 이동
Y_fd = gather(Y_fd_gpu);

% (y-1)*480 + x == pixcel addr
% for x = 480:-1:1
%     for y = 1:272
%       Edge  
%         if(x==480 && y==1) 
%             Y_fd(480) = -Y8(480)*laplace(1) -Y8(480)*laplace(2) -Y8(479)*laplace(3) - ...
%                     Y8(480)*laplace(4) +Y8(480)*laplace(5) -Y8(479)*laplace(6) - ... 
%                     Y8(480)*laplace(7) -Y8(960)*laplace(8) -Y8(959)*laplace(9);          
% 
% 
%         elseif(x==1 && y==1)
%             Y_fd(1) = -Y8(2)*laplace(1) -Y8(1)*laplace(2) -Y8(1)*laplace(3) - ...
%                     Y8(2)*laplace(4) +Y8(1)*laplace(5) -Y8(1)*laplace(6) - ... 
%                     Y8(482)*laplace(7) -Y8(481)*laplace(8) -Y8(481)*laplace(9); 
% 
% 
%         elseif(x==480 && y==272)
%             Y_fd(130560) = -Y8(130080)*laplace(1) -Y8(130080)*laplace(2) -Y8(130079)*laplace(3) - ...
%                     Y8(130560)*laplace(4) +Y8(130560)*laplace(5) -Y8(130559)*laplace(6) - ... 
%                     Y8(130560)*laplace(7) -Y8(130560)*laplace(8) -Y8(130559)*laplace(9); 
% 
%         elseif(x==1 && y==272)
%             Y_fd(130081) = -Y8(129602)*laplace(1) -Y8(129601)*laplace(2) -Y8(129601)*laplace(3) - ...
%                     Y8(130082)*laplace(4) +Y8(130081)*laplace(5) -Y8(130081)*laplace(6) - ... 
%                     Y8(130082)*laplace(7) -Y8(130081)*laplace(8) -Y8(130081)*laplace(9); 
%        line
%         elseif(y == 1)
%             Y_fd(480*(y-1)+x) = -Y8(480*(y-1)+x+1)*laplace(1) -Y8(480*(y-1)+x)*laplace(2) -Y8(480*(y-1)+x-1)*laplace(3) - ...
%                     Y8(480*(y-1)+x+1)*laplace(4) +Y8(480*(y-1)+x)*laplace(5) -Y8(480*(y-1)+x-1)*laplace(6) - ... 
%                     Y8(480*(y)+x+1)*laplace(7) -Y8(480*(y)+x)*laplace(8) -Y8(480*(y)+x-1)*laplace(9); 
% 
%         elseif(y==272) 
%             Y_fd(480*(y-1)+x) = -Y8(480*(y-2)+x+1)*laplace(1) -Y8(480*(y-2)+x)*laplace(2) -Y8(480*(y-2)+x-1)*laplace(3) - ...
%                     Y8(480*(y-1)+x+1)*laplace(4) +Y8(480*(y-1)+x)*laplace(5) -Y8(480*(y-1)+x-1)*laplace(6) - ... 
%                     Y8(480*(y-1)+x+1)*laplace(7) -Y8(480*(y-1)+x)*laplace(8) -Y8(480*(y-1)+x-1)*laplace(9); 
% 
% 
%         elseif(x==1)
%             Y_fd(480*(y-1)+x) = -Y8(480*(y-2)+x+1)*laplace(1) -Y8(480*(y-2)+x)*laplace(2) -Y8(480*(y-2)+x)*laplace(3) - ...
%                     Y8(480*(y-1)+x+1)*laplace(4) +Y8(480*(y-1)+x)*laplace(5) -Y8(480*(y-1)+x)*laplace(6) - ... 
%                     Y8(480*(y)+x+1)*laplace(7) -Y8(480*(y)+x)*laplace(8) -Y8(480*(y)+x)*laplace(9); 
% 
% 
%         elseif(x==480)
%             Y_fd(480*(y-1)+x) = -Y8(480*(y-2)+x)*laplace(1) -Y8(480*(y-2)+x)*laplace(2) -Y8(480*(y-2)+x-1)*laplace(3) - ...
%                     Y8(480*(y-1)+x)*laplace(4) +Y8(480*(y-1)+x)*laplace(5) -Y8(480*(y-1)+x-1)*laplace(6) - ... 
%                     Y8(480*(y)+x)*laplace(7) -Y8(480*(y)+x)*laplace(8) -Y8(480*(y)+x-1)*laplace(9); 
% 
%       nomal
%         else
%             Y_fd(480*(y-1)+x) = -Y8(480*(y-2)+x+1)*laplace(1) -Y8(480*(y-2)+x)*laplace(2) -Y8(480*(y-2)+x-1)*laplace(3) - ...
%                     Y8(480*(y-1)+x+1)*laplace(4) +Y8(480*(y-1)+x)*laplace(5) -Y8(480*(y-1)+x-1)*laplace(6) - ... 
%                     Y8(480*(y)+x+1)*laplace(7) -Y8(480*(y)+x)*laplace(8) -Y8(480*(y)+x-1)*laplace(9); 
% 
% 
%         end
% 
%     end
% end

%% 
%Y_fd_cliping

Y_cliped = zeros(1,130560);

for i = 1:130560
    if Y_fd(i) < 0
        Y_cliped(i) = 0;
    elseif Y_fd(i) > 255
        Y_cliped(i) = 255;
    else
        Y_cliped(i) = Y_fd(i);
    end

end


%%
%ori+filtered_image
% 8(u,8,0)

Y_result = zeros(1,130560);

for i = 1:130560

    Y_result(i) = Y8(i)+0.5*Y_cliped(i);
    
end

Y_r_c = zeros(1,130560);

for i = 1:130560

    if Y_result(i) < 0
        Y_r_c(i) = 0;
    elseif Y_result(i) > 255
        Y_r_c(i) = 255;
    else
        Y_r_c(i) = Y_result(i);
    end

end

%%
%YCbCr_to_RGB888
% 7(u,1,6)

R_3 = floor(pow2(1.40200,6));

G_2 = floor(pow2(0.34414,6));
G_3 = floor(pow2(0.71414,6));

B_2 = floor(pow2(1.772,6));

R8_r = zeros(1,130560);
G8_r = zeros(1,130560);
B8_r = zeros(1,130560);


% 15(u,9,6) + 15(u,9,6) + 15(u,9,6)
% 17(u,11,6)
for i = 1:130560
    R8_r(i) = pow2(Y_r_c(i),6) + R_3*(Cr8(i)-128);
    G8_r(i) = pow2(Y_r_c(i),6) - G_2*(Cb8(i)-128) - G_3*(Cr8(i)-128);
    B8_r(i) = pow2(Y_r_c(i),6) + B_2*(Cb8(i)-128);
end
%%
%cliping
for i = 1:130560


    if R8_r(i) < 0
        R8_r(i) = 0;
    elseif R8_r(i) > (bitshift(1, 14) - 1)
        R8_r(i) = bitshift(1, 14) - 1;
    else
        R8_r(i) = R8_r(i);
    end

    if  G8_r(i) < 0
        G8_r(i) = 0;
    elseif G8_r(i) > (bitshift(1, 14) - 1)
        G8_r(i) = bitshift(1, 14) - 1;
    else
        G8_r(i) = G8_r(i);
    end

    if B8_r(i) < 0
        B8_r(i) = 0;
    elseif B8_r(i) > (bitshift(1, 14) - 1)
        B8_r(i) = bitshift(1, 14) - 1;
    else
        B8_r(i) = B8_r(i);
    end
      

end
%%
for i = 1:130560

    R8_r(i) = bitshift(R8_r(i),-6);
    G8_r(i) = bitshift(G8_r(i),-6);
    B8_r(i) = bitshift(B8_r(i),-6);

end
%%
%RGB888_to_RGB565

R5_r = zeros(1,130560);
G6_r = zeros(1,130560);
B5_r = zeros(1,130560);

for i = 1:130560

    R5_r(i) = bitshift(R8_r(i),-3);
    G6_r(i) = bitshift(G8_r(i),-2);
    B5_r(i) = bitshift(B8_r(i),-3);

end

%%
%make_outdata

data_out = zeros(1,130560);

for i = 1:130560

    data_out(i) = bitshift(R5_r(i),11) + bitshift(G6_r(i),5) + B5_r(i); 

end

fid = fopen('tb_result_data.txt', 'w');
fprintf(fid, '%d\n', data_out);
fclose(fid)


%%


