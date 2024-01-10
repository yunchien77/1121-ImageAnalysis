clc;close all;clear;

% Read image
vessel1 = imread('case08.png');

figure
imshow(vessel1);
title('Original')


% RGB convert to gray image
vessel1_gray = rgb2gray(vessel1);

figure
imshow(vessel1_gray)
title('Original to gray')

%% Histogram stretching using IMADJUST

vessel1Imadj = imadjust(vessel1_gray);
figure
imshow(vessel1Imadj);
title('Image after IMADJUST')

%% Linearly map the image values from [20 390] to [0 255]
adjustHistOutput = imadjust(vessel1_gray,[20 190]/255,[]);

figure
imshow(adjustHistOutput);
title('Image after IMADJUST [20 190]');

%% adjust the bright
adjustHistOutput2 = imadjust(vessel1_gray,[20 190]/255,[0.1 0.85]);


%% show image before and after

figure
subplot(2,2,1), imshow(vessel1_gray), title('original to gray')
subplot(2,2,2), imshow(vessel1Imadj), title('image after imadjust')
subplot(2,2,3), imshow(adjustHistOutput), title('image after imadjust [20 190]')
subplot(2,2,4), imshow(adjustHistOutput2), title('image after imadjust contrast[20 190] brightness[0.1 0.85]')

%% HISTEQ performs histogram equalization. It enhances the contrast of 

vessel1HistEq = histeq(vessel1_gray);
figure, imshow(vessel1HistEq)
title('Histogram Equalized Image')

%vessel1HistEq2 = histeq(adjustHistOutput);
%figure, imshow(vessel1HistEq2)
%title('Histogram Equalized Image 2')

%% ADAPTHISTEQ performs contrast-limited adaptive histogram equalization. 

vessel1AdaptHist = adapthisteq(vessel1_gray,'NumTiles',[12,12]);
%figure, imshow(vessel1AdaptHist)
%title('Adaptive Histogram Equalization')
vessel1AdaptHist2 = adapthisteq(adjustHistOutput,'NumTiles',[8,8]);

% figure
% subplot(1, 3, 1), imshow(vessel1_gray), title('original')
% subplot(1, 3, 2), imshow(vessel1AdaptHist), title('adaptive histogram equalization')
% subplot(1, 3, 3), imshow(vessel1AdaptHist2), title('adaptive histogram equalization 2')

adjustHistOutputAdapt = imadjust(vessel1AdaptHist,[20 190]/255,[]);

%%
figure
subplot(1, 4, 1), imshow(vessel1_gray), title('original')
subplot(1, 4, 2), imshow(vessel1AdaptHist), title('adaptive histogram equalization')
subplot(1, 4, 3), imshow(vessel1AdaptHist2), title('adaptive histogram equalization 2')
subplot(1, 4, 4), imshow(adjustHistOutputAdapt), title('adaptive histogram equalization after imadjust')

%% Use Linear Spatial Filter: average out the image to reduce the noise
avg = fspecial('gaussian',4,0.6);

vessel1Denoise = imfilter(vessel1AdaptHist, avg);
vessel1Denoise2 = imfilter(adjustHistOutputAdapt, avg);

figure
imshowpair(vessel1Denoise, vessel1Denoise2, 'montage');
title('Averaging Filter - Zero Padding');

%% Use mirror-reflection at image boundary
vessel1Denoise3 = imfilter(adjustHistOutputAdapt,avg,'symmetric');
figure, imshow(vessel1Denoise3)
title('Averaging Filter - Symmetric Padding')

%% Apply median filter
% Specify neighborhood and use symmetric padding
vessel1Med = medfilt2(adjustHistOutputAdapt,[3,3],'symmetric');
figure, imshow(vessel1Med)
title('Median Filter - Symmetric padding')

%%
figure
subplot(1, 3, 1), imshow(vessel1Denoise2), title('Averaging Filter - Zero Padding');
subplot(1, 3, 2), imshow(vessel1Denoise3), title('Averaging Filter - Symmetric Padding')
subplot(1, 3, 3), imshow(vessel1Med), title('Median Filter - Symmetric padding')


%% Pad image boundary with its mirror image and find minimum of each block
blkSize = [16 16];

[rows,cols] = size(vessel1Denoise3); 

background = blockproc(vessel1Denoise3, blkSize, @blockBackground, 'PadMethod','symmetric');

%%
background = imresize(background, [rows cols], 'bilinear');
figure, imshow(background)
title('Background Estimate');

