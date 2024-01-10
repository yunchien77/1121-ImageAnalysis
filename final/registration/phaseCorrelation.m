% Image registration: 平移、旋轉、放大縮小、歪斜
% 轉換矩陣

clc; clear; close all;
%% Read the images
fixed = imread('early1.jpg');
moving = imread('advanced1.jpg');

figure, imshowpair(fixed,moving,'montage');

%% Estimate the geometric transformation between the images using phase 
% Correlation assuming similarity transformation.
% 相位相關(phase correlation)
tformEstimate = imregcorr(moving,fixed,'similarity');

%% Create a spatial referencing object such that the output image of the same size as the fixed image
% 定義輸出圖像的大小和位置，確保輸出圖像的尺寸與 fixed 圖像相同
Rfixed = imref2d(size(fixed));

%% Transform the moving image
output = imwarp(moving,tformEstimate,'OutputView',Rfixed);

%% Observe the difference between the fixed and output images.
figure,imshowpair(output,fixed,'diff')