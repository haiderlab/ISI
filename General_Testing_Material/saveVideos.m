function saveVideos(ims)
% Making videos directly from .mat file
% folder of stored
% global FPS;
global FrameRate
folder_2 = 'Y:\haider\Data\ISI\videos';

% Writing in video file
% Original Image normalized
%outVideo_1 = VideoWriter(fullfile(folder_2,'compile_O_video.avi'));
% Low pass F video
%outVideo_2 = VideoWriter(fullfile(folder_2,'compile_L_video.avi'));
% High pass F video
%outVideo_3 = VideoWriter(fullfile(folder_2,'compile_H_video.avi'));
% Original raw images
outVideo_4 = VideoWriter(fullfile(folder_2,'compile_R_video.avi'));

FPS = 10; % Change this to real sampling frequency

% Define the frame rate
% outVideo_1.FrameRate = FPS;
% open(outVideo_1);
% outVideo_2.FrameRate = FPS;
% open(outVideo_2);
% outVideo_3.FrameRate = FPS;
% open(outVideo_3);
outVideo_4.FrameRate = FPS;
open(outVideo_4);

% imgOri = double (imresize(ims{1}, [512 512]));
% Normalizing frames
% Low
% filt_L = fourierLowF(imgOri,0.05);
% filt_L = filt_L - min(min(filt_L))-0;
% norm_L = filt_L.*(1/(max(max(filt_L))-min(min(filt_L))));

for ii = 1:size(ims,3)
    ii
    
    %img = double (imresize(ims{ii}, [512 512]));
    img = ims(:,:,ii);
    % Original raw
    writeVideo(outVideo_4, mat2gray(img));
    
%     % Original normalized
%     writeVideo(outVideo_1, mat2gray(img - imgOri) );
    

%     % High
%     filt_H = fourierLowF(imgOri,0.05);
%     filt_H = filt_H - min(min(filt_H))-0;
%     norm_H = filt_H.*(1/(max(max(filt_H))-min(min(filt_H))));
    
    
    % Low filter
%     filt_1 = fourierLowF(img,0.05);
%     filt_1 = filt_1 - min(min(filt_1))-0;
%     Anorm_1 = filt_1.*(1/(max(max(filt_1))-min(min(filt_1))));
%     writeVideo(outVideo_2, mat2gray(Anorm_1 - norm_L));
%     
%     % High filter
%     filt_2 = fourierHighF(img,0.05);
%     filt_2 = filt_2 - min(min(filt_2))-0;
%     Anorm_2 = filt_2.*(1/(max(max(filt_2))-min(min(filt_2))));
%     writeVideo(outVideo_3, mat2gray(Anorm_2 - norm_H));
end
% close(outVideo_1);
% close(outVideo_2);
% close(outVideo_3);
close(outVideo_4);

