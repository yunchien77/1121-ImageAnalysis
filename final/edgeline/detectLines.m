%% Load the image
clc; close all; clear;
imtool close all;

ob = imread('binary.png');
ob = rgb2gray(ob);
figure; imshow(ob);

%% Skeletonize the worms such that the dead worms become lines
obSkel = bwmorph(ob,'skel',Inf);
figure, imshow(obSkel)
title('Ob Skeleton')

%% Fit lines to the worms to extact their length using hough Transform
% Get the Hough Transform Matrix for the skeletonized worms
[H, T, R] = hough(obSkel);

% Visualize the Hough Matrix
houghMatViz(H,T,R)

%% Locate peaks in the Hough transform matrix. 
% Select a greater nHoodSize value to avoids detecting lines that are very close by (similar rho and theta)
peaks = houghpeaks(H, 30,'NHoodSize', [85 21]);

%% Extract lines location corresponding to the peaks in Hough Transform matrix
lines = houghlines(obSkel, T, R, peaks);

%% Visualize worms
figure
imshow(ob)
hold on

numLines = length(lines);

for k = 1:numLines
   xy = [lines(k).point1; lines(k).point2];
   
   % Plot the detected lines and highlight the beginnings and ends of lines
   % with green markers
    plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','red',...
         'Marker', 'x', 'MarkerEdgeColor', 'g');

end

title('Detected lines plotted over image');
