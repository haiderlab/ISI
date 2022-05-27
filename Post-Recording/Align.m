%% This script is align images of cranios & retinotopic maps
% After removal of cranial window & craniotomies
addpath(genpath('supporting_functions'))

% Retinotopic map
load('Azimuth\ISImap.mat','g_im_1','abs_map')
% Recordings/images of craniotomies
load('***\000.mat')
% Saving images
SaveFrames(g_im_1,abs_map,ims{1})

%% Align
clear
f = getframe(openfig('im1.fig')); %im1.fig is the saved original image
m = getframe(openfig('im2.fig')); %im2.fig is the saved image + cranio
[f1, f_map] = frame2im(f); 
[m1, m_map] = frame2im(m);
[m1 m2 both] = imalign(m1,f1);


%% Display saved images
fx = imread('align_fixed.jpg'); 
mv = imread('align_moved.jpg');
figure;
subplot(1,2,1);
imshow(fx)
subplot(1,2,2);
imshow(mv)




