%% Run this on Slave computer

addpath(genpath('Stimulator_slave'))
%%
Screen('Preference','SkipSyncTests',1);
masterIP = '143.215.230.195';
configureDisplay(masterIP);