% Example of adding a filter to remove artifacts
%% Raw
Fs = 1000; % Example of sampling frequency
Ts = 1/Fs; % Example of sampling period or time step
dt = 0:Ts:2-Ts; % Signal direction
f1 = 10; % Frequency of signal 1 units = Hz --> Oscillatins/sec
f2 = 30; % Frequency of signal 2 units = Hz
f3 = 70; % --------------------3------------

% Let's create 3 different sinusoidal signals 
% General Math Form: y = A sin(2*pi*f*t + theta)
% theta is the first shit
% Let's assume that theta is 0
% The three signals are:
A = 10; 

y1 = A*sin(2*pi*f1*dt);
y2 = A*sin(2*pi*f2*dt);
y3 = A*sin(2*pi*f3*dt);
 
% Plot of first sinusoidal
% subplot(3,1,1);
% plot(dt, y1, 'r');

% Plot of second sinusoidal
% subplot(3,1,2);
% plot(dt, y2, 'b');

% Plot of second sinusoidal
% subplot(3,1,3);
% plot(dt, y3, 'g');

%% Adding mix of signals

y4 = y1 + y2 + y3 
% plot(dt, y4);

% Applying Fast Fourier Transfor to identify different frequencies in mix

nfft = length(y4); % length of time domain signal 
nfft2 = 2.^nextpow2(nfft); % Do this b/c to get good signal length = Power of 2

% Fourier transfor
% This operation gives us the complex numbers
% Gives Magnetude & Phase of signal
ff = fft(y4,nfft2);
% Sequestering & plotting one side (left) of the mirror plot
ffL = ff(1:nfft2/2);

% Getting frequency values on X- axis
xfft = Fs * (0:nfft2/2 -1)/nfft2;

% Time domain signal transform Before Transform
subplot(3,1,1);
plot(dt, y4);
xlabel('Time [s]');
ylabel('Amplitude [V]');
title('Time Domain signal B.')
% Frequency domain signal  
subplot(3,1,2);
plot(xfft, abs(ffL));
xlabel('Frequency [Hz]');
ylabel('Normalized Amplitude [V]');
title('Frequency Domain signal')













