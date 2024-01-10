%% Block Processing using BLOCKPROC
% Get the contrast adjusted denoised image
clc;close all;clear;

cells = imread('cellGray.tif');
cellAdaptHist = adapthisteq(cells);
cellDenoise = wiener2(cellAdaptHist,[5 5]);

%% Pad image boundary with its mirror image and find minimum of each block
% Specify a block size. Since the image is 512-by-512 we use a block size
% such that the image size is an interger multiple of the block size.
blkSize = [32 32];
% Get image size
[rows,cols] = size(cellDenoise); 

background = blockproc(cellDenoise,blkSize,@blockBackground,'PadMethod','symmetric');

%%
% This results in a smaller image. Every 32-by-32 block of image is
% replaced by one pixel. Let's resize the background to the original
% image's size using bilinear interpolation.
background = imresize(background, [rows cols], 'bilinear');
figure, imshow(background)
title('Background Estimate');

%% Subtract the background from the image
backgroundAdj = cellDenoise - background ;
figure,imshow(backgroundAdj);
title('Background Adjusted Image');
% This operation darkens the image overall

%% Enhance the brightness of the image
cluster = imadjust(backgroundAdj);
figure, imshowpair(cellDenoise, cluster,'montage');
title('Original & the final version of the image');

%% Segment out the cell clusters using global threshold value
clusterBW = imbinarize(cluster,graythresh(cluster));
figure,imshow(clusterBW);
title('Segmented Cell Clusters');
