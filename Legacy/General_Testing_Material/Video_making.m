%% Combining frames into video using stored images
% folder of stored
folder_1 = 'C:\neurodata\Processed Data'; % Change this to view Original or Process images
folder_2 = 'C:\neurodata\video';
imagesVec = dir(fullfile(folder_1, '*.jpg'));
% Covert image vector into cell array
imagesVec = {imagesVec.name};

% Construct a VideoWriter object
outVideo = VideoWriter(fullfile(folder_2,'compile_video.avi'));
% Define the frame rate
outVideo.FrameRate = 10;
open(outVideo);
% Loop through image sequence, load each image, 
% and then write it to the video
for ii = 1:length(imagesVec)
   % Image has been resized
   img = imresize(imread(fullfile(folder_1,imagesVec{ii})), [512 512]);
   writeVideo(outVideo,img);
end
close(outVideo);
% Construct a videoReader
vid = VideoReader(fullfile(folder_2,'compile_video.avi'));
% Create a MATLAB movie struct from the video frames
ii = 1;
while hasFrame(vid)
   mov(ii) = im2frame(readFrame(vid));
   ii = ii+1;
end
% Resize figue & axes to video size
figure 
imshow(mov(1).cdata, 'Border', 'tight');
movie(mov,1,outVideo.FrameRate);
close(outVideo);














