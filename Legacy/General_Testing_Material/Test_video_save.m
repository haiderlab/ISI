% Making videos directly from .mat file
% folder of stored
folder_1 = 'C:\neurodata\Processed Data'; % Change this to view Original or Process images
folder_2 = 'C:\neurodata\video';

% Writing in video file
% Original Image 
outVideo_1 = VideoWriter(fullfile(folder_2,'compile_O_video.avi'));
% Low pass F video
outVideo_2 = VideoWriter(fullfile(folder_2,'compile_L_video.avi'));
% High pass F video
outVideo_3 = VideoWriter(fullfile(folder_2,'compile_H_video.avi'));


% Define the frame rate
outVideo_1.FrameRate = 10;
open(outVideo_1);
outVideo_2.FrameRate = 10;
open(outVideo_2);
outVideo_3.FrameRate = 10;
open(outVideo_3);

for ii = 1:length(ims)
    img = imresize(ims{ii}, [512 512]);
    writeVideo(outVideo_1,img);
    
    % Low filter
    filt_1 = fourierLowF(img,0.05);
    filt_1 = filt_1 - min(min(filt_1))-0;
    Anorm_1 = filt_1.*(1/(max(max(filt_1))-min(min(filt_1))));
    writeVideo(outVideo_2,Anorm_1);
    
    % High filter
    filt_2 = fourierHighF(img,0.05);
    filt_2 = filt_2 - min(min(filt_2))-0;
    Anorm_2 = filt_2.*(1/(max(max(filt_2))-min(min(filt_2))));
    writeVideo(outVideo_3,Anorm_2);
end
close(outVideo_1);
close(outVideo_2);
close(outVideo_3);

















