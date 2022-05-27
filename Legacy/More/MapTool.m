% resizeImage = {};
% orgImage = ims; 
% for i = 1:length(ims)
%      pImage = imresize(orgImage{i}, [512 512]);
%     resizeImage{i} = pImage;
% end
% Fs = Fs_mode; % Mell change this by uncommenting above
% inputFreq = 0.1;
% resizeImage = cat(3,resizeImage{:});



resizeImage = {};
%imgOri = double (imresize(ims{1}, [512 512]));
% Normalizing frames
% Low
% filt_L = fourierLowF(map_1,0.2);
% filt_L = filt_L - min(min(filt_L))-0;
% norm_L = filt_L.*(1/(max(max(filt_L))-min(min(filt_L))));

for i = 1:length(ims)
     img = double (imresize(ims{i}, [512 512]));
%     filt_1 = fourierLowF(img,0.3); 
%     filt_1 = filt_1 - min(min(filt_1))-0;
%     Anorm_1 = filt_1.*(1/(max(max(filt_1))-min(min(filt_1))));
%     resizeImage{i} = mat2gray(Anorm_1 - norm_L);
     
    resizeImage{i} = img;
   
end
timeAdjustedDiff = diff(timevecReal)/1000;
Fs = 1 ./ mode(timeAdjustedDiff); % Mell change this by uncommenting above
%Fs = 8.3057;
inputFreq = input('Enter the frequency of the stimulus (MUST BE > 0.005): ');
resizeImage = cat(3,resizeImage{:});









% Resizing stack
% Each column represents all pixels (reflectance) intensity at time = t1,t2 ...
% Each row represents a single pixel signal (change)
% resizeImage_2 = reshape(resizeImage,[],size(resizeImage,3));
% Finding power density of new stack
% L = size(resizeImage_2,1);
% n = 2^nextpow2(L);
% powerStack = fft(resizeImage_2,[],1);
% L = size(powerStack,1);
% P2 = powerStack./L;
% P2 = abs(P2);
% P1 = P2(1:L/2+1,:);
% P1(2:end-1,:) = 2*P1(2:end-1,:);

% % Denominator coeff. of rational transfer function
% a = 
% % Numerator coeff. of rational transfer function
% b = 
% % Initial conditions for filter delays
% zi = 
% % y = filter(b,a,x,zi,dim)
% filtMatrix = filter(

% Filter design 
% 'Fp,Fst,Ap,Ast'
% Fp = frequency pass
% Fst = frequency at end of stop band
% Ap = amount of ripple allowed in pass band 
% Ast = Attenuation in stop band
% d = fdesign.lowpass(0.125,0.9,1,60,Fs);
% h = design(d,'equiripple');
% sign = filter(h,resizeImage_2,2);

%%
%newStack = reshape(sign, 512,512, []);
newStack = resizeImage;
stack_int = {};
%figure(1);
for k = 200
    k
for i = 1:size(newStack,1)
    i
    for j = 1:size(newStack,2)
        intensity = squeeze(newStack(i,j,:));
        %stack_int{i,j} = intensity;
        ff1 = fft(intensity);
        sh1 = fftshift(ff1);
        sh1_R = sh1(length(sh1)/2: end);

        % Create array of indexes from pixel
        % Length vector
        ly = length(ff1);
        f_1 = (-ly/2:ly/2-1)/ly*Fs;
        len_1 = f_1(length(f_1)/2: end);
 
        % Index at Stimulus frequency
        idx = find(len_1 >= (inputFreq - (inputFreq*5/100)) & (len_1 < (inputFreq + (inputFreq*5/100))));
        index_1 = max(idx);
        index_2 = min(idx);
        % Phase adjustment at index stimulus
%         adj = -1* (rad2deg(angle(sh1_R(index))/pi));
        
        adj_1 = rad2deg(angle(sh1_R(index_1)))/2;
        map_1(i,j) = adj_1; 
        
%         adj_2 = rad2deg(angle(sh1_R(index_2)));
%         map_2(i,j) = adj_2;
        
        
        % remove small-magnitude transform values
%         th = k;
%         sh1_R(abs(sh1_R) < th) = 0;


        %Get this index from "Frequency_And_Phase_Domain"
%         tmp = rad2deg((angle(sh1_R))/pi);
%         tmpAdjusted = (tmp + adj)* 360/300; % *180/128 - 29.2 was done for calibration and set 0 degree at Middle of binoc
%         map(i,j) = tmpAdjusted(index);
    end
 end
figure; clf
imagesc(map_1); colorbar; 
pause(0.01)
title('"Retinotopic" map - Monoc Raw');

% figure; 
% filt_L = fourierLowF(map_1,0.1);
% filt_L = filt_L - min(min(filt_L))-0;
% norm_L = filt_L.*(1/(max(max(filt_L))-min(min(filt_L))));
% imagesc(norm_L); colorbar; 
% title('"Retinotopic" map - Monoc Smth.');
end















% figure(1);
% for k = 50:1000:20000
%     k
%     for j = 1:size(sign,1)
%         j
%         % Y - axis
%         %signal = squeeze(resizeImage_2(:,j));
%         signal = sign(j,:);
%         L = length(signal);
%         Y = fft(signal);
%         P2 = abs(Y/L);
%         P1 = P2(1:L/2+1);
%         P1(2:end-1) = 2*P1(2:end-1);
% 
%         
%         % X- axis 
%         f = Fs*(0:(L/2))/L;
%         
%         % index 
%         idx = find(f >= (inputFreq - (inputFreq*15/100)) & (f < (inputFreq + (inputFreq*15/100))));
%         index = max(idx);
%         
%         %filter spectrum for better image
%         th = k;
%         P1(abs(P1) < th) = 0;
% 
%         % Phase adjustment at index stimulus
%         adj = -1* (rad2deg(angle(P1(index))/pi));
%         % Map at Stim Frequency
%         tmp = rad2deg((angle(P1))/pi);
%         tmpAdjusted = ((tmp + adj)* 180/300); % *180/128 - 29.2 was done for calibration and set 0 degree at Middle of binoc
%         map(j) = tmpAdjusted(index);
%          
%     end
%     map_2 = reshape(map, [512, 512]);
% figure(1); clf
% imagesc(map_2); colorbar;
% title('Retinotopic Map');
% end
