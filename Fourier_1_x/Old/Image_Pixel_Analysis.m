%% Image Processing 
% Pixel analysis
% finidng the light reflectance value 
% Examle Link: https://www.mathworks.com/matlabcentral/answers
% /258353-i-need-to-plot-the-reflectance-spectrum-of-coloured-surface-
% with-4-types-of-leds



% Selecting an image to be processed 
[fname path] = uigetfile('*.jpg','Select an Image');
fname = strcat(path,fname);
im = imread(fname);

% Image needs to be resize 
im = imresize(im, [512 512]); % Paper uses 512X512 image size for mice
%im2 = rgb2gray(im);
% Selecting each pixel of a selected image
% 1 = red, 2 = green, 3 = blue
% 1 & grayScale gives you light intensity 
% But it appears that 1 (Red) gives better image
imR = im(:,:,1); 
% imG = im(:,:,2); % This is not necessary in our setup bc our image are
                   % already in greyscale 
% imB = im(:,:,3); % This is why we use the filter when image is acquired


% for i = 1:512;
%     for j = 1:512;
%         imR(i,j,1); % This gives you access to every pixel
%                     % 1 = red
%                     % So that you can change them and Transform
%         % Reflectance of pixel = mean of rbg value
          % Reflectance pixel channel (r,g,b) value
%         %reflectance = mean2(imR(i,j,1));
%     end
% end

% Example of Luminance values accross rows (i)
j = 1:1:512;
i = 100:100:500;
figure 
plot(j,imR(i,j))

%% For removing the noise you can also you these below instead of Frourier
% Showing noise on Image Using imnoise function
% See documentation for more
% Assuming image colored
% for (i=1:3);
%     imWnoise(:,:,i) = imnoise(im(:,:,i),'Title',0.2);
% end

% Removing noise using a low pass filter = median filter
% See video in drive















