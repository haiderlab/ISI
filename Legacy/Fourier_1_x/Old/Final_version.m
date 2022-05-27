% This is the final version of the program to remove noise using Fourier
% Uploading images/files
[fname path] = uigetfile('*.jpg','Select an Image');
fname = strcat(path,fname);
im = imread(fname);

% Resizing the image as described in paper
im = imresize(im, [512 512]);

% Creating a copy of the image
imR = im(:,:,1); % Note that 1 at the end is not mandatory
                 % B/c the images from camera are already in grey scale

% Using Low-pass & High-pass filter
% Low-pass transformation
imRtL = fourierLowF(imR,0.05);
% High-pass transformation
imRtH = fourierHighF(imR,0.5);

% Plotting Luminace across a single row
j = 1:1:512;
i = 150;
subplot(3,1,1)
plot(j,imR(i,j))
title("Time course of Light reflectance (No Filter or Tranformation)")
subplot(3,1,2)
plot(j,imRtL(i,j))
title("Power spectrum of reflectance signal (with Low Pass Filter)")
subplot(3,1,3)
plot(j,imRtH(i,j))
title("Power spectrum of reflectance signal (with High Pass Filter)")






