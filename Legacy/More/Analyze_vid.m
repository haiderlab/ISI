% Frames analysis
vid = VideoReader('Y:\haider\Data\ISI\05_31_2019\7\compile_L_video.avi');
numFrames = vid.NumberOfFrames;
n = numFrames;
Folder = 'C:\neurodata\Jpeg_Images';
ims = {};
for ii = 1:n
    frames = read(vid, ii);
    %imwrite(frames, fullfile(Folder, sprintf('%06d.png', ii));
    ims{ii} = frames ;
end

fname1 = sprintf('%s\\%s\\','C:\neurodata','data');
start = 435;
for jj = 1:20
    baseline = mean(resizeImage(:,:,start:(start+10)),3)';
    imwrite(mat2gray(baseline),sprintf('%sim_test_%05.f.jpg',fname1,jj));
    start = start + 10;
end


baseline = mean(resizeImage(:,:,1:100),3)';
signal = mean(resizeImage(:,:,101:950),3)';
sub = signal-baseline;
sub_ratio = sub./baseline ;
ratio = signal./baseline; 
colormap winter
imagesc(ratio);
colorbar
title('stim/baseline')

    

% FileList = dir(fullfile(Folder,'*.png'));
% for iFile = 1:length(FileList)
%     aFile = fullfile(Folder, FileList(iFile).name);
%     img = imread(aFile);
% end
% 
% clear all
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Store all files in a struct
% Folder = 'C:\neurodata\Jpeg_Images';
% imagefiles = dir(fullfile(Folder,'*.png'));      
% nfiles = length(imagefiles);    % Number of files found
% for ii=1:nfiles
%    currentfilename = imagefiles(ii).name;
%    currentimage = imread(currentfilename);
%    ims{ii} = currentimage;
% end
% %feedback(ims)
% % Looking at the difference b/w frames 
% % You a var ims with all frames
% 
% % t = length(ims);
% % for ii =1:t
% %     ii
% %     for kk = 1:t
% %         figure(1); clf
% %         imshow(ims{ii} - ims{kk})
% %     end
% % end
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 



%% Try
x = [];
timeSt = [];
pause on
for i = 1:60
    tic
    c2 = clock;
    timeSt = [timeSt (c2(4)*3600 + c2(5)*60 + c2(6)) *1000];
    x = [x toc];
    pause(0.1 - toc)
end














