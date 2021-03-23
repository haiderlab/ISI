function output = ISIpreprocess_new(loc_GL,loc_RL,limit_loc,plotbit,savebit,g_im,FPS)
% limit_loc = 0 or != 0 
threshold = 0.7; %original = 0.6
%% Resize Green & Red
if loc_RL(end-4) == '0' % To use same g_im for forward and backward
    load(loc_GL);
    g_ar = single(ims{1});
    g_im = imresize(g_ar,0.5);

elseif loc_RL(end-4) == '1'
else
    disp('Does your data use right file name?');
end

load(loc_RL);
red_array = single(cat(3,ims{:}));
ims_n = imresize(red_array,0.5);


% Alignment 
% [s1 s2 s3] = size(ims_n); [s4 s5] = size(g_im);
% [g_im, resizeImage_f] = resizeISI(g_im, ims_n);
[g_im, resizeImage_f] = alignGLRL(g_im,ims_n);

% if s4 > s1 && s5 > s2
%     [g_im, resizeImage_f] = alignGLRL(g_im,ims_n);
% else
%     [g_im, resizeImage_f] = resizeISI(g_im, ims_n);
% end





%% Stimulus is ON
% gather frames by each iteration of the stimulus
tt = linspace(min(timeStimReal),max(timeStimReal),length(timeStim));
tt_trans = tt';

loc = find(zscore(timeStim)>5);
bars_without_first = loc(find(diff(loc)>20000)+1);
barsON = [loc(1); bars_without_first];

barStartIDx = FindIndexCloseTo(tt_trans(barsON), timevecReal(1));
barsON = barsON(barStartIDx+1:end-1); %barStart is where bar rises on set

period = mode(tt_trans(barsON(2:end)) - tt_trans(barsON(1:end-1)))/1000;
inputFreq = 1/period;
endL = round(period)*FPS; %(round(period) + 1)*10;
% Computation of index
idx_L_frames_stim = [];
for yy = 1:length(barsON)
    idx_L_frames_stim(yy) =  FindIndexCloseTo(timevecReal, (tt_trans(barsON(yy)-1000)));
end
% Segmentation
movieCat = resizeImage_f;
limit = length(idx_L_frames_stim)-1;
if limit_loc == 0
    limit = [1:limit];
else
    limit = limit_loc;
end

if loc_RL(end-4) == '0'
    disp(['Forward path has ' int2str(length(limit)) ' periods.']);
elseif loc_RL(end-4) == '1'
    disp(['Backward path has ' int2str(length(limit)) ' periods.']);
else
    disp('Does your data using right file name?');
end

tempsize = movieCat(:,:,idx_L_frames_stim(1):idx_L_frames_stim(1)+endL-1);
f = repmat(tempsize,1,1,1,length(limit));
temp1 = nanmean(movieCat(:,:,1:50),3);
limit = limit(1:end-1);

% Slow signal detection/run [10 runs/block]
for i = 1:length(limit)
    f(:,:,:,i) = movieCat(:,:,idx_L_frames_stim(limit(i)):idx_L_frames_stim(limit(i))+endL-1);
    %temp1 = nanmean(f(:,:,11:190,i),3);
    %temp1 = movieCat(:,:,idx_L_frames_stim(limit(1))-40:idx_L_frames_stim(limit(1))+9);
    %temp1 = nanmean(temp1,3);
    b(:,:,:,i) = log10(f(:,:,:,i)./temp1);
end

%movMix = nanmean(b,4);
%% Choosing the good runs only
var_vec = [];
if plotbit == 1
    figure;
    for i = 1:length(limit)
        subplot(2,round(length(limit)/2),i);
        var_vec = [var_vec g_map(b(:,:,:,i),timevecReal,inputFreq,plotbit)];
        title(num2str(var_vec(i)))
    end
    findingoutThreshold();
else
    for i = 1:length(limit)
        var_vec = [var_vec g_map(b(:,:,:,i),timevecReal,inputFreq,plotbit)];
    end
end

%% Formatting the outputs & Save file if needed
nrun = sum(var_vec > threshold); % number of runs that is being averaged.
movMix = nanmean(b(:,:,:,var_vec>threshold),4); % movMix has only one iteration. i.e fs * period frames only

output.movMix = movMix;
output.timevecReal = timevecReal;
output.inputFreq = inputFreq;
output.g_im = g_im;
output.nrun = nrun;
savefilename = [loc_RL(1:end-7) 'ISIavg_' loc_RL(end-6:end)];
% if ~isfile(savefilename) || savebit
if ~(exist(savefilename, 'file')==2) || savebit
    save(savefilename, 'movMix','timevecReal','inputFreq','g_im','nrun');
end
