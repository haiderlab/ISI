function quickAnalysis2(ims,timevecReal,timeStim,timeSt,cropDim,timeStimReal)
%% Quickanalysis2

tt = linspace(min(timeStimReal),max(timeStimReal),length(timeStim));
tt_trans = tt';

loc = find(zscore(timeStim)>5);
bars_without_first = loc(find(diff(loc)>20000)+1);
barsON = [loc(1); bars_without_first];

barStartIDx = FindIndexCloseTo(tt_trans(barsON), timevecReal(1));
barsON = barsON(barStartIDx+1:end-1); %barStart is where bar rises on set

period = median(tt_trans(barsON(2:end)) - tt_trans(barsON(1:end-1)))/1000;
inputFreq = 1/period;
endL = (round(period) + 1)*10;
% Computation of index
idx_L_frames_stim = [];
for yy = 1:length(barsON)
    idx_L_frames_stim(yy) =  FindIndexCloseTo(timevecReal, (tt_trans(barsON(yy)-1000)));
end
%% Making movie
% Overall Average each iteration 
movieCat = cat(3,ims{:});
movieCat = movieCat(1:2:end,1:2:end,:);
movieCat = single(movieCat);

limit = 1:2:length(idx_L_frames_stim)-1;

tempsize = movieCat(:,:,idx_L_frames_stim(1):idx_L_frames_stim(1)+endL-1);
f = repmat(tempsize,1,1,1,length(limit));
temp1 = nanmean(movieCat(:,:,1:50),3);
%limit = limit(1:end-1);
for i = 1:length(limit)
    f(:,:,:,i) = movieCat(:,:,idx_L_frames_stim(limit(i)):idx_L_frames_stim(limit(i))+endL-1);
    b(:,:,:,i) = log10(f(:,:,:,i)./temp1);
end

movMix = nanmean(b(:,:,:,:),4); % movMix has only one iteration. i.e fs * period frames only
g_map(movMix,timevecReal,inputFreq,1);
clear;

%saveas(gcf,'Quicksession.fig');




