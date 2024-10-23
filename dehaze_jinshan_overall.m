clc;clear;close all;
tic;
addpath(genpath('image'));
addpath(genpath('cho_code'));
img = '23_hazy.png';%'snow_input.png';%'originalfog.jpg'; %'canon.jpg';%'mountain_input.png';%'canon.jpg';%'originalfog.jpg';%'example04.png';
inputfile = ['image\',img];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Define the directory path where the PNG files are located
folderPath = 'D:\论文\本科毕业设计\haze\Dense_Haze_NTIRE19\hazy';
if ~exist('omega', 'var')
    omega = 0.95;
end

if ~exist('win_size', 'var')
    win_size = 35;
end

 r = win_size*4;%滤波半径   一般设均值滤波半径为求解暗通道时使用的最小值滤波半径的4~8倍
 eps = 1e-3;%正则化项  或1e-5
% Get the number of .png files in the directory
filePattern = fullfile(folderPath, '*.png');
pngFiles = dir(filePattern);
numFiles = length(pngFiles);

% Loop over each file, assuming they are named "1.png", "2.png", "3.png", etc.
for k = 1:numFiles
    % Create the filename
    fileName = sprintf('%d_hazy.png', k);
    fullFileName = fullfile(folderPath, fileName);
    
    % Check if the file exists
    if isfile(fullFileName)
        % Display full file name or replace with your image processing code
%         disp(fullFileName);
%print(fullFileName)
image = double(imread(fullFileName))/255;  %09_hazy.png
% image = imresize(image, 0.4);%图像较大时启用此代码


[m, n, ~] = size(image);


dark_channel = get_dark_channel(image, win_size); %castle_a = [0.575, 0.6125 ,0.7]
atmosphere = get_atmosphere(image,dark_channel); %snow_mountain = [0.675, 0.68, 0.66]

trans_est = get_transmission_estimate(image(), atmosphere,omega,win_size);
dxtrans_est=guidedfilter(rgb2gray(image),trans_est,r,eps);%导向滤波细化透射率
dxtrans_est = max(dxtrans_est, 0.1);

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

% figure(1);imshow(dark_channel);title('暗通道dark channel');
% % figure(2);subplot(1,2,1);imshow(trans_est);title('细化前透射率图trans est');
% % figure(2);subplot(1,2,2);imshow(dxtrans_est);title('细化后透射率图dxtrans est');

% figure(3);imshow(image);title('有雾图像image');
%figure(4);imshow(S);title('去雾后的图像S');
% C=imfuse(image,S,'montage');
% figure(5),imshow(C);

folderPath2 ='BCPresults\'; %D:\我的文档\学习\毕业设计\ECP
% fileName ='ECP去雾后的图像S.jpg';
%fileName ='Direct15去雾后的图像S.jpg';
outname = ['BCP_6_',fileName];
fullpath = [folderPath2, outname];
%fullpath = fullfile(folderPath, fileName);
imwrite(S, fullpath);       
        % If you want to read and process the image, you can use the following line:
        % imageArray = imread(fullFileName);
        
        % (Insert your image processing code here)
    else
        warning('File %s does not exist.', fullFileName);
    end
end

% image = double(imread(inputfile))/255;  %09_hazy.png
% % image = imresize(image, 0.4);%图像较大时启用此代码

% 
% [m, n, ~] = size(image);
% 
% 
% dark_channel = get_dark_channel(image, win_size); %castle_a = [0.575, 0.6125 ,0.7]
% atmosphere = get_atmosphere(image,dark_channel); %snow_mountain = [0.675, 0.68, 0.66]
% 
% trans_est = get_transmission_estimate(image(), atmosphere,omega,win_size);
% dxtrans_est=guidedfilter(rgb2gray(image),trans_est,r,eps);%导向滤波细化透射率
% dxtrans_est = max(dxtrans_est, 0.1);
% % [t]=tsl(image,atmosphere);
% %image(:,:,1)
% lambda = 0.01;
% % wei_grad = 0.0;
% kappa = 2.0;
% %S = image;
% %B2 = image;
% 
% for i = 1:3
%     %J(x)=I(x)t(x)+A(1-t(x))
% %  B = (image(:,:,i) - atmosphere(:,i) .* (1-dxtrans_est))./dxtrans_est;
% %     S(:,:,i)=B;
% %     B = (image(:,:,i) - atmosphere(:,i))./dxtrans_est+atmosphere(:,i)
% %B =  atmosphere(:,i) .* (1-trans_est) - image(:,:,i);
% %B
%     %B = B ./ trans_est;
% %     kernel = eye(3)/255;
% %     kernel(1,1) = 0;
% %     kernel(3,3) = 0;
% %     kernel
% kernel = 1;
% %     %B2(:,:,i) = B;
% % S(:,:,i) = L0Deblur_dark_chanelBD(B, kernel, lambda,dxtrans_est,kappa);
% S(:,:,i) = L0Deblur_dark_chanelBD(image(:,:,i), kernel, lambda,dxtrans_est,atmosphere(i), kappa);
% %S(:,:,i) = L0Deblur_dark_chanelBD(B, kernel, lambda, kappa);
% %S(:,:,i)=B;
% %     S(:,:,i) = S(:,:,i) ./ dxtrans_est;
% end
% toc;
% %imshow(B);
% %imshow(B2);
% 
% % figure(1);imshow(dark_channel);title('暗通道dark channel');
% % % figure(2);subplot(1,2,1);imshow(trans_est);title('细化前透射率图trans est');
% % % figure(2);subplot(1,2,2);imshow(dxtrans_est);title('细化后透射率图dxtrans est');
% 
% % figure(3);imshow(image);title('有雾图像image');
% figure(4);imshow(S);title('去雾后的图像S');
% % C=imfuse(image,S,'montage');
% % figure(5),imshow(C);
% 
% folderPath ='results\'; %D:\我的文档\学习\毕业设计\ECP
% % fileName ='ECP去雾后的图像S.jpg';
% %fileName ='Direct15去雾后的图像S.jpg';
% outname = ['ECP_6_',img];
% fullpath = [folderPath, outname];
% %fullpath = fullfile(folderPath, fileName);
% imwrite(S, fullpath);

% folderPath ='D:\我的文档\学习\毕业设计\ECP\results';
% fileName ='暗通道dark channel.jpg';
% fullpath = fullfile(folderPath, fileName);
% imwrite(dark_channel, fullpath);
% % imwrite(S,'Forest_Jinshan.jpg');
% folderPath ='D:\我的文档\学习\毕业设计\ECP\results';
% fileName ='细化前的投射率trans est.jpg';
% fullpath = fullfile(folderPath, fileName);
% imwrite(trans_est, fullpath);
% 
% folderPath ='D:\我的文档\学习\毕业设计\ECP\results';
% fileName ='细化后的投射率dxtrans est.jpg';
% fullpath = fullfile(folderPath, fileName);
% imwrite(dxtrans_est, fullpath);