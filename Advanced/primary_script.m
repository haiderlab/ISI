%% Run this on Primary computer
addpath(genpath('Stimulator_primary'))
addpath(genpath('More'))
addpath(genpath('New_Imager'))
addpath(genpath('General_Testing_Material'))

%%
global inputM cameraInterface;

% Camera interface settings
cameraInterface.useExecutable = true; %true if using executable to grab frames
cameraInterface.exePath = 'C:\Users\haider-lab\Documents\MATLAB\ISI\Core\New_Imager\MdigProcess\vs2012\x64\Release\MDigProcess.exe'; %changed Debug to Release
cameraInterface.tempStoragePath = 'C:/Users/haider-lab/Downloads/frames/'; %use local SSD for better performance
cameraInterface.frameDimensions = [4090 3072]; %[width height] in pixels

% Data output definitions
inputM.mouseID = 'shea_test';
inputM.date = '06_17';
inputM.analyzerRoot = 'Y:\haider\Data\ISI\Animal_Testing';
inputM.ses = '3';


secondaryIP = '143.215.230.184'; % secondaryIP of surgery room

global lightval
lightval = 'INT0=4000';
modlight = Adjust_Light;
waitfor(modlight);

imagerGUI = Imager;
waitfor(imagerGUI);

%%
Stimulator(secondaryIP);