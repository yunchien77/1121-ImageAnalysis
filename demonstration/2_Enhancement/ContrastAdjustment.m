%% Contrast Adjustment
clc;close all;clear;

% Read image
cells = imread('cellGray.tif');

figure, imshow(cells);
title('Original')

%% Histogram stretching using IMADJUST
% The most common technique to modify the contrast of an image is using
% histogram stretching. IMADJUST increases the contrast of the image by
% mapping the values of the input intensity image to new values such that,
% by default, 1% of the data is saturated at low and high intensities of
% the input data.
% Image from Broad Bioimage Benchmark Collection
% http://www.broadinstitute.org/bbbc

cellImadj = imadjust(cells);
figure, imshow(cellImadj);
title('Image after IMADJUST')

%% 
% Linearly map the image values from [20 70] to [0 255]. All values <=20
% will map to 0 and values>=70 will be mapped to 255.The values between
% >20 and <70 will be stretched in between from 0 to 255.
adjustHistOutput=imadjust(cells,[20 70]/255,[]);

figure, imshow(adjustHistOutput);
title('Image after IMADJUST [20 70]');
%================================================%

%% HISTEQ performs histogram equalization. It enhances the contrast of 
% images by transforming the values in an intensity image so that the 
% histogram of the output image approximately matches a specified
% histogram (uniform distribution by default).
cellHistEq = histeq(cells);
figure, imshow(cellHistEq)
title('Histogram Equalized Image')

%% Examine histogram of the original and equalized image

% Observe original image histogram
figure 
subplot(1,2,1), imhist(cells); 
axis tight; 
title('Original histogram');

% Compare histograms of the original image  and contrast adjusted image
subplot(1,2,2),  imhist(cellHistEq); axis tight;
title('Equalized histogram');

%===============================================%

%% ADAPTHISTEQ performs contrast-limited adaptive histogram equalization. 
% Unlike histeq, it operates on small data regions (tiles) rather than the 
% entire image. Each tile's contrast is enhanced so that the histogram of 
% each output region approximately matches the specified histogram 
% (uniform distribution by default). The contrast enhancement can be 
% limited in order to avoid amplifying the noise which might be present in 
% the image.
cellAdaptHist = adapthisteq(cells,'NumTiles',[12,12]);
figure, imshow(cellAdaptHist)
title('Adaptive Histogram Equalization')

%% Observe the histograms of the contrast adjusted images
figure, 
subplot(1,2,1), imhist(cells); 
axis tight;
title('Original Histogram')

subplot(1,2,2),  imhist(cellAdaptHist); 
axis tight;
title('ADAPTHISTEQ Output Histogram')
