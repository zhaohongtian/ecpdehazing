%获得大气�?
function atmosphere = get_atmosphere(image, dark_channel)
%[m, n, ~] = size(image);
[m, n, c] = size(image);
n_pixels = m * n;

n_search_pixels = floor(n_pixels * 0.001);

dark_vec = reshape(dark_channel, n_pixels, 1);

% image_vec = reshape(image, n_pixels, 3);
image_vec = reshape(image, n_pixels, c);
[~, indices] = sort(dark_vec, 'descend');

%accumulator = zeros(1, 3);
accumulator = zeros(1, c);
for k = 1 : n_search_pixels
    accumulator = accumulator + image_vec(indices(k),:);
end

atmosphere = accumulator / n_search_pixels;

end