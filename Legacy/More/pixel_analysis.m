%% First section 
% Note the images are not resized 
% Pixel analysis 
x_values = [590:599];
y_values = [550:559];
pixO = zeros(1,length(ims));
timeStep = timevecReal - timevecReal(1); % TimeStep are in milliseconds
pixel_values_array = {};
% Ploting signal points
for ii = 1:length(x_values)
    x_val = x_values(ii);
    
    for jj = 1:length(y_values)
        y_val = y_values(jj);
        
        for kk = 1:length(ims)
            pixO(kk) = ims{kk}(x_val,y_val);
        end     
        pixel_values_array{ii,jj} = pixO; 
    end
end
%save('session_1_pixVal.mat','pixel_values_array');

% Plot of Stimulus display picked up by photo diode
t = linspace(0,(max(timeStimReal)-min(timeStimReal))/1000,length(timeStim));
%figure; 
%plot(t,timeStim);
tt = linspace(min(timeStimReal),max(timeStimReal),length(timeStim));
%plot(tt,timeStim);   

% Finding indexes from when Phothodiode is rising 
threshold = 3;
bars = find(abs(diff(timeStim > threshold)')>0);
SessionNo = input('Check timeStim. Have you changed saved session No.? ');
barsON = bars(1:2:end);
%barsON = barsON(21:end); 
% To find the real time in Millisec of first PD flash rise 
tt_trans = tt';
timeF = tt_trans(barsON(1));
% So now, if you want to find the difference in time between two flashes 
% you can do. Note that if you devide by 1000, you get the period of the
% stimulus 
period = (tt_trans(barsON(4))- tt_trans(barsON(3))); %in Millisec
 
% Finding the closest the nearest frame grabbed time to stimulus displayed 
first_PD_spike = tt_trans(barsON(1));
dist = abs(timevecReal - first_PD_spike);
idx = find( dist == min(dist));
near_frame_time = timevecReal(idx);
% Or use function FindIndexCloseTo 


% You can use a loop to find the closest but greater value 
% Sectioning each signal by the number of repeats 
% To do so you need to get the index of the nearest index 
% To that value you need to add: period - (period*duty_cycle) 
% The whole monoc screen has duty cycle of 0.1
% So... Let's do the first section

% Left section 
% 1 sec = 1000 millisec before rise
% Let's find index
idx_L_frames_stim = [];
for yy = 1:length(barsON)
    %idx_L_frames_stim(yy) =  FindIndexCloseTo(timevecReal, (tt_trans(barsON(yy))-1000)+2240);
    idx_L_frames_stim(yy) =  FindIndexCloseTo(timevecReal, (tt_trans(barsON(yy))-1000));
end
% Right section 
% 5 sec = Period after rise
idx_R_frames_stim = [];
for ww = 1:length(barsON)
    %idx_R_frames_stim(ww) = FindIndexCloseTo(timevecReal, (tt_trans(barsON(ww))+ (period))+ 2240);
    idx_R_frames_stim(ww) = FindIndexCloseTo(timevecReal, (tt_trans(barsON(ww))+ (period)));
end
% Let's find the baseline index
base_index = [];
for gg = 1:length(barsON)
    %base_index(gg) = FindIndexCloseTo(timevecReal, (tt_trans(barsON(gg))- 1000)+ 2240); % 2 sec B/F rise 
    base_index(gg) = FindIndexCloseTo(timevecReal, (tt_trans(barsON(gg))- 1000));
end
 

%%
pixel_values_array2 = reshape(pixel_values_array,[size(pixel_values_array,1)*size(pixel_values_array,2),1]);
binnedBIG_pix = nan(length(pixel_values_array2),150);
for bb = 1:length(pixel_values_array2) 
        bb
        pixel_v = pixel_values_array2{bb};
        
        sec = {};
        endloop = length(barsON)-3;
        for qq = 1:endloop % The last 2 rise are end of stimulus and end of experiment & 3 spike from left is bad
            sec{1,qq} = pixel_v(idx_L_frames_stim(qq) : idx_R_frames_stim(qq));
            
            sec{2,qq} = timevecReal(idx_L_frames_stim(qq) : idx_R_frames_stim(qq));
            
            %baseline = mean(pixel_v(base_index(qq) : idx_L_frames_stim(qq)));
            
            sec{1,qq} = sec{1,qq} - mean(sec{1,qq}(1:10));
        end
        % Binning data together
        firstbin = -50;
        binwidth = 100;
        lastbin = 14950;
        edges = firstbin:binwidth:lastbin;
        binned_pix = nan(size(sec,2),(lastbin-firstbin)/binwidth);
        for ff = 1:length(sec)
            newvec = nan(1,150);
            %h = histogram(sec{2,ff}-sec{2,ff}(1),'BinWidth',100);
            h = histogram(sec{2,ff}-sec{2,ff}(1),'BinEdges',edges);
            newvec(find(h.Values)) = sec{1,ff};
            binned_pix(ff,:) = newvec;
        end
        avsig = nanmean(binned_pix,1);
        binnedBIG_pix(bb,:) = avsig;
        %plot(-1000:100:4100,nanmean(binned_pix,1));
    
end

%plot(-1000:100:5100,nanmean(binnedBIG_pix,1));
%figure; plot(-1000:100:5100,nanmean(binnedBIG_pix,1));
figure; plot(-1000:100:13900,nanmean(binnedBIG_pix,1));
hold on
plot([0,0],[-2,2],'--')
title '21 pixels analysis inside ROI'
%ylim([-0.4 0.2])
%save('session_5.mat','binnedBIG_pix');



% figure; plot(-1000:100:5100,nanmean(All_pix,1));
% hold on
% plot([0,0],[-0.2,0.2],'--')
% title('121 pixels analysis outside ROI')






        