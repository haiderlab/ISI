%% Stacks of images 
inputFreq_f = 0.1;
inputFreq_b = 0.1;
[resizeImage_b,Fs_b] = resizingImage(ims_b,timevecReal_b,inputFreq_b,1,timeStim_b,timeStimReal_b);
[resizeImage_f,Fs_f] = resizingImage(ims_f,timevecReal_f,inputFreq_f,9,timeStim_f,timeStimReal_f);

%% Map 
stack_f = resizeImage_f;
stack_b = resizeImage_b;
for i = 1:size(stack_f,1)
    
    for j = 1:size(stack_f,2)
        
        % Forward
        intensity_f = squeeze(stack_f(i,j,:));
        ff1_f = fft(intensity_f);
        sh1_f = fftshift(ff1_f);
        sh1_R_f = sh1_f(length(sh1_f)/2: end); 
        ly_f = length(ff1_f);
        f_1_f = (-ly_f/2:ly_f/2-1)/ly_f*Fs_f;
        len_1_f = f_1_f(length(f_1_f)/2: end);
        idx_f = find(len_1_f >= (inputFreq_f - (inputFreq_f*5/100)) & (len_1_f < (inputFreq_f + (inputFreq_f*5/100))));
        index_f = max(idx_f);  
        
        % Backward
        intensity_b = squeeze(stack_b(i,j,:));
        ff1_b = fft(intensity_b);
        sh1_b = fftshift(ff1_b);
        sh1_R_b = sh1_b(length(sh1_b)/2: end);
        ly_b = length(ff1_b);
        f_1_b = (-ly_b/2:ly_b/2-1)/ly_b*Fs_b;
        len_1_b = f_1_b(length(f_1_b)/2: end);
        idx_b = find(len_1_b >= (inputFreq_b - (inputFreq_b*5/100)) & (len_1_b < (inputFreq_b + (inputFreq_b*5/100))));
        index_b = max(idx_b);
        
        % Mapping
%         adj_1 = rad2deg(angle(sh1_R_f(index_f))/2); %+ pi/4);
%         adj_2 = rad2deg(angle(sh1_R_b(index_b))/2); %+ pi/4); 
%         adj_1 = angle(sh1_R_f(index_f));
%         adj_2 = angle(sh1_R_b(index_b));
        adj_1 = sh1_R_f(index_f);
        adj_2 = sh1_R_b(index_b);
        adj = adj_1 / adj_2;
        map_f(i,j) = adj_1;
        map_b(i,j) = adj_2; 
        map_1(i,j) = adj;
    end
end
figure; clf
imagesc(rad2deg(angle(map_1))/2); colorbar; 
title('Absolute map');
% figure;
% imagesc(rad2deg(map_f)/2); colorbar; 
% title('Forward map');
% figure;
% imagesc(rad2deg(map_b)/2); colorbar; 
% title('Backward map');

%% Renaming
ims_f = ims_b;
timevecReal_f = timevecReal_b;
timeStim_f = timeStim_b;
timeStimReal_f = timeStimReal_b;
clear ims timevecReal timeStim timeStimReal

