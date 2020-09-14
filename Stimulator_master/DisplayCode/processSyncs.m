function synctimes = processSyncs(syncwave,Fs)

%Produces a vector corresponding to the rising edge times of syncwave

syncwaveF = fft(syncwave-mean(syncwave));
fdom = linspace(0,Fs,length(syncwave)+1);
fdom = fdom(1:end-1);

%We know that the monitor noise will be > 60.  But making it 60 is still
%not the important thing.  This is important because some stimuli produce
%lower frequency harmonics with energy greater than what we are trying to get rid of. 
[dum id60] = min(abs(fdom-60));
[dum id] = max(abs(syncwaveF(id60:end/2)));
id = id+id60-1;  %location 
%%%%%

noiseF0 = fdom(id);  %flicker frequency
W = round(Fs/noiseF0);  %Width of the box car in time-domain

H = zeros(1,length(syncwave));
H(1:W) = 1/W;
H = abs(fft(H'));
H = H.^2;

syncwave = ifft(fft(syncwave).*H);
high = prctile(syncwave,98);
low = prctile(syncwave,2);
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

