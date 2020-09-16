% Power spectrum for one pixel
st = pixel_values_array2;
pile_fft = {};
Fs = Fs_mode; 

for ii = 1: length(st)
    pile_fft{ii,1} = mell_spec(st{ii},Fs);
end
blah = cell2mat(pile_fft);

avg = nanmean(blah);
%avg = blah;
L = length(st{1});
f = Fs*(0:(L/2))/L;
%avg = lowpass(avg,0.5,Fs); 
figure;
plot(f,avg) 
title('Single-Sided Amplitude Spectrum of X(t)')
xlabel('f (Hz)')
ylabel('|P1(f)|')
%ylim([0.03 1])
grid on
hold on
plot([0.1,0.1],[-6,6],'r--')
%set(gca, 'YScale', 'log')
set(gca, 'XScale', 'log')

%% New Methods
[period_f,inputFreq_f,resizeImage_f,Fs_f, timeStamps_f,bslne_f,barsON_f,tt_f] = resizingImage(ims_f,timevecReal_f,1,timeStim_f,timeStimReal_f);
stack_f = resizeImage_f;
rsp = [];
%%
x_values = 289;
y_values = 433;
for i = y_values(1):y_values(end)
    i
    for j = x_values(1):x_values(end)
        % Forward
        intensity_f_r = squeeze(stack_f(i,j,:));
        [index_f, sh1_R_f,len_1_f] = transformFourier(intensity_f_r, Fs_f, inputFreq_f);
    end
end

Arsp = nanmean(rsp,2);
%figure; plot(len_1_f(3:end),abs(sh1_R_f(3:end)),'k','LineWidth',2)
tiMe = timeStamps_f - timeStamps_f(1);
figure; plot(tiMe/1000,intensity_f_r,'k','LineWidth',2)
title 'Time domain pixel inside ROI'
ylabel 'Reflectance'
xlabel 'Time (Seconds)'

%set(gca, 'YScale', 'log')






















