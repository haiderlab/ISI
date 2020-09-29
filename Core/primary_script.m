%% Run this on Primary computer
addpath(genpath('Stimulator_primary'))
addpath(genpath('More'))
addpath(genpath('New_Imager'))
addpath(genpath('General_Testing_Material'))

%%
global inputM;
inputM.mouseID = 'Mouse_12_M200707_1';
inputM.date = '08_25';
inputM.analyzerRoot = '\\neuro-cloud\labs\haider\Data\ISI\Animal_Testing';
inputM.ses = '4';
%inputM.ses = num2str(str2num(inputM.ses) + 1)

secondaryIP = '143.215.230.184'; % secondaryIP of surgery room

global lightval
lightval = 'INT0=4000';
modlight = Adjust_Light;
waitfor(modlight);

imagerGUI = Imager;
waitfor(imagerGUI);

%%
Stimulator(secondaryIP);