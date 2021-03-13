function [ims, timevec] = grabFrames(numberOfFrames, frameRateFps, frameDimensions, exePath, frameOutputDirectory, ROI)
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
% frameDimensions - array [width height] in pixels of output frame.
%
% exePath - executable file path to grab the frames. The executable should
% take numberOfFrames, frameRateFps, and frameOutputDirectory as command
% line arguments (matching this same order). Frames should be output to the
% frameOutputDirectory with numeric names starting from 1 with the .raw
% extension (e.g. 1.raw, 2.raw, etc.). Once grabbing is done, the
% executable should save a REPORT.txt file to indicate completion. Note
% that this function uses LastWriteTime as the time stamp for the captured
% frames, so it is best to output the frames as soon as they are grabbed.
%
% frameOutputDirectory - where the frame grabber saves the raw images to
% the disk. This should be an absolute/full directory path with a trailing 
% forward slash to avoid any issues. It is only used for temporary storage
% and does not need to be cleared - grabFrames checks file properties to
% only use images grabbed after grabFrames was called.
% (e.g. 'C:/Users/haider-lab/Downloads/frames/')
%
% ROI - region of interest used for cropping images when frames are
% imported after they are captured.


%% Set behavior values (mainly for debugging)
% If true, uses epoch time
useEpochTime = true;
timeZone = 'America/New_York';

% If true, waits for all frames to be grabbed before importing into MATLAB
% NOTE: must be true right now - simulatenous grabbing and importing is not
% yet working correctly
importAfterAllFramesGrabbed = true;

% If true, enables program to use already existing files. If false, waits
% for files to be newly written.
useOldFiles = false; 

%% Prepare path names
exePath = fullfile(exePath,'\');
frameOutputDirectory = fullfile(frameOutputDirectory,'\');


%% Run as exe - process
if ~exist(frameOutputDirectory, 'dir')
    display('FrameOutputDirectory does not exist - attempting to create directory')
    mkdir(frameOutputDirectory)
end

% Clear temporary folder
if useEpochTime
    disp(['Clearing raw & txt files in temporary folder - ' frameOutputDirectory])
    delete([frameOutputDirectory '*.raw']);
    delete([frameOutputDirectory '*.txt']);
end

startTime = datetime(clock);
if useOldFiles
    disp('Skipping frame capture - using old files')
else
    disp('Beginning frame capture')
    %command = sprintf('start /wait %s %d %f %s', exePath, numberOfFrames, frameRateFps, frameOutputDirectory)
    command = sprintf('start /realtime %s %d %f %s', exePath, numberOfFrames, frameRateFps, frameOutputDirectory);
    disp(command)
    system(command);
end

%% Wait for process to finish
if importAfterAllFramesGrabbed
    disp('Waiting for process to finish')
    stimTime = numberOfFrames * (1 / frameRateFps);
    pause(stimTime + 15) %previously used stimTime = getParamVal('stim_time')
    %lastFileName = sprintf('%s%d.raw', frameOutputDirectory, numberOfFrames);
    disp('Looking for last file')
    lastFileName = sprintf('%sREPORT.txt', frameOutputDirectory);
    
    % Check if last file already exists and check if old
    if ~useOldFiles && isfile(lastFileName)
        d = System.IO.File.GetLastWriteTime(lastFileName);
        creationDateTime = datetime(d.Year, d.Month, d.Day, d.Hour, d.Minute, d.Second);
        if creationDateTime < startTime
            %msg = sprintf('Warning: old report file will be overwritten - %s', lastFileName);
            %disp(msg)
        end
        
        % Wait until new file is overwritten
        while creationDateTime < startTime
            pause(0.1)
            d = System.IO.File.GetLastWriteTime(lastFileName);
            creationDateTime = datetime(d.Year, d.Month, d.Day, d.Hour, d.Minute, d.Second);
        end
    end
    
    while ~isfile(lastFileName)
        pause(10)
    end
    %pause(0.1)
end

%% Import images
disp('Beginning frame import')
cols = frameDimensions(1); %width
rows = frameDimensions(2); %height
size = cols * rows;
precision = 'uint8=>uint8';
ims = [];
timevec = [];

if useEpochTime
    disp('Using epoch time contained in filenames as frame time stamps');
    fns = dir([frameOutputDirectory '*.raw']);
    frameTimes = zeros(1,numberOfFrames);
    ims = cell(1,numberOfFrames);
    timevec = zeros(1,numberOfFrames); %converted to milliseconds of the current day
    
    if length(fns) ~= numberOfFrames
        error('Could not find correct number of frames in temporary folder');
    end
    
    for i = 1:length(fns)
        f = regexp(fns(i).name, '(?<frameNum>\d+)_(?<timeSinceEpochInMs>\d+).raw', 'names');
        if ~isempty(f)
            % Get time stamp
            ind = str2num(f.frameNum);
            frameTimes(ind) = str2double(f.timeSinceEpochInMs);
            d = datetime(frameTimes(ind),'ConvertFrom','epochtime','TicksPerSecond',1000,'TimeZone','UTC');
            d.TimeZone = timeZone;
            timevec(ind) = (d.Hour*3600 + d.Minute*60 + d.Second) * 1000;
            
            % Attempt to open file
            frameFilePath = fullfile(fns(i).folder,'\',fns(i).name);
            fin = fopen(frameFilePath, 'r');
            while fin == -1 % indicates file could not be opened
                fin = fopen(frameFilePath, 'r');
                pause(0.1)
            end
            
            % Import file
            I = fread(fin, size, precision);
            Z = reshape(I, cols, rows);
            ims{ind} = imcrop(Z',ROI);
            fclose(fin);
        end
    end
    
    % Plot difference b/t time stamps
    figure; plot(diff(timevec),'.');
    title(['Time Between Frame Time Stamps - ' num2str(frameRateFps) ' Hz']);
    xlabel('frame'); ylabel('diff(timevec) in ms');
    disp(['timvec(end)-timevec(1) = ' num2str(timevec(end)-timevec(1)) ' ms']);
    figure; plot(timevec);
    title(['Time Stamp Vector of Epoch Times - ' num2str(frameRateFps) ' Hz']);
    xlabel('frame'); ylabel('time since epoch time (ms)');
    
else
    disp('Using file modification times as frame time stamps');
    for i = 1:numberOfFrames
        imageFileName = sprintf('%s%d.raw', frameOutputDirectory, i);
        %imageFileName = ls(imageFileName)
        %regexp(str, '(?<frameNum>\d+)_(?<timeSinceEpochInMs>\d+).raw', 'names')

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
        dMilliseconds = (d.Hour*3600 + d.Minute*60 + d.Second) * 1000 + d.Millisecond;
        timevec = [timevec double(dMilliseconds)];
        creationDateTime = datetime(d.Year, d.Month, d.Day, d.Hour, d.Minute, d.Second);
        if ~useOldFiles && creationDateTime < startTime
            msg = sprintf('Warning: old file imported - %s%d.raw', frameOutputDirectory, i);
            disp(msg)
        end

        %pause(0.01)
        I = fread(fin, size, precision); 
        Z = reshape(I, rows, cols);
        Z_crop = imcrop(Z,ROI);
        ims = [ims {Z_crop}];
        fclose(fin);
    end
end
disp('Finished frame import')

% Clear temporary folder
if useEpochTime
    disp(['Clearing raw files in temporary folder - ' frameOutputDirectory])
    delete([frameOutputDirectory '*.raw']);
end

end