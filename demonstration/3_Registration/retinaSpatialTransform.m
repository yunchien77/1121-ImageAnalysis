%% Read the images
clc;clear;close all
moving = imread('advancedAMD.jpg');
fixed = imread('earlyAMD.jpg');

hFig = figure;
subplot(2,1,1), 
imshowpair(fixed,moving,'montage')
title('Fixed and Moving Images')

%% Select control points between the two images
% Select 4 control points between the two images and export them to Matlab
% workspace
cpselect(moving,fixed)

%% Fine-Tune the control point pairs (Optional) 
% Convert RGB images to intensity(grayscale) images
fixedGray = rgb2gray(fixed);
movingGray = rgb2gray(moving);

movPtsCorr = cpcorr(movingPoints, fixedPoints, movingGray, fixedGray);

%% Fit geometric transformation to control point pairs
% The option for the transformation type
mytform = fitgeotrans(movPtsCorr,fixedPoints,'similarity');

%% Transform the moving image such that the output image has the same size as  
% Construct a spatial referencing object.
refDim = size(fixed);
Rfixed = imref2d(refDim);
% Apply geometric transformation to the input image. Specify the size and 
% location of output image in world coordinate system.
output = imwarp(moving,mytform,'OutputView',Rfixed);

%% Display the output image and observe its difference from base image
figure(hFig), 
subplot(2,1,2), 
imshowpair(fixed,output,'montage') 
title('Fixed and Output Images')

%% Overlay two images
figure,imshowpair(output,fixed)
