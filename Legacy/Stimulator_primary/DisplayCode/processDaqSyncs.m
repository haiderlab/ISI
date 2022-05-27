function synctimes = processDaqSyncs(syncwave,Fs)

%This is a modified version of processLCDsyncs.  I now use the daq to
%output digital pulses from the stimulus computer.

%Produces a vector corresponding to the rising edge times of syncwave

high = max(syncwave);
low = min(syncwave);
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

