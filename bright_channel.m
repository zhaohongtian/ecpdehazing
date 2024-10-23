function [J, J_index] = bright_channel(I, patch_size)
%% for grayscale image
%
[M, N, C] = size(I);
J = zeros(M, N); % Create empty matrix for J
J_index = zeros(M, N); % Create empty index matrix

% Test if patch size has odd number
% if ~mod(numel(patch_size),2) % if even number
%     error('Invalid Patch Size: Only odd number sized patch supported.');
% end

% pad original image
%I = padarray(I, [floor(patch_size./2) floor(patch_size./2)], 'symmetric');
I = padarray(I, [floor(patch_size./2) floor(patch_size./2)], 'replicate');

% Compute the dark channel 
for m = 1:M
        for n = 1:N
            patch = I(m:(m+patch_size-1), n:(n+patch_size-1),:);
            tmp = max(patch, [], 3);
            [tmp_val, tmp_idx] = max(tmp(:));
            J(m,n) = tmp_val;
            J_index(m,n) = tmp_idx;
        end
end

end



