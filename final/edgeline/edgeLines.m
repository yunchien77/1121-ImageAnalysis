%% Import and display the image.
clc;close all;clear;

ob = imread('binary.png');
ob = rgb2gray(ob);
figure; imshow(ob);

%% Detect object edges with default Sobel method.
obEdge = edge(ob);
% wormsEdge = edge(worms, 'sobel', threshold_value);
figure; imshow(obEdge);

%% Get the default threshold value.
[obEdge,thresh] = edge(ob);
thresh

%% Increase the threshold value to reduce background noise detection.
obEdge = edge(ob, 0.001);
figure; imshow(obEdge);

%===============================================%
%% Detect object edges using the Canny operator and observe thethreshold.
[obEdge,thresh] = edge(ob,'canny');
figure; imshow(obEdge);
thresh

%% Increase the threshold value to ignore noise detection.
% edge uses this value for the high value and uses threshold*0.4 for the low threshold.
obEdge = edge(ob,'canny', 0.25);
figure; imshow(obEdge);

%===============================================%
%% Preprocess and segment out the objects to create a binary image.
obBW = createBinaryOb(ob);
figure, imshow(obBW);

%% Extract edges from the binary objects' image.
obEdge = edge(obBW,'canny');
figure; imshow(obEdge)

%============================================%
%% Extract the boundaries of all the objects
obBoundary = bwboundaries(obBW);
numBoundaries = length(obBoundary)

%% Display the original image and plot the object boundaries on it
figure, imshow(ob,[])
hold on
% Highlight the bounderies using a thin line.
visboundaries(obBoundary,'LineWidth',1,'EnhanceVisibility',false)
