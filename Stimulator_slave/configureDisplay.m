function configureDisplay(masterIP)

close all

%clear all;
Screen('Preference', 'SkipSyncTests', 1);
Priority(1);  %Make sure priority is set to "real-time"  

% priorityLevel=MaxPriority(w);
% Priority(priorityLevel);

configurePstate('PG') %Use grater as the default when opening
configureMstate

configCom(masterIP);

configSync;

% Make sure to uncomment the shutter once daq is connected
%configShutter; 

screenconfig;

