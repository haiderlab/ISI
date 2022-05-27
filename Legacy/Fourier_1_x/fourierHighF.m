  function [imageHF] = fourierHighF(imgOr,w)
% This function perform a High pass filter to remove noise 
% using a Fourier Transformation
% The input 'x' is an image pixel
%imgL = imresize(imgOr, [512 512]);
imgL = imgOr;
width = w;
[x,y] = ndgrid(zscore(1:size(imgL,1)),zscore(1:size(imgL,2)));
gaus2D = 1 - (exp(-(x.^2 + y.^2) ./ (2*width^2)));
imgX = fftshift(fft2(imgL));
imageHF = real(ifft2(fftshift(imgX.*gaus2D)));

