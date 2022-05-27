%% Filtering all elements 
clear all
clc
Fs = 1000; % Example of sampling frequency
Ts = 1/Fs; % Example of sampling period or time step
dt = 0:Ts:2-Ts; % Signal direction
f1 = 10; % Frequency of signal 1 units = Hz --> Oscillatins/sec
f2 = 30; % Frequency of signal 2 units = Hz
f3 = 70; % --------------------3------------
A = 10; % Amplitude can be different
y1 = A*sin(2*pi*f1*dt);
y2 = A*sin(2*pi*f2*dt);
y3 = A*sin(2*pi*f3*dt);
y4 = y1 + y2 + y3

%% Getting the Frequency domain
nfft = length(y4); % length of Mix signal 
nfft2 = 2.^nextpow2(nfft); % Power 2 of length of Mix signal
ff = fft(y4,nfft2); % Fourier transform applied on mix
ffL = ff(1:nfft2/2); % Only left miror retrieved 
xfft = Fs * (0:nfft2/2 -1)/nfft2; % Gives frequency on x-axis 
% Plots
%plot(xfft, abs(ffL/max(ffL))); % Note that we normalized ffL

%% Designing the low pass filter
% Note that the filter is time domain & not freq.
cut_Off_Frequency_Raw = 10; %B/c we're trying to retain y1
cut_Off_Frequency_Normalized = 15/(Fs/2); % Fs/2 is the nyquist freq.
order = 128; % Increasing the order makes the filter smoother & better
h = fir1(order,cut_Off_Frequency_Normalized);

%% Filtered using time domain [function: con(x,y)
con = conv(y4, h);
%plot(con);


%% Filter using frequency domain [freq. filterd * freq. Mix]
fh = fft(h,nfft2); % Transform LPF from time -> frequency
fhL = fh(1:nfft2/2); % only retain left side of mirror
mul = fhL.*ffL; % Multiply left Frequency filter with Left freq. mix signal
%subplot(2,1,1);
plot(xfft, real(mul/max(mul))); % This gives you the frequency of Y1
                               % I normalized it to max to check & it's
                               % right
                               % Note that if you put abs instead of real, it only gives
                               % upper parts
% Let's try to reverse from fr




