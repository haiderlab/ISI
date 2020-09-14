%% Getting one one pixel luminance accross all frames 
% Resizing all frames 
resizeImage = {};
orgImage = ims; 
for i = 1:length(ims)
     pImage = imresize(orgImage{i}, [512 512]);
    resizeImage{i} = pImage;
end

% Sampling Frequency
% timeAdjustedDiff = diff(timevecReal)/1000;
% Fs_mode = 1 ./ mode(timeAdjustedDiff);
% Fs_mean = 1 ./ mean(timeAdjustedDiff);
Fs = Fs_1; % Mell change this by uncommenting above

% Get from 1 pixel
% Transform x{:}(i,j) to x(i,j,:)
%inputFreq = input('Enter the frequency of the stimulus (MUST BE > 0.005): ');
inputFreq = 0.2;
resizeImage = cat(3,resizeImage{:});
pause 'on'
figure(1);

% clear ims timeStim timeStimReal timevecReal

% for k = 50:1000:20000
%     k
for i = 1:size(resizeImage,1)
    i
    for j = 1:size(resizeImage,2)
        intensity = squeeze(resizeImage(i,j,:));
        ff1 = fft(intensity);
        sh1 = fftshift(ff1);
        sh1_R = sh1(length(sh1)/2: end);
        % Create array of indexes from pixel
        % Length vector
        ly = length(ff1);
        f_1 = (-ly/2:ly/2-1)/ly*Fs;
        len_1 = f_1(length(f_1)/2: end);
        % Low pass filter
%         fpass = 0.5;
%         sh1_R = lowpass(sh1_R,fpass,Fs);
        % Index at Stimulus frequency
        idx = find(len_1 >= (inputFreq - (inputFreq*15/100)) & (len_1 < (inputFreq + (inputFreq*15/100))));
        index = max(idx);
        % Phase adjustment at index stimulus
        adj = -1* (rad2deg(angle(sh1_R(index))/pi));
        % filter spectrum for better image
%         th = k;
%         sh1_R(abs(sh1_R) < th) = 0;
        %Get this index from "Frequency_And_Phase_Domain"
        tmp = rad2deg((angle(sh1_R))/pi);
        tmpAdjusted = ((tmp + adj)* 180/300); % *180/128 - 29.2 was done for calibration and set 0 degree at Middle of binoc
        map(i,j) = tmpAdjusted(index);
    end
 end
figure(1); clf
imagesc(map); colorbar;
pause(0.01)
title('"Retinotopic" map using LED Array');
%end


%% To plot individual pixel accross all frames


%Change value of i,j for location of one pixel
x = input('Enter X-value of pixel: ');
y = input('Enter Y-value of pixel: ');
intensity = squeeze(resizeImage(x,y,:));
ff1 = fft(intensity);
sh1 = fftshift(ff1);
sh1_R = sh1(length(sh1)/2: end);

% Length vector
ly = length(ff1);
f_1 = (-ly/2:ly/2-1)/ly*Fs;
len_1 = f_1(length(f_1)/2: end);
% Plotting Power Spectrum
figure;
plot(len_1(2:end) ,abs(sh1_R(2:end)),'r-')
title 'Power Spectrum'
xlabel 'Frequency (Hz)'
ylabel '|y|'
grid  


