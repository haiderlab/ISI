function [ims, timevec] = grabFrames(numberOfFrames, frameRateFps, frameOutputDirectory)
% grabFrames grabs frames from camera as raw images
% [ims, timevec] = grabFrames(numberOfFrames, frameRateFps) returns cell 
% array of rawimages and time vector of file creation times in milliseconds
%
% numberOfFrames - the number of frames to grab from the camera. Frames
% will be saved to the disk and then imported back into MATLAB.
%
% frameRateFps - the frame rate for the camera to grab the frames. If frame
% rate changed from currently set value, the C++ code will open the
% camera's feature browser, requiring the user to manually press enter on
% the frame rate for it to be set (this is necessary due to a camera bug).
% This can be an int or double value.
%
% frameOutputDirectory - where the frame grabber saves the raw images to
% the disk. This should be an absolute/full directory path with a trailing 
% forward slash to avoid any issues.
% (e.g. 'C:/Users/haider-lab/Downloads/frames/')
%
% NOTE: if the frame rate is set too high (above 30 fps), the camera will
% miss frames and not operate correctly. Also, make sure to clear the
% images when they are unneeded (they take up a lot of space).
%
% BUG: right now, if the numberOfFrames is set too high (400+ for 20 fps),
% the frame rate will halve for an unknown reason.

%% Set behavior values for debugging
% If true, waits for all frames to be grabbed before importing into MATLAB
% NOTE: must be true right now - simulatenous grabbing and importing is not
% yet working correctly
importAfterAllFramesGrabbed = true; 

% If true, enables program to use already existing files. If false, waits
% for files to be newly written.
useOldFiles = false; 

%% Run as exe - process
exePath = "Y:\haider\Code\ISI\General_processing\ISIcode_SheaWells\MdigProcess\vs2012\x64\Debug\MDigProcess.exe";
%exePath = 'MDigProcess.exe';
%numberOfFrames = 2030;
%frameRateFps = 10.0;
%outFileDirectory = 'C:/Users/haider-lab/Downloads/frames/';

if ~exist(frameOutputDirectory, 'dir')
    display('frameOutputDirectory does not exist - attempting to create directory')
    mkdir(frameOutputDirectory)
end

startTime = datetime(clock);
if useOldFiles
    display('skipping frame capture - using old files')
else
    display('beginning frame capture')
    command = sprintf('start %s %d %f %s', exePath, numberOfFrames, frameRateFps, frameOutputDirectory)
    system(command)
end

%% Wait for process to finish
if importAfterAllFramesGrabbed
    display('waiting for process to finish - checking for last file')
    %lastFileName = sprintf('%s%d.raw', frameOutputDirectory, numberOfFrames);
    lastFileName = sprintf('%sREPORT.txt', frameOutputDirectory);
    
    % Check if last file already exists and check if old
    if ~useOldFiles && isfile(lastFileName)
        d = System.IO.File.GetLastWriteTime(lastFileName);
        creationDateTime = datetime(d.Year, d.Month, d.Day, d.Hour, d.Minute, d.Second);
        if creationDateTime < startTime
            msg = sprintf('WARNING: OLD REPORT FILE FOUND - %s', lastFileName);
            display(msg)
        end
        
        % Wait until new file is overwritten
        while creationDateTime < startTime
            pause(0.1)
            d = System.IO.File.GetLastWriteTime(lastFileName);
            creationDateTime = datetime(d.Year, d.Month, d.Day, d.Hour, d.Minute, d.Second);
        end
    end
    
    while ~isfile(lastFileName)
        pause(0.05)
    end
    %pause(0.1)
end

%% Import images
display('beginning frame import')
% Import raw images into MATLAB while process is running
%outFileDirectory = 'C:/Users/haider-lab/Downloads/frames/';
cols = 4090;
rows = 3072;
size = cols * rows;
precision = 'uint8=>uint8';
%numberOfFrames = 400;
%imgs = cell(1,numberOfFrames); %does not seem to make a difference
ims = [];
timevec = [];
for i = 1:numberOfFrames
    imageFileName = sprintf('%s%d.raw', frameOutputDirectory, i);
    
    % Wait for next image file to be creating, signifying current image
    % file is done being written (may not work because of multithreading)
    % NOTE: does not work correctly right now - maybe use message passing
    if ~importAfterAllFramesGrabbed
        nextImageFileName = sprintf('%s%d.raw', frameOutputDirectory, i+1);
        if i == numberOfFrames % check if last image
            nextImageFileName = sprintf('%sREPORT.txt', frameOutputDirectory);
        end
        
        while ~(isfile(imageFileName) && isfile(nextImageFileName))
            pause(0.01)
            
        end
        
        % Wait for images to be newly written
        if ~useOldFiles
            d1 = System.IO.File.GetLastWriteTime(imageFileName);
            d1DateTime = datetime(d1.Year, d1.Month, d1.Day, d1.Hour, d1.Minute, d1.Second);
            d2 = System.IO.File.GetLastWriteTime(nextImageFileName);
            d2DateTime = datetime(d2.Year, d2.Month, d2.Day, d2.Hour, d2.Minute, d2.Second);
            
            % Wait until new file is overwritten
            while d1DateTime < startTime && d2DateTime < startTime
                d1 = System.IO.File.GetLastWriteTime(imageFileName);
                d1DateTime = datetime(d1.Year, d1.Month, d1.Day, d1.Hour, d1.Minute, d1.Second);
                d2 = System.IO.File.GetLastWriteTime(nextImageFileName);
                d2DateTime = datetime(d2.Year, d2.Month, d2.Day, d2.Hour, d2.Minute, d2.Second);
            end
        end
    end
    
    % Attempt to open file
    fin = fopen(imageFileName, 'r');
    while fin == -1 % indicates file could not be opened
        fin = fopen(imageFileName, 'r');
        pause(0.1)
    end
    
    % Get file modification time
    d = System.IO.File.GetLastWriteTime(imageFileName); % was GetCreationTime
    dMilliseconds = (d.Hour*3600 + d.Minute*60 + d.Second) * 1000;
    timevec = [timevec dMilliseconds];
    creationDateTime = datetime(d.Year, d.Month, d.Day, d.Hour, d.Minute, d.Second);
    if ~useOldFiles && creationDateTime < startTime
        msg = sprintf('WARNING: OLD FILE IMPORTED - %s%d.raw', frameOutputDirectory, i);
        display(msg)
    end
    
    %pause(0.01)
    I = fread(fin, size, precision); 
    Z = reshape(I, rows, cols);
    ims = [ims {Z}];
    fclose(fin);
end
display('done with frame import')

end