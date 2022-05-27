%% x
ims_f = ims;
timevecReal_f = timevecReal;
timeStim_f = timeStim;
timeStimReal_f = timeStimReal;
clear ims timevecReal timeStim timeStimReal
%% resizing images & storing
clear resizeImage_f
for i = 1:length(ims_f)
     img_f = double (imresize(ims_f{i}, [512 512]));
     resizeImage_f{i} = imgaussfilt(img_f,1); % sigma = 200 um * Nbr_px_counted/L_known 
     %resizeImage_f{i} = img_f;
end
resizeImage_f = cat(3,resizeImage_f{:});

%% Stimulus is ON
tt = linspace(min(timeStimReal_f),max(timeStimReal_f),length(timeStim_f));
tt_trans = tt';
threshold = 3.5;
bars = find(abs(diff(timeStim_f > threshold)')>0);
barsON = bars(1:2:end);
barStartIDx = FindIndexCloseTo(tt_trans(barsON), timevecReal_f(1));
barsON = barsON(barStartIDx+1:end-1); %barStart is where bar rises on set
period = (tt_trans(barsON(4))- tt_trans(barsON(3)))/1000;
inputFreq = 1/period;
endL = (round(period) + 1)*10;
%% Computation
% Index
idx_L_frames_stim = [];
for yy = 1:length(barsON)
    idx_L_frames_stim(yy) =  FindIndexCloseTo(timevecReal_f, (tt_trans(barsON(yy)-1000)));
end
%% Making movie
movieCat = resizeImage_f;
limit = length(idx_L_frames_stim)-1;
for i = 1:limit
    i
    f = movieCat(:,:,idx_L_frames_stim(i):idx_L_frames_stim(i)+endL);
    b = nanmean(movieCat(:,:,idx_L_frames_stim(i):idx_L_frames_stim(i)+10),3);
    %tmp = log10(f./b)*37500000;%./(9443.6*0.15);
    %tmp = uint8(tmp);
    tmp = f - b;
    resp_1(:,:,:,i) = tmp;
    %resp_2(:,:,:,i) = (tmp-min(min(min(tmp))))./(max(max(max(tmp)))-min(min(min(tmp))));
end
movMix = nanmean(resp_1,4);

%% Display
%save 'movMix.mat'
% t = nanmean(movieAvg,3);
% for k = 1:size(movieAvg,3)
% tmX(:,:,i) = imabsdiff(movieAvg(:,:,i), t);
% end
% 
% Map = nanmean(movieAvg,3);
%movieAvg_2 = resp_1(:,:,10);
%movieAvg = nanmean(resp_1,4);
%implay(movieAvg,10);
% %save('Block_5.mat','movieAvg_1');
%map_all = nanmean(movieAvg,3); % 26 is the frame where change appears
%figure; imagesc(nanmean(movieAvg,3)); colorbar;

%% Map
map_all = resp(:,:,26); % 26 is the frame where change appears
figure; imagesc(map_all); colorbar;

%% HM
[a,b] = min(nanmean(resp_1,4),[],3);
%[a,b] = max(resp_1(:,:,:,1),[],3);
% x = nanmean(nanmean(resp_1,4),3);
% Videos
% Change during second stimulus 
%implay(resp_1(:,:,:,2));
% Average during avg stimulus display
%implay(nanmean(resp_1,4));
imagesc(a);
title 'HM response at 45';
%imagesc(b);

figure; 
filt_L = fourierLowF(x,0.05);
filt_L = filt_L - min(min(filt_L))-0;
norm_L = filt_L.*(1/(max(max(filt_L))-min(min(filt_L))));
imagesc(norm_L); colorbar; 

% Mix files 
%all(:,:,:,1) = B_avg{1,1}
%final_m = nanmean(all,4);
%implay(final_m,10);
%[a,b] = min(nanmean(final_m,4),[],3);
%imagesc(a)
%figure; imagesc(mean(final_m,3))
%x = nanmean(final_m,3);

%% 

for i = 1:size(movieAvg_1,3)
    t = movieAvg_1(:,:,1);
    save 't.jpg'
end

    



