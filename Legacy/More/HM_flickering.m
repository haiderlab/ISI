%% Resize stack
resizeImage = {};
for i = 1:length(ims)
    img = double (imresize(ims{i}, [512 512]));
    resizeImage{i} = img;
end
resizeImage = cat(3,resizeImage{:});
% Time vector
t = linspace(0,(max(timeStimReal)-min(timeStimReal))/1000,length(timeStim));
tt = linspace(min(timeStimReal),max(timeStimReal),length(timeStim));
% Finding indexes from when Phothodiode is rising 
threshold = 3.5;
bars = find(abs(diff(timeStim > threshold)')>0);
barsON = bars(1:2:end);  
%barsON = barsON(33:end); 
tt_trans = tt';
timeF = tt_trans(barsON(1));
period = (tt_trans(barsON(4))- tt_trans(barsON(3))); 
% Left section 
% 1 sec = 1000 millisec before rise
% Let's find index
idx_L_frames_stim = [];
for yy = 1:length(barsON)
    idx_L_frames_stim(yy) =  FindIndexCloseTo(timevecReal, (tt_trans(barsON(yy))-1000));
end
limit = length(idx_L_frames_stim)-1;
%% Map
resp = [];
for i = 1:size(resizeImage,1)
    i
    for j = 1:size(resizeImage,2)
        pixel_intensity = squeeze(resizeImage(i,j,:));
        for k = 1:limit
            tmp = pixel_intensity(idx_L_frames_stim(k):idx_L_frames_stim(k)+60)- nanmean(pixel_intensity(idx_L_frames_stim(k):idx_L_frames_stim(k)+10));
            resp(:,k) = tmp;
        end
        single_pix_Avg = nanmean(resp,2);
         adj_1 = min(single_pix_Avg);
         map_1(i,j) = adj_1; 
    end
end 
imagesc(map_1);colorbar
%% Centroid
%x = imbinarize(uint8(map_1));%'ForegroundPolarity','dark','Sensitivity',0.5);
threshold_centroid = 250;
x = uint8(map_1)>threshold_centroid;
Ilabel = bwlabel(x);
g = regionprops(Ilabel,'centroid');
figure; 
imagesc(map_1);colorbar
title('HM map - Binoc Raw');
hold on
plot(g(4).Centroid(1),g(4).Centroid(2),'r*');
hold off


