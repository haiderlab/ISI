%% Run this on Secondary computer
addpath(genpath('Stimulator_secondary'))

%%
Screen('Preference','SkipSyncTests',1);
primaryIP = '143.215.230.195';
configureDisplay(primaryIP);