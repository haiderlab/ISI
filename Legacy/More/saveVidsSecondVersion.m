function saveVidsSecondVersion(ims)

global FrameRate
folder_2 = 'C:\neurodata\video';

% Writing in video file
% Original Image normalized
outVideo_1 = VideoWriter(fullfile(folder_2,'BF_Raw_video.avi'));

FPS = 10; % Change this to real sampling frequency

% Define the frame rate
outVideo_1.FrameRate = FPS;
open(outVideo_1);


for ii = 1:length(ims)
      imgOri = double (imresize(ims{ii}, [512 512]));
%     img = double (imresize(ims{ii}, [512 512]));
    
    % Original raw
    %writeVideo(outVideo_1, mat2gray(img));
    
    % Normalizing frames 
    % Low
%     filt_L = fourierLowF(ims{1},0.05);
%     filt_L = filt_L - min(min(filt_L))-0;
%     norm_L = filt_L.*(1/(max(max(filt_L))-min(min(filt_L))));
%     % 
%     filt_1 = fourierLowF(ims{ii},0.05);
%     filt_1 = filt_1 - min(min(filt_1))-0;
%     Anorm_1 = filt_1.*(1/(max(max(filt_1))-min(min(filt_1))));
%     
     writeVideo(outVideo_1, mat2gray(imgOri));
  
end
close(outVideo_1);
