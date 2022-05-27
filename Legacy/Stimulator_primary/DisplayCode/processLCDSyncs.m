function synctimes = processLCDSyncs(syncwave,Fs)

%Produces a vector corresponding to the rising edge times of syncwave

syncwaveF = fft(syncwave-mean(syncwave));
fdom = linspace(0,Fs,length(syncwave)+1);
fdom = fdom(1:end-1);
[dum id] = max(syncwaveF(1:end/2));
noiseF0 = fdom(id);
W = round(Fs/noiseF0);

H = zeros(1,length(syncwave));
H(1:W) = 1/W;
H = abs(fft(H'));
H = H.^2;

syncwave = ifft(fft(syncwave).*H);
high = prctile(syncwave,99.99);
low = prctile(syncwave,40);
thresh = (high+low)/2;

%%%
%thresh = 0.2;
%%%
syncwave = sign(syncwave-thresh);
id = find(syncwave == 0);
syncwave(id) = 1;

syncwave = diff((syncwave+1)/2);

synctimes = find(syncwave == 1) + 1;
synctimes = synctimes/Fs;

clear syncwave

