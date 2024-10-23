function [J, J_index] = dark_channel(I, patch_size)

[M, N, C] = size(I);
J = zeros(M, N); 
J_index = zeros(M, N); 

% if ~mod(numel(patch_size),2) 
%     error('Invalid Patch Size: Only odd number sized patch supported.');
% end
I = padarray(I, [floor(patch_size./2) floor(patch_size./2)], 'replicate');%重复边界,为了不考虑块的临界
% Compute the dark channel 
 for m = 1:M
        for n = 1:N
            patch = I(m:(m+patch_size-1), n:(n+patch_size-1),:);
            tmp = min(patch, [], 3);%第三维度的最小值
            [tmp_val, tmp_idx] = min(tmp(:));
            J(m,n) = tmp_val;
            J_index(m,n) = tmp_idx;
        end
 end



end



