%% Import the moving and fixed images.
fixed = imread('earlyAMD.jpg');
moving = imread('advancedAMD.jpg');
figure, imshowpair(fixed,moving,'montage');

%% Estimate the geometric transformation between the images using phase 
% Correlation assuming similarity transformation.
tformEstimate = imregcorr(moving,fixed,'similarity');

%% Create a spatial referencing object such that the output image of the same size as the fixed image
Rfixed = imref2d(size(fixed));

%% Transform the moving image
output = imwarp(moving,tformEstimate,'OutputView',Rfixed);

%% Observe the difference between the fixed and output images.
figure,imshowpair(output,fixed,'diff')
