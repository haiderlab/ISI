function test_fun_donghoon(loc_GL,loc_RL,limitbit)


%% Resize Green & Red

tic
load(loc_GL);
g_ar = double(ims{1});
load(loc_RL);

%%
red_array = double(cat(3,ims{:}));
[Green_P, ims_n] = resizeISI(g_ar, red_array);
%plotimgs(Green_P,ims_n(:,:,1));

% Compute  
g_im = imresize(Green_P,0.5);
%resizeImage_f = imgaussfilt(imresize(ims_n,0.5),1);
resizeImage_f = imresize(ims_n,0.5);
% g_im = Green_P;
% resizeImage_f = ims_n;

%% Stimulus is ON
% gather frames by each iteration of the stimulus

tt = linspace(min(timeStimReal),max(timeStimReal),length(timeStim));
tt_trans = tt';
threshold = 3.5;
bars = find(abs(diff(timeStim > threshold)')>0);
barsON = bars(1:2:end);
barStartIDx = FindIndexCloseTo(tt_trans(barsON), timevecReal(1));
barsON = barsON(barStartIDx+1:end-1); %barStart is where bar rises on set
period = (tt_trans(barsON(4))- tt_trans(barsON(3)))/1000;
inputFreq = 1/period;
endL = (round(period) + 1)*10;
% Computation of index
idx_L_frames_stim = [];
for yy = 1:length(barsON)
    idx_L_frames_stim(yy) =  FindIndexCloseTo(timevecReal, (tt_trans(barsON(yy)-1000)));
end
toc
%% Making movie
% Overall Average each iteration 
tic 
movieCat = resizeImage_f;
limit = length(idx_L_frames_stim)-1;
if limitbit == 1
    limit = [1:limit];
end
if limitbit ~= 1
    limit = [1:limit]
end
for i = limit
    i
    f = movieCat(:,:,idx_L_frames_stim(i):idx_L_frames_stim(i)+endL);
    b = mean(f(:,:,1:10),3);
    tmp = f - b;
    resp_1(:,:,:,i) = tmp;
end
movMix = nanmean(resp_1,4);
toc
save([loc_RL(1:end-7) 'avg_' loc_RL(end-6:end)], 'movMix','timevecReal','inputFreq','g_im');
%% Fourier
% stack_b = movMix;
% respA = [];
% timeAdjustedDiff_f = diff(timevecReal(2:end))/1000;
% Fs_f = 1 ./ mode(timeAdjustedDiff_f);
% for i = 1:size(stack_b,1) 
%     i
%     for j = 1:size(stack_b,2)
%        intensity_b = squeeze(stack_b(i,j,:));
%         % FFT
%       [ind, sh1_R_b,len_1_b] = tr(intensity_b, Fs_f, inputFreq);
%       
%         % Plotting
%        a = angle(sh1_R_b); %angle(sh1_R_b);
%        m = a(1); 
%        map_1(i,j) = m; %mod(m, 2*pi);
%     end
% end
%figure; imagesc(rad2deg(map_1)); colormap jet; colorbar 