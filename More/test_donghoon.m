function [g_ar, map_1] = test_fun_donghoon(loc_GL,loc_RL)


%% Resize Green & Red

clear
clc

load(loc_GL);
g_ar = double(ims{1});
load(loc_RL);

%%

red_array = double(cat(3,ims{:}));
[Green_P, ims_n] = resizeISI(g_ar, red_array);
plotimgs(Green_P,ims_n(:,:,1));
%% Compute  
resizeImage_f = ims_n;
%% Stimulus is ON
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
% Computation index
idx_L_frames_stim = [];
for yy = 1:length(barsON)
    idx_L_frames_stim(yy) =  FindIndexCloseTo(timevecReal, (tt_trans(barsON(yy)-1000)));
end
%% Making movie
clear resp_1
movieCat = resizeImage_f;
limit = length(idx_L_frames_stim)-1;
for i = 1:limit
    i
    f = movieCat(:,:,idx_L_frames_stim(i):idx_L_frames_stim(i)+endL);
    b = nanmean(movieCat(:,:,idx_L_frames_stim(i):idx_L_frames_stim(i)+10),3);
    tmp = f - b;
    resp_1(:,:,:,i) = tmp;
end
movMix = nanmean(resp_1,4);
% Fourier
stack_b = movMix;
respA = [];
timeAdjustedDiff_f = diff(timevecReal(2:end))/1000;
Fs_f = 1 ./ mode(timeAdjustedDiff_f);
for i = 1:size(stack_b,1) 
    i
    for j = 1:size(stack_b,2)
       intensity_b = squeeze(stack_b(i,j,:));
        % FFT
      [ind, sh1_R_b,len_1_b] = tr(intensity_b, Fs_f, 0.2);
      
        % Plotting
       a = angle(sh1_R_b); %angle(sh1_R_b);
       m = a(1); 
       map_1(i,j) = m; %mod(m, 2*pi);
    end
end
%map = rad2deg(map_1);
figure; imagesc(rad2deg(map_1)); colormap jet; colorbar  
%figure; imagesc(imgaussfilt(map_1,10)); colormap jet; colorbar  
% Absolute = (for - bck)/2 
%azimuth
%figure; imagesc((rad2deg(tt)*206/360)+44 ); colormap jet; colorbar 
%altitude 
%figure; imagesc((rad2deg(tt)*74.4/360)-3.5 ); colormap jet; colorbar

%% Visual field sign 
%az = (for - bck)/2 - azimuth
%al = (for - bck)/2 - altitude
kmap_hor = az(1:11:end,1:11:end); % Downsampling
kmap_vert = al(1:11:end,1:11:end);% Downsampling

[dhdx dhdy] = gradient(kmap_hor);
[dvdx dvdy] = gradient(kmap_vert);
graddir_hor = atan2(dhdy,dhdx);
graddir_vert = atan2(dvdy,dvdx);
vdiff = exp(1i*graddir_hor) .* exp(-1i*graddir_vert); %Should be vert-hor, but the gradient in Matlab for y is opposite.
VFS = sin(angle(vdiff)); %Visual field sign map
id = find(isnan(VFS));
VFS(id) = 0;
hh = fspecial('gaussian',size(VFS),3); 
hh = hh/sum(hh(:));
VFS = ifft2(fft2(VFS).*abs(fft2(hh))); 
% Plotting visual field
figure; imagesc(VFS); colormap jet; colorbar
% 
gradmag = abs(VFS);
threshSeg = 1.5*std(VFS(:));
imseg = (sign(gradmag-threshSeg/2) + 1)/2;  %threshold visual field sign map at +/-1.5sig
id = find(imseg);
imdum = imseg.*VFS; imdum(id) = imdum(id)+1.1;
figure; ploteccmap(imdum,[0.15 2],39); colorbar off


