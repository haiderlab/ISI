%MovieObj = VideoReader('Insert the name of the video file here'); %Read in the videofile
MovieObj = movieAvg;
nframes = size(movieAvg,3); %Compute the number of frames in the video
FirstFrame= movieAvg(:,:,1);  %Define the first frame in the video as the FirstFrame
%FirstFrame=rgb2gray(FirstFrame); %Change the frame into grayscale
%% Create an array "Original" from the original movie
for k = 1 : nframes
    %OriginalFrame = read(MovieObj, k); %Read in the k:th frame
    %OriginalFrame=rgb2gray(OriginalFrame); %Change the frame into grayscale
    OriginalFrame = MovieObj(:,:,k);
    Original(:,:,:,k) = OriginalFrame; %Write the results into 
...the array "Original"
end
%% Compute the difference between the first and k:th frame and create an array "EnhancedChange"
...(the k:th frame defined as NextFrame)
    for k = 1 : nframes
    %     NextFrame = read(MovieObj, k); %Read in the k:th frame
    %     NextFrame=rgb2gray(NextFrame); %Change the frame into grayscale
    NextFrame = MovieObj(:,:,k);
    NextFrame=FirstFrame-NextFrame; %Compute the difference between
    ...the first and k:th frame
        EnhancedChange(:,:,:,k) = NextFrame*2; %Write the results into
    ...the array "EnhancedChange"
    end
%% Play the results with implay with the original video on top and changes below
Mov=vertcat(Original,EnhancedChange);
implay(EnhancedChange)
