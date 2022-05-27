function [period,inputFreq, resizeImage_f,Fs_f, timeStamps,bsln,barsON,tt] = resizingImage(ims_f,timevecReal_f, barStart,timeStim_f,timeStimReal_f) 
%% resizing images & storing
for i = 1:length(ims_f)
     img_f = double (imresize(ims_f{i}, 0.5));
     %img_f = double(ims_f{i});
     resizeImage_f{i} = imgaussfilt(img_f,1); % sigma = 200 um * Nbr_px_counted/L_known 
     %resizeImage_f{i} = img_f;
end
resizeImage_f = cat(3,resizeImage_f{:});

%% Stimulus is ON
tt = linspace(min(timeStimReal_f),max(timeStimReal_f),length(timeStim_f));
tt_trans = tt';
threshold = 3;
bars = find(abs(diff(timeStim_f > threshold)')>0);
barsON = bars(barStart:2:end);
%barStartIDx = FindIndexCloseTo(tt_trans(barsON), timevecReal_f(1));
barsON = barsON(1:end-2); %barStart is where bar rises on set
period = (tt_trans(barsON(2))- tt_trans(barsON(1)))/1000;
inputFreq = 1/period;

%% Find frames during stimulus
frames_stim_idx(1) = FindIndexCloseTo(timevecReal_f, (tt_trans(barsON(1))));
%frames_stim_idx(1) = 150;
frames_stim_idx(2) = FindIndexCloseTo(timevecReal_f, (tt_trans(barsON(end))));
%frames_stim_idx(2) = length(timevecReal_f) - 150;


%% Frame sampling time (sec) & Phase

timeStamps = timevecReal_f(:,frames_stim_idx(1):frames_stim_idx(2));
%timeStamps = timevecReal_f(:,90:250);
b_1 = nanmean(resizeImage_f(:,:,1:frames_stim_idx(1)-1),3);
b_2 = nanmean(resizeImage_f(:,:,frames_stim_idx(2)+1:end),3);
bsln =(b_1 + b_2)/2;
%bsln = resizeImage_f(:,:,90:250);
resizeImage_f = resizeImage_f(:,:,frames_stim_idx(1):frames_stim_idx(2));
%resizeImage_f = resizeImage_f(:,:,90:250);
timeAdjustedDiff_f = diff(timevecReal_f(frames_stim_idx(1):frames_stim_idx(2)))/1000;
Fs_f = 1 ./ mode(timeAdjustedDiff_f); 
end