%% Subtract the background from the image
backgroundAdj = vessel1Denoise3 - background ;
figure,imshow(backgroundAdj);
title('Background Adjusted Image');

%% Enhance the brightness of the image
cluster = imadjust(backgroundAdj);
figure, imshowpair(vessel1Denoise3, cluster, 'montage');
title('Original & the final version of the image');

%% Segment out the cell clusters using global threshold value
clusterBW = imbinarize(cluster, graythresh(cluster));
figure, imshow(clusterBW);
title('Segmented Cell Clusters');


%% Convert to binary image
thresh = graythresh(cluster);

BW3 = imbinarize(cluster, thresh);
figure
imshow(BW3)

%% show histogram
figure
imhist(cluster)

%%
a = im2bw(vessel1Denoise3, 0.6);

figure
imshow(a)

%%
% 設置 Frangi 濾波器的參數
frangi_params.sigmas = 1:2:10;
frangi_params.alpha = 0.7;
frangi_params.beta = 0.9;
frangi_params.gamma = 0.05;
frangi_params.black_ridges = true;
frangi_params.mode = 'reflect';
frangi_params.cval = 0;

vessel1Denoise3_double = im2double(vessel1Denoise3);

% 使用 Frangi 濾波器增強圖像中的細線性結構特徵
filtered = FrangiFilter2D(vessel1Denoise3_double, frangi_params);

filtered = imadjust(filtered, stretchlim(filtered, [0.01, 0.99]), [0, 1]);

figure
imshow(filtered, 'DisplayRange', [min(filtered(:)), max(filtered(:))]);

%% 比較未做處理的圖像使用frangi濾波的情況

vessel1_double2 = im2double(vessel1_gray);

filtered1 = FrangiFilter2D(vessel1_double2, frangi_params);
filtered1 = imadjust(filtered1, stretchlim(filtered1, [0.01, 0.99]), [0, 1]);

figure
imshow(filtered1, 'DisplayRange', [min(filtered1(:)), max(filtered1(:))]);


%%
vessel1_double3 = im2double(cluster);

filtered2 = FrangiFilter2D(vessel1_double3, frangi_params);
filtered2 = imadjust(filtered2, stretchlim(filtered2, [0.01, 0.99]), [0, 1]);

figure
imshow(filtered2, 'DisplayRange', [min(filtered2(:)), max(filtered2(:))]);

%%
vessel1_double4 = im2double(clusterBW);

filtered3 = FrangiFilter2D(vessel1_double4, frangi_params);
filtered3 = imadjust(filtered3, stretchlim(filtered3, [0.01, 0.99]), [0, 1]);

figure
imshow(filtered3, 'DisplayRange', [min(filtered3(:)), max(filtered3(:))]);

%%
figure
subplot(4, 3, 1), imshow(vessel1_gray), title('original')
subplot(4, 3, 2), imshow(vessel1Imadj), title('Image after IMADJUST')
subplot(4, 3, 3), imshow(adjustHistOutput), title('Image after IMADJUST [20 190]')
subplot(4, 3, 4), imshow(vessel1HistEq), title('Histogram Equalized Image')
subplot(4, 3, 5), imshow(vessel1AdaptHist2), title('adaptive histogram equalization')
subplot(4, 3, 6), imshow(adjustHistOutputAdapt), title('adaptive histogram equalization after imadjust')
subplot(4, 3, 7), imshow(cluster), title('Subtract background and enhance brightness')
subplot(4, 3, 8), imshow(clusterBW), title('Segmented Cell Clusters')
subplot(4, 3, 9), imshow(filtered), title('Frangi after mirror-reflection')
subplot(4, 3, 10), imshow(filtered1, 'DisplayRange', [min(filtered1(:)), max(filtered1(:))]), title('Frangi with origin')
subplot(4, 3, 11), imshow(filtered2), title('Frangi with cluster')
subplot(4, 3, 12), imshow(filtered3), title('Frangi with Segmented Cell Clusters')

%figure
%imshow(BW3), title('binary image')
%使用filter效果不明顯(較無雜訊需過濾)
%imshow(vessel1Denoise2), title('Averaging Filter - Zero Padding')

%%
figure
subplot(1, 3, 1), imshow(filtered), title('Frangi after mirror-reflection')
subplot(1, 3, 2), imshow(filtered2), title('Frangi with cluster')
subplot(1, 3, 3), imshow(filtered3), title('Frangi with Segmented Cell Clusters')
