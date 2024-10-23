folderPath = './BCPresults';
refPath = './GT';
filePattern = fullfile(refPath, '*.png');
pngFiles = dir(filePattern);
numFiles = length(pngFiles)
Cpsnr = 0;
Cssim = 0;
% Loop over each file, assuming they are named "1.png", "2.png", "3.png", etc.
for k = 1:numFiles
     fileName = sprintf('BCP_6_%d_hazy.png', k+9);
     %fileName = ['ECP_6_', fileName];
    fullFileName = fullfile(folderPath, fileName);
    %fileNameR = sprintf()
    fileNameR = sprintf('%d_GT.png', k+9);
    fullFileNameR = fullfile(refPath, fileNameR);
    imdehaze = imread(fullFileName);
    imref = imread(fullFileNameR);
    psnr1 = psnr(imdehaze, imref);
    Cpsnr = Cpsnr + psnr1;
    ssim1 = ssim(imdehaze,imref);
    Cssim = Cssim + ssim1;
end

Cpsnr

Cssim