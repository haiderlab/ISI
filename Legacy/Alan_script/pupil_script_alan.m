clear; close all
addpath(genpath('\\neuro-cloud\labs\haider\Data\analyzedData\DelRosario\Pupil\Alan New Script'))
tic
% Load video file
animal = 'M190206_1';
Date = '2019-05-08';
sess = '1';

cd(fullfile('\\neuro-cloud\labs\haider\Data\EYE\ExpData\', animal, Date, sess))
S = fullfile('\\neuro-cloud\labs\haider\Data\EYE\ExpData\', animal, Date, sess, [Date '_' sess '_' animal '_eye.mj2']);
obj = VideoReader(S);
images = read(obj,[1 obj.NumberOfFrames]);

%Create processed data save file name
[~,filename,~] = fileparts(S);
filename = sprintf('%s%s',filename,'_processed');

N = length(images(1,1,1,:));

toc
% Crop Video
imshow(images(:,:,1,1));axis equal tight off
hold on
title('Click Crop borders','fontsize',16,'fontweight','bold')
[x1,y1] = ginput(2);
x2 = sort(x1);
y2 = sort(y1);
images = images(round(y2(1)):round(y2(2)),round(x2(1)):round(x2(2)),:,:);
hold off

% Set center of pupil
imshow(images(:,:,1,1));axis equal tight off
hold on
title('Click in the middle of the pupil','fontsize',16,'fontweight','bold')
[x,y] = ginput(1);

pupil_pixels = cell(N,1);
pupil_centroid = zeros(N,2);
pupil_area = zeros(N,2);
close

% Set default thresholds
imageThreshold = 220;
areaThreshold = 100;
maxArea = 3000;
diskSize = 6;

    % Transfer variables to GUI
    parameters.images = images;
    parameters.N = N;
    parameters.imageThreshold = imageThreshold;
    parameters.areaThreshold = areaThreshold;
    parameters.maxArea = maxArea;
    parameters.diskSize = diskSize;
    parameters.x = x;
    parameters.y = y;
    
% Load GUI
g = script_GUI;

% Wait for parameters to be set in GUI
waitfor(g)
    nan_idx = [];
tic
    h = fspecial('disk',diskSize); %blur image filter
    
for i=1:N
    
    Q = imcomplement(imfilter(squeeze(images(:,:,1,i)),h)) > imageThreshold;
    imfill(Q,'holes');
    P = regionprops(Q,'Area','Centroid','PixelIdxList');
    z = [P(:).Area];
    largeRegionIdx = find(z > areaThreshold & z < maxArea);
    
    L = length(largeRegionIdx);
    w = reshape([P(largeRegionIdx).Centroid]',[2 L])';
    ds = sum(bsxfun(@minus,w,[x y]).^2,2);
    [~,minIdx] = min(ds);
    
    q = false(size(Q));
    if ~isempty(largeRegionIdx)
        q(P(largeRegionIdx(minIdx)).PixelIdxList) = true;
        q = imdilate(q,strel('disk',diskSize/2));
        
        P2 = regionprops(q,'Centroid','PixelIdxList','Area');
        
        pupil_centroid(i,:) = P2(1).Centroid;
        pupil_pixels{i} = P2(1).PixelIdxList;
        pupil_area(i) = P2(1).Area;
    %Plot Data
%         imshow(images(:,:,1,i));
%         axis equal tight off
%         hold on
%         title(num2str(i),'fontsize',16,'fontweight','bold')
%         B = bwboundaries(q);
%         plot(B{1}(:,2),B{1}(:,1),'m-','linewidth',2)
%         drawnow
%         hold off
        nan_idx(i) = 0;
    else
        nan_idx(i) = 1;
%         pupil_centroid(i,:) = NaN;
%         pupil_pixels{i} = NaN;
%         pupil_area(i) = NaN;
    end
end
%%
pupil_distance2center = pupil_centroid - [x*ones(length(pupil_centroid),1),y*ones(length(pupil_centroid),1)];
nan_idx = logical(nan_idx);
handles.results = struct('x', [], 'y', [], 'area',[]);
    handles.results.x = pupil_centroid(:,1);
    handles.results.x(nan_idx) = nan;
    handles.results.y = pupil_centroid(:,2);
    handles.results.y(nan_idx) = nan;
    handles.results.area = pupil_area(:,1);
    handles.results.area(nan_idx) = nan;
    handles.results.x = handles.results.x + x2(1) - 1; %Return x and y coordinates to original video size
    handles.results.y = handles.results.y + y2(1) - 1;
    
handles.state = struct('ImageThreshold',[],'AreaThreshold', [], 'MaxArea', [], 'DiskSize', []);
    handles.state.ImageThreshold = imageThreshold;
    handles.state.AreaThreshold = areaThreshold;
    handles.state.MaxArea = maxArea;
    handles.state.DiskSize = diskSize;
data2save = struct;
data2save.results = handles.results;
data2save.state = handles.state;

NaNFrames = sum(nan_idx);
txt1 = sprintf('All %d frames have been analyzed.', N)
txt2 = sprintf('%d NaN Frames found.', NaNFrames)
toc

%Plot data
figure(1)
plot(linspace(1,N,N),[handles.results.x])
title(sprintf('%s Pupil Centroid x Data',filename),'Interpreter','none')
ylabel('Pupil Centroid x Position')
xlabel('Frame Number')

figure(2)
plot(linspace(1,N,N),[handles.results.y])
title(sprintf('%s Pupil Centroid y Data',filename),'Interpreter','none')
ylabel('Pupil Centroid y Position')
xlabel('Frame Number')

figure(3)
plot(linspace(1,N,N),[handles.results.area])
title(sprintf('%s Centroid Pupil Area Data',filename),'Interpreter','none')
ylabel('Pupil Area')
xlabel('Frame Number')

%%
save(filename,'-struct','data2save')


