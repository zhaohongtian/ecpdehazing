clear

%path_hazy = '../NYU_Hazy_Small/';%'C:\Users\Administrator\Desktop\Code_available_SLP\hazy images' % the path to hazy examples
path_hazy = 'D:\论文\本科毕业设计\ExperimentMethods\上传代码\ECP\VisualSamplesTest\';
% cd(path_hazy) % enter into the file
% [filename,pathname] = uigetfile('*.png');
% 
% I = imread([pathname,filename]);
% 获取文件夹中所有jpg文件的信息
files = dir(fullfile(path_hazy, '*.jpg'))
%     
%     % 检查是否找到了jpg文件
%     if isempty(files)
%         disp('没有找到jpg文件。');
%         return;
%     end
%     
%     % 遍历所有找到的jpg文件
%     for k = 1:length(files)
%         % 输出文件名
%         fprintf('文件名: %s\n', files(k).name);
%     end
filen = ' ';
for i = 1:length(files)
    if i < 10
      filen = files(i).name;%['0',num2str(i),'_hazy.png'];  
    else
      filen = files(i).name;%[num2str(i),'_hazy.png']; 
    end
%     im = imread();
    filename = [path_hazy, filen];
%I = imread(filename);
%imshow(I,'Border','tight')

image = double(imread(filename))/255;  %09_hazy.png
% image = imresize(image, 0.4);%图像较大时启用此代码
%image = imresize(image,[256,256]);
if ~exist('omega', 'var')
    omega = 0.95;
end

if ~exist('win_size', 'var')
    win_size = 15;
end

 r = win_size*4;%滤波半径   一般设均值滤波半径为求解暗通道时使用的最小值滤波半径的4~8倍
 eps = 1e-3;%正则化项  或1e-5

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
dxtrans_est=guidedfilter(rgb2gray(image),trans_est,r,eps);%导向滤波细化透射率
dxtrans_est = max(dxtrans_est, 0.1);
% [t]=tsl(image,atmosphere);
%image(:,:,1)
%lambda = 0.01;
%lambda = 0.004;
lambda = 0.004;
% wei_grad = 0.0;
kappa = 2.0;
%S = image;
%B2 = image;
S = zeros(size(image));
t_final = zeros(size(image));
%t_final = zeros(size(image));
for i = 1:3
    %J(x)=I(x)t(x)+A(1-t(x))
% B = (image(:,:,i) - atmosphere(:,i) .* (1-dxtrans_est))./dxtrans_est;
%      S(:,:,i)=B;
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
[S(:,:,i), t_final(:,:,i)] = L0Deblur_dark_chanelBD(image(:,:,i), kernel, lambda,dxtrans_est,atmosphere(i), kappa);
%S(:,:,i) = L0Deblur_dark_chanelBD(B, kernel, lambda, kappa);
%S(:,:,i)=B;
%     S(:,:,i) = S(:,:,i) ./ dxtrans_est;
end
%t_final = dxtrans_est;
% t_final = rgb2gray(t_final);

%toc;
%D:\论文\本科毕业设计\haze\DHAZY\D-HAZY A DATASET TO EVALUATE QUANTITATIVELY DEHAZING ALGORITHMS\D-HAZY_DATASET\NYU_Hazy_Small
%imshow(dehaze,'Border','tight')
% result_hazy = '../ECP-HE-Dehazed/';
result_hazy = 'D:\论文\本科毕业设计\ExperimentMethods\上传代码\ECP\VisualSamplesTestDehazed\';
filename = [result_hazy, 'ECP_', filen];
filename2 = [result_hazy, 'ECP_t_', filen];
%imshow(dehaze.^0.8,'Border','tight') % for Fig. 10 in the paper
% imwrite(dehaze,'BCP_revise_dehaze2.png');
imwrite(S,filename);

end