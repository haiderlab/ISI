%% Applying Low Pass Filter and gaining desired filter 
Fs = 1000; % Example of sampling frequency
Ts = 1/Fs; % Example of sampling period or time step
dt = 0:Ts:2-Ts; % Signal direction
f1 = 10; % Frequency of signal 1 units = Hz --> Oscillatins/sec
f2 = 30; % Frequency of signal 2 units = Hz
f3 = 70;

A = 10; % Amplitude can be different 

y1 = A*sin(2*pi*f1*dt);
y2 = A*sin(2*pi*f2*dt);
y3 = A*sin(2*pi*f3*dt);
y4 = y1 + y2 + y3 

nfft = length(y4); % length of time domain signal 
nfft2 = 2.^nextpow2(nfft);
% Gives Magnetude & Phase of signal
ff = fft(y4,nfft2);
% Sequestering & plotting positive side (left) of the mirror plot
ffL = ff(1:nfft2/2); % This is complex number 
                     % If you want to plot it you need to plot abs val.
                     % By doing abs(ffL) | See below & Diagram
% Assigning frequency values on X- axis
xfft = Fs * (0:nfft2/2 -1)/nfft2;

% Plots
% Time 
% subplot(3,1,1);
% plot(dt, y4);
% Frequency
% subplot(3,1,2);
% plot(xfft, abs(ffL));
% Frequency normalized with max
% subplot(3,1,3)
% plot(xfft, abs(ffL/max(ffL)));


%% Designing the Low Pass Filter 
% First, we need to specify a cut off value 
cut_Off_Frequency_Raw = 15; % This is done by doing f1< 15 <f2 <f3
                             % Allowing us to retain f1
                             
cut_Off_Frequency_Normalized = 15/(Fs/2); % Fs/2 is the nyquist freq.

% order 
% Increasing order makes filter convolution smoother
order = 64;
% Assigning order & cut-off frequency
h = fir1(order,cut_Off_Frequency_Normalized);
% Convolution
con = conv(y4, h);
% plot(con)

% Transform Low pass filter from Time to Frequency domain
fh = fft(h,nfft2)
% Taking only the left (positive) part
fhL = fh(1:nfft2/2);

% Multiply impulse by original freq. signal --> filter
mul = fhL.*ffL; % Gives you a complex number
% plot(abs(mul))

%% Plotting Noisy, Impulse, & Filtering sign.
% Finding the filter using frequency domain

% Noisy (raw)
% subplot(3,1,1);
% plot(xfft, abs(ffL/max(ffL)));
% title('Noise')
% Impulse response for low pass filter signal
% subplot(3,1,2);
% plot(xfft, abs(fhL/max(fhL)));
% title('Impulse Response')
% Filter
% subplot(3,1,3);
% plot(abs(mul))
% title('Filtered')

%% Plotting data 
% Finding the filter using convolution technique in time domain

% subplot(2,1,1)
% plot(dt, y1, 'r');
% subplot(2,1,2)
% plot(con, 'g')
% title('Filtered')

%% Try to find y1

subplot(5,1,1);
plot(dt, y4, 'b');
title('mix');

subplot(5,1,2);
plot(dt, y1, 'r');
title('Y1')

subplot(5,1,3);
plot(dt, y2, 'b');
title('Y2')

subplot(5,1,4);
plot(dt, y3, 'g');
title('Y3')

subplot(5,1,5)
plot(con, 'g')
title('Filtered')


