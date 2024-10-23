function q = guidedfilter(I, p, r, eps)
%% 导向滤波
% 输入参数I为引导图像，在图像去雾中使用原图像的灰度图作为引导图像
% 输入参数p为原始图像，在图像去雾中使用透射率图作为原始图像
% 输入参数r为滤波半径
% 输入参数eps为正则化参数
[hei, wid] = size(I);
N = boxfilter(ones(hei, wid), r); 

mean_I = boxfilter(I, r) ./ N;
mean_p = boxfilter(p, r) ./ N;
mean_II = boxfilter(I.*I, r) ./ N;
mean_Ip = boxfilter(I.*p, r) ./ N;
% this is the covariance of (I, p) in each local patch.
var_I = mean_II - mean_I .* mean_I;
cov_Ip = mean_Ip - mean_I .* mean_p; 

a = cov_Ip ./ (var_I + eps); 
b = mean_p - a .* mean_I; 

mean_a = boxfilter(a, r) ./ N;
mean_b = boxfilter(b, r) ./ N;

q = mean_a .* I + mean_b; 
end