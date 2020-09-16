%% Test for function
% clear all
% clc
% Selecting an image to be processed 
[fname path] = uigetfile('*.jpg','Select an Image');
fname = strcat(path,fname);
im = imread(fname);
im = imresize(im, [512 512]); 
imR = im;
% imR = im(:,:,1); 
% imG = im(:,:,2);
% imB = im(:,:,3);
% Low-pass transformation
imRtL = fourierLowF(imR,0.05);
% High-pass transformation
imRtH = fourierHighF(imR,0.2);

% Display result
%figure(1);imshow(imR,[]); title('Original Image')
%figure(2);imshow(imRtL,[]);title('Low-pass F. Image')
figure(3);imshow(imRtH,[]);title('High-pass F. Image')
