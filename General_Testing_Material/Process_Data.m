% Using Fourier to remove slow changes on stored data
% Uses images from original folder
Original_Images = ims;
Trans_Filter_Images = cell(1,length(Original_Images));
fname = sprintf('%s\\%s\\','C:\neurodata','Processed Data');

% folder of stored
folder = 'C:\neurodata\Jpeg_Images';
imagesVec = dir(fullfile(folder, '*.jpg'));
for i = 1:length(imagesVec);
    FullFileName = fullfile(folder, imagesVec(i).name);
    im = imread(FullFileName);
    im = imresize(im, [512 512]);
    imR = im;
    % Low-pass transformation
    imRtL = fourierLowF(imR,0.05);
    % High-pass transformation
    imRtH = fourierHighF(imR,0.2);
    % filtered 
    filt = imRtH;
    % Storing processed images
    % Shifting values to get rid of neg. values (necessary for High Pass)
    filt = filt - min(min(filt))-0;
    % Normalizing pixel values to range [0 1]
    Anorm = filt.*(1/(max(max(filt))-min(min(filt))));
    % Copy the images in folder
    %imwrite(Anorm,sprintf('%sim_test_%d_Fourier_LP.jpg',fname,i));
end


