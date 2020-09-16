function reflectanceFromImage(x,y,z,t)
% This function plots the reflectance of 1 pixel from all images in folder
% This function resize image to [512 512]
% x is folder name in neurodata, ex. s = 'Image'
% y & z are pixel coordinates ex. pi(1,2) = pi(y,z)
% t is time vector stored after saving data. You need to download the .mat 
% That's where timevec is found

folder = sprintf('C:\\neurodata\\%s',x);
imagesVec = dir(fullfile(folder, '*.jpg'));
dataValue = zeros(length(imagesVec),1);

% Loop to get pixel reflectance
for i = 1:length(imagesVec)
    FullFileName = fullfile(folder, imagesVec(i).name);
    im = imread(FullFileName);
    im = imresize(im, [512 512]);
    imR = im;
    %dataValue(i) = mean2(imR(500,500)); % Reflectance
    dataValue(i) = mean2(imR(y,z));
end
plot(t,dataValue); 
title('Reflectance of 1 pixel');
xlabel('Time (sec)');
ylabel('R - value');