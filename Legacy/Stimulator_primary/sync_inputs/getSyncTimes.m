function [dispSynctimes acqSynctimes dsyncwave] = getSyncTimes

global analogIN syncs

samples = get(analogIN,'ScansAcquired');
Fs = get(analogIN,'Rate');
syncs = getdata(analogIN,samples);

figure(69), plot(syncs(1:5:end,1))

dispSynctimes = processLCDSyncs(syncs(:,1),Fs); %First channel should be from display
%dispSynctimes = processDaqSyncs(syncs(:,1),Fs); %First channel should be from display
acqSynctimes = processGrabSyncs(syncs(:,2),Fs); %Second channel should be from parallel port

dsyncwave = syncs(:,1);

flushdata(analogIN);