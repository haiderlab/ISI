function P1 = mell_spec(signal,f)
%signal = pixel_values_array{1};

% Sampling Frequency
% timeAdjustedDiff = diff(timevecReal)/1000;
% Fs = 1 ./ mean(timeAdjustedDiff);
Fs = f;
% Time 
%t = timevecReal;
% Sampling of period
T = 1/Fs;
%signal = lowpass(signal,0.5,Fs); 
L = length(signal);
% Fourier transform of signal
Y = fft(signal);
% Compute the two-sided spectrum P2. Then compute the single-sided spectrum
% P1 based on P2 and the even-valued signal length L.
%P2 = abs(Y/L);
P2 = angle(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
% Define the frequency domain f and plot the single-sided amplitude spectrum P1.

% f = Fs*(0:(L/2))/L;
% plot(f,P1) 
% title('Single-Sided Amplitude Spectrum of X(t)')
% xlabel('f (Hz)')
% ylabel('|P1(f)|')
% ylim([0 0.2])
% grid on
% % set(gca, 'YScale', 'log')
% set(gca, 'XScale', 'log')
% hold on
% plot([0.2,0.2],[0,0.2],'r--')
end


% xlim([0 10])
% xlim([10^-2 10])










% % Computation 
% N = length(signal);
% xdft = fft(signal);
% xdft = xdft(1:N/2+1);
% psdx = (1/(Fs*N)) *abs(xdft).^2;
% psdx(2:end -1) = 2*psdx(2:end-1);
% freq = 0:Fs/length(signal):Fs/2;
% figure;
% plot(freq, 10*log10(psdx))
% grid on 
% title('Periodogram using FFT')
% xlabel('Frequency (Hz)')
% ylabel('Power/Frequency (dB/Hz)')
% 
% 
% 
% 
% nfft = 2^nextpow2(length(signal));
% Pxx = abs(fft(signal,nfft)).^2/length(signal)/Fs;
% Hpsd = dspdata.psd(Pxx(1:length(Pxx)/2),'Fs',Fs);  
% figure;
% plot(Hpsd)










% %Fs = 10;
% % figure;
% % hold on 
% % plot(intensity_1,'r-')
% % %plot(timevec,intensity_2,'g-')
% % xlabel('Time [sec]');
% % ylabel('Amplitude [V]');
% % title("Time course of Light reflectance");
% 
% % Fourier Transform
% ff1 = fft(intensity_1);
% l_1 = length(ff1);
% f_1 = (-l_1/2:l_1/2-1)/l_1*Fs;
% 
% % Sequestering & plotting one side (right) of the mirror plot
% sh1 = fftshift(ff1);
% sh1_R = sh1(length(sh1)/2: end);  
% len_1 = f_1(length(f_1)/2: end);
% 
% % Plot of Frenquency 
% % I'm only showing (2:end) for better representation
% figure;
% hold on
% %stem(len_1(2:end) ,abs(sh1_R(2:end)),'r-')
% plot(len_1(2:end) ,abs(sh1_R(2:end)),'r-')
% xlabel 'Frequency (Hz)'
% ylabel '|y|'
% grid