% Reflectance of 1 pixel from set of images
% Note that these images are resized by the function
% x = 'Jpeg_Images';% folder name in neurodata
% y = 500; % X coordinate of pixel
% z = 500; % Y coordinate of pixel
% t = timevec; % Time vector (stamps) of each image. Found in .mat file
% reflectanceFromImage(x,y,z,t);

% Reflectance from ims in .mat file without resize
x = ims; % ims cell image array in .mat file
y = 1; % X coordinate of pixel
z = 1; % Y coordinate of pixel
t = timevec; % Time vector for all images
r = 0; % 0 = original images, 1 = resized images
reflectanceFromMat(x,y,z,t,r);

% Reflectance from ims in .mat file after resizing to [512 512]
% x = ims; % ims cell image array in .mat file
% y = 1; % X coordinate of pixel
% z = 1; % Y coordinate of pixel
% t = timevec; % Time vector for all images
% r = 1; % 0 = original images, 1 = resized images
% reflectanceFromMat(x,y,z,t,r);