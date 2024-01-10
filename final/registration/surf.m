clc; clear all; close all;
%% Read the images
fixed = imread('early1.jpg');
moving = imread('advanced1.jpg');

%% Convert RGB images to intensity(grayscale) images
grayImage1 = rgb2gray(fixed);
grayImage2 = rgb2gray(moving);

%% Use SURF to detect feature points and descriptors
points1 = detectSURFFeatures(grayImage1);
points2 = detectSURFFeatures(grayImage2);

[features1, validPoints1] = extractFeatures(grayImage1, points1);
[features2, validPoints2] = extractFeatures(grayImage2, points2);

%% Match feature points
indexPairs = matchFeatures(features1, features2);

%% Get matching point pairs
matchedPoints1 = validPoints1(indexPairs(:, 1));
matchedPoints2 = validPoints2(indexPairs(:, 2));

%% Estimate transformations between images
[tform, inlierIdx] = estimateGeometricTransform2D(matchedPoints2, matchedPoints1, 'similarity');

%% Transform image2 so that it is aligned with image1
outputView = imref2d(size(fixed));
registeredImage2 = imwarp(moving, tform, 'OutputView', outputView);

%% Visualize the aligned image
figure;
imshowpair(fixed, registeredImage2, 'montage');
title('Aligned Images');

%% overlay
figure,imshowpair(fixed, registeredImage2)
