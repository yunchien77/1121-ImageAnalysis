%% Import grayscale image
clc;close all;clear;

gray = imread('cameraman.tif');

figure
imshow(gray);

%% Import true color imge
RGB = imread('yellowlily.jpg');

figure
imshow(RGB);

%% Color space transformation
ColorPlane=reshape(ones(64,1)*reshape(jet(64),1,192),[64,64,3]);

HSV=rgb2hsv(ColorPlane);

% H(色彩)、S(飽和度)、V(亮度)
H=HSV(:,:,1);
S=HSV(:,:,2);
V=HSV(:,:,3);

figure
subplot(2,2,1), imshow(ColorPlane), title('RGB')
subplot(2,2,2), imshow(H), title('Hue')
subplot(2,2,3), imshow(S), title('Saturation')
subplot(2,2,4), imshow(V), title('Value')

%% Transform color image to grayscale image
Igray = rgb2gray(RGB);
figure
imshow(Igray)

%% Plot histogram of gray-scale image
H = imhist(Igray);

figure
bar(H)
xlim([0 255])
xlabel('pixel value')
ylabel('Number')

%% Convert to binary image (1)

BW1 = Igray>50;
BW2 = Igray>200;

figure
subplot(1,2,1), imshow(BW1);
title('I > 50')
subplot(1,2,2), imshow(BW2);
title('I > 200')

%% Convert to binary image (2)
% Get the global threshold for the image. otsu method
thresh = graythresh(Igray);
% Use that threshold to create a binary image.
BW3 = imbinarize(Igray, thresh);
figure
imshow(BW3)

%% Indexed image
close all; 

[Iindexed, map]= rgb2ind(RGB,32);
figure
imshow(Iindexed, map)

%% Export image
imwrite(Iindexed, map,'IndexedImage.png');
