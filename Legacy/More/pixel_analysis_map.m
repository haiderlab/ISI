clear
load('../../../Data/ISI/Animal_Testing/Mouse_4_A19014/08_07/8/000.mat');
% x
ims_b = ims;
timevecReal_b = timevecReal;
timeStim_b = timeStim;
timeStimReal_b = timeStimReal;
clear ims timevecReal timeStim timeStimReal
% Stacks of images 
% Plot of Stimulus display picked up by photo diode
% [period_1,inputFreq_1,resizeImage_1,Fs_1, timeStamps_1,bslne_1,barsON_1,tt_1] = resizingImage(ims_f,timevecReal_f,1,timeStim_f,timeStimReal_f);
[period_3,inputFreq_3,resizeImage_3,Fs_3, timeStamps_3,bslne_3,barsON_3,tt_3] = resizingImage(ims_b,timevecReal_b,1,timeStim_b,timeStimReal_b);
%% Map
%stack_f = resizeImage_1;
stack_f = resizeImage_3;
respA = [];
for i = 1:size(stack_f,1) 
    i
    for j = 1:size(stack_f,2) 
        % Forward
        intensity_f_r = squeeze(stack_f(i,j,:));
        meanBaseline_f = bslne_3(i,j);
        intensity_f = -log10(intensity_f_r./meanBaseline_f);


%          window = 2;
%          intensity_f = squeeze(stack_f(i,j,:));
%          meanIntensity_f = movmean(intensity_f, window);
%          intensity_f = -1*(intensity_f - meanIntensity_f);

        % Backward
%         intensity_b_r = squeeze(stack_b(i,j,:));
%         meanBaseline_b = bslne_3(i,j);
%         intensity_b = log10(intensity_b_r./meanBaseline_b);%intensity_b_r - meanBaseline_b;%-log10(intensity_b_r./meanBaseline_b);
%         
        % New methods
%         time_R = (timeStamps_1 - timeStamps_1(1))/1000;
%         time_Transf = time_R./period_1*2*pi;
%         time_Transf_Im = exp(1i*time_Transf);
%         prod = time_Transf_Im.*intensity_f';
%         prod_mean = mean(prod);
        
        % New methods backward
%         time_R_b = (timeStamps_3 - timeStamps_3(1))/1000;
%         time_Transf_b = time_R_b./period_3*2*pi;
%         time_Transf_Im_b = exp(1i*time_Transf_b);
%         prod_mean_b = mean(time_Transf_Im_b.*intensity_b');
        
        % FFT
      [index_f, sh1_R_f,len_1_f] = transformFourier(intensity_f, Fs_3, inputFreq_3);
      %[index_b, sh1_R_b,len_1_b] = transformFourier(intensity_b, Fs_3, inputFreq_3);
        
        % Plotting
       map_1(i,j) = angle(sh1_R_f(max(index_f))); %sh1_R_b(min(index_b));
       %map_2(i,j) = abs(prod_mean_b)*1000000;

                                                                                                                                                                                                                                                      
        

    end
end

% Map
% figure; 
% imagesc(map_1); colorbar; colormap jet; %caxis([-50 50])
figure; 
imagesc((rad2deg(map_1)*206/360)+44); colorbar; colormap jet;


%% Low pass image
boxKernel = ones(21,21); % Or whatever size window you want.
blurredImage = conv2(map_1, boxKernel, 'same');
figure; imagesc(blurredImage); colormap hot %colorbar; 
title('Absolute map');
%% Smoothed image
figure; 
filt_L = fourierLowF(map_1,0.1);
filt_L = filt_L - min(min(filt_L))-0;
norm_L = filt_L.*(1/(max(max(filt_L))-min(min(filt_L))));
imagesc(norm_L); colorbar; 

%% Determine window size
intensity_f_r = squeeze(stack_f(138,165,:));
x = 1:length(intensity_f_r);
windowSize = 1:1:100;

for k = 1:length(windowSize)
    smoothSignal = movmean(intensity_f_r,windowSize(k));
    sad(k) = sum(abs(smoothSignal - intensity_f_r));
end
figure;
plot(windowSize, sad, 'b*-', 'LineWidth', 2);
title 'Pick smallest size where SAD seems to flatten out'
grid on;
xlabel('Window Size')
ylabel('SAD')
figure; plot(x, intensity_f_r, x, meanIntensity_f); axis tight
%% Mixing trials stocks
% forward 
for j = 1:1041
    j
    tmp_1 = resizeImage_f_3(:,:,j);
    tmp_2 = resizeImage_f_4(:,:,j);
    Backw(:,:,j) = (tmp_1+tmp_2)/2;
end

%% 
figure;
t = 0:1/1024:1;
x = sin(2*pi*60*t);
y = hilbert(x);

plot(t(1:50),real(y(1:50)))
hold on
%plot(t(1:50),imag(y(1:50)))
plot(t(1:50),x(1:50))
legend('Real Part','Original')



