clc;clear;close all;
tic;
addpath(genpath('image'));
addpath(genpath('cho_code'));
img = 'noisy_image_3.png';%'3.png';%'snow_input.png';%'originalfog.jpg'; %'canon.jpg';%'mountain_input.png';%'canon.jpg';%'originalfog.jpg';%'example04.png';
inputfile = ['image\',img];
image = double(imread(inputfile))/255;  %09_hazy.png
% image = imresize(image, 0.4);%ͼ��ϴ�ʱ���ô˴���
if ~exist('omega', 'var')
    omega = 0.95;
end

if ~exist('win_size', 'var')
    win_size = 15;
end

 r = win_size*4;%�˲��뾶   һ�����ֵ�˲��뾶Ϊ��ⰵͨ��ʱʹ�õ���Сֵ�˲��뾶��4~8��
 eps = 1e-3;%������  ��1e-5

[m, n, ~] = size(image);

%dark_channel = get_dark_channel(image, win_size);  herzeliya_a = [0.666, 0.936 ,1.08]
dark_channel = get_dark_channel(image, win_size); %castle_a = [0.575, 0.6125 ,0.7]
atmosphere = get_atmosphere(image,dark_channel); %snow_mountain = [0.675, 0.68, 0.66]
%atmosphere = [0.666, 0.936 ,1.08]; %Dubai = A=[0.73 ,0.76, 0.8] 
%HongKong A=[0.617, 0.73, 0.883]; Swans A=[1.14, 1.24, 1.32]
%Flags A=[0.94, 0.97, 0.986]
%atmosphere = [0.617, 0.73, 0.883];
%atmosphere = [0.575, 0.6125 ,0.7];%[1.14, 1.24, 1.32];
%atmosphere = [0.73 ,0.76, 0.8];
% atmosphere = [0.675, 0.68, 0.66];
trans_est = get_transmission_estimate(image(), atmosphere,omega,win_size);
dxtrans_est=guidedfilter(rgb2gray(image),trans_est,r,eps);%�����˲�ϸ��͸����
dxtrans_est = max(dxtrans_est, 0.1);
% [t]=tsl(image,atmosphere);
%image(:,:,1)
%lambda = 0.01;
%lambda = 0.004;
lambda = 0.01;
% wei_grad = 0.0;
kappa = 2.0;
%S = image;
%B2 = image;

for i = 1:3
    %J(x)=I(x)t(x)+A(1-t(x))
%  B = (image(:,:,i) - atmosphere(:,i) .* (1-dxtrans_est))./dxtrans_est;
%     S(:,:,i)=B;
%     B = (image(:,:,i) - atmosphere(:,i))./dxtrans_est+atmosphere(:,i)
%B =  atmosphere(:,i) .* (1-trans_est) - image(:,:,i);
%B
    %B = B ./ trans_est;
%     kernel = eye(3)/255;
%     kernel(1,1) = 0;
%     kernel(3,3) = 0;
%     kernel
kernel = 1;
%     %B2(:,:,i) = B;
% S(:,:,i) = L0Deblur_dark_chanelBD(B, kernel, lambda,dxtrans_est,kappa);
S(:,:,i) = L0Deblur_dark_chanelBD(image(:,:,i), kernel, lambda,dxtrans_est,atmosphere(i), kappa);
%S(:,:,i) = L0Deblur_dark_chanelBD(B, kernel, lambda, kappa);
%S(:,:,i)=B;
%     S(:,:,i) = S(:,:,i) ./ dxtrans_est;
end
toc;
%imshow(B);
%imshow(B2);

% figure(1);imshow(dark_channel);title('��ͨ��dark channel');
% % figure(2);subplot(1,2,1);imshow(trans_est);title('ϸ��ǰ͸����ͼtrans est');
% % figure(2);subplot(1,2,2);imshow(dxtrans_est);title('ϸ����͸����ͼdxtrans est');

% figure(3);imshow(image);title('����ͼ��image');
figure(4);imshow(S);title('ȥ����ͼ��S');
% C=imfuse(image,S,'montage');
% figure(5),imshow(C);

folderPath ='results\'; %D:\�ҵ��ĵ�\ѧϰ\��ҵ���\ECP
% fileName ='ECPȥ����ͼ��S.jpg';
%fileName ='Direct15ȥ����ͼ��S.jpg';
outname = ['ECP_6_',img];
fullpath = [folderPath, outname];
%fullpath = fullfile(folderPath, fileName);
imwrite(S, fullpath);

% folderPath ='D:\�ҵ��ĵ�\ѧϰ\��ҵ���\ECP\results';
% fileName ='��ͨ��dark channel.jpg';
% fullpath = fullfile(folderPath, fileName);
% imwrite(dark_channel, fullpath);
% % imwrite(S,'Forest_Jinshan.jpg');
% folderPath ='D:\�ҵ��ĵ�\ѧϰ\��ҵ���\ECP\results';
% fileName ='ϸ��ǰ��Ͷ����trans est.jpg';
% fullpath = fullfile(folderPath, fileName);
% imwrite(trans_est, fullpath);
% 
% folderPath ='D:\�ҵ��ĵ�\ѧϰ\��ҵ���\ECP\results';
% fileName ='ϸ�����Ͷ����dxtrans est.jpg';
% fullpath = fullfile(folderPath, fileName);
% imwrite(dxtrans_est, fullpath);