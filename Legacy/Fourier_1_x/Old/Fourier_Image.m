
%% Applying Low pass filter in image
% This is an example code that show how a Low & High frequence filter 
% can be applied on a image after using a Fourier Transformation
% fft2: Applied a Fourier Transformation on a 2D object like an object
% Note that after FT, the lowest frequency are at the edges & Nyquist is at
% the center
% fftshift(fft2(X)): Shift frequencies so that Nyquist frequencies are at 
% the edge and the low frquencies is at the middle

clear all
clc
[fname path] = uigetfile('*.jpg','Select an Image');
fname = strcat(path,fname);
im = imread(fname);

 
image = imresize(im(:,:,1),[512 512]); % Apply this if image is not grey scale
%image = rgb2gray(image);
%imgL = double(mean(image,3)); % Transform 8-bit image to Double & find mean
imgL = image;
% After applying fourier without filter
% Image of 8-bit type
imageFR = fftshift(fft2(image));
% Apply a transformation
%imageFR = log(1+abs(imageFR));

% Low pass filter on image 
width = 0.01; % Width of Gaussian (normalized z units)
             % Decreasing this value change the pass
             % Range [1,0] --> 1: All passes after Fourier Transform
[x,y] = ndgrid(zscore(1:size(imgL,1)),zscore(1:size(imgL,2)));
gaus2D = exp(-(x.^2 + y.^2) ./ (2*width^2)); % Add at beginning to invert 
imgX = fftshift(fft2(imgL));% Same as above but uses double type & not 8-bit
img = real(ifft2(fftshift(imgX.*gaus2D))); % This multiply the FT image & filter
                                           % Then frequencies are shifted &
                                           % FT is reversed to reveal new
                                           % image

% High pass filter on image 
% width = 0.9;
% [x,y] = ndgrid(zscore(1:size(imgL,1)),zscore(1:size(imgL,2)));
% gaus2D = 1 - (exp(-(x.^2 + y.^2) ./ (2*width^2)));
% imgX = fftshift(fft2(imgL));
% img = real(ifft2(fftshift(imgX.*gaus2D)));


%% Looping & Testing 
%Showing image
figure(1);
imshow(image,[])
title('Original Image')
% figure(2);
% imshow(real(imageFR),[])
% title('FT - 8-bit Type')
% figure(3);
% imshow(real(imgX),[])
% title('FT - Double Type')
figure(2);
imshow(img,[])
title('Image - After filter') 


