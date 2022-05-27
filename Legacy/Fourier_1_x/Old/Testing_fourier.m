% Testing fourier and reverse
clear all
clc
Fs = 1000; 
Ts = 1/Fs; 
dt = 0:Ts:2-Ts; 
f1 = 10; 
f2 = 30; 
f3 = 70;
A = 10; 
y1 = A*sin(2*pi*f1*dt);
y2 = A*sin(2*pi*f2*dt);
y3 = A*sin(2*pi*f3*dt);
y4 = y1 + y2 + y3

%% Fourier using coefficient  
reconS = zeros(size(y4));
pnts = length(dt);
fourTime = (0:pnts - 1)/pnts;
fCoefs = zeros(size(y4));
% Forward Fourier 
 for fi = 1:pnts;
     csw = exp( -1i*2*pi*(fi-1)*fourTime);
     fCoefs(fi) = sum(y4.*csw);
 end
% Extract Amplitude 
ampls = abs(fCoefs)/pnts;
ampls(2:end) = 2*ampls(2:end);
% Frequency vector
hz = linspace(0,Fs/2, floor(pnts/2)+1);
fourierSignal = ampls(1:length(hz));

%% Applied Low pass filter 
cut_Off_Frequency_Raw = 10; %B/c we're trying to retain y1
cut_Off_Frequency_Normalized = 15/(Fs/2); % Fs/2 is the nyquist freq.
order = 128; % Increasing the order makes the filter smoother & better
h = fir1(order,cut_Off_Frequency_Normalized);
fh = fft(h,pnts); % Transform LPF from time -> frequency

%mul = fh.*fourierSignal;
%plot(hz,abs(mul));

% Reverse Fourier 
%fCoefs= fh.*sum(y4.*csw);
for fi = 1:pnts;
    csw = fCoefs(fi) * exp(1i*2*pi*(fi-1)*fourTime);
    reconS = reconS + csw;
end 
% Must divide by N
reconS = fh.*(reconS /pnts)
% plot 

subplot(2,1,1);
plot(dt,y1,'b');
subplot(2,1,2);
plot(dt,abs(reconS),'r');





