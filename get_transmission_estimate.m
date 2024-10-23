%透射率估计暗通道
function trans_est = get_transmission_estimate(image, atmosphere,omega,win_size)

% [m, n, ~] = size(image);
[m, n, c] = size(image);

%rep_atmosphere = repmat(reshape(atmosphere, [1, 1, 3]), m, n);
rep_atmosphere = repmat(reshape(atmosphere, [1, 1, c]), m, n);

trans_est = 1 -  omega*get_dark_channel( image ./ rep_atmosphere, win_size);

end
