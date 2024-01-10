%% Use Linear Filtering for denoising the image
%% Get the contrast adjusted cell image
clc;close all;clear;

cells = imread('cellGray.tif');
cellAdaptHist = adapthisteq(cells);

%% Use Linear Spatial Filter: average out the image to reduce the noise
% Create an averaging filter
avg = fspecial('gaussian',4,0.6);

% Apply averaging filter to the image. Input array values outside the bounds 
% of the array are computed by mirror-reflecting the array across the array border
cellDenoise = imfilter(cellAdaptHist,avg);
imshow(cellDenoise);
title('Averaging Filter - Zero Padding');
% Observe the dark image boundary

%% Use mirror-reflection at image boundary
cellDenoise = imfilter(cellAdaptHist,avg,'symmetric');
figure, imshow(cellDenoise)
title('Averaging Filter - Symmetric Padding')

%===========================================%
%% Apply median filter
% Specify neighborhood and use symmetric padding
cellMed = medfilt2(cellAdaptHist,[3,3],'symmetric');
figure, imshow(cellMed)
title('Median Filter - Symmetric padding')

%===========================================%
%% Use the Wiener filter to reduce the noise that is present in this image
cellDenoise = wiener2(cellAdaptHist,[5 5]);
figure, imshow(cellDenoise);
title('Wiener Filter');
% This gives better result than averaging 

%% Threshold the image to extract the clusters 
% imtool(cellDenoise) % select appropriate threshold value
figure, imshow(cellDenoise > 80)
title('Thresholded output')
% You are able to extract the dull clusters. But notice that the bright
% clusters to the right are merged together.