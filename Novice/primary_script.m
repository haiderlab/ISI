%% Run this on Primary computer
addpath(genpath('Stimulator_primary'))
addpath(genpath('More'))
addpath(genpath('New_Imager'))
addpath(genpath('General_Testing_Material'))

%%
clear all; close all
global inputM cameraInterface secondaryIP;
 
% Camera interface settings
cameraInterface.useExecutable = true; %true if using executable to grab frames
cameraInterface.exePath = 'C:\Users\haider-lab\Documents\MATLAB\ISI\Core\New_Imager\MdigProcess\vs2012\x64\Release\MDigProcess.exe'; %changed Debug to Release
cameraInterface.tempStoragePath = 'C:/Users/haider-lab/Downloads/frames/'; %use local SSD for better performance
cameraInterface.frameDimensions = [4090 3072]; %[width height] in pixels

% Data output definitions
inputM.mouseID = 'Mouse_test_M210712_1';
inputM.date = '08_10';
inputM.analyzerRoot = 'Y:\haider\Data\ISI\Animal_Testing';
inputM.ses = '1';

secondaryIP = '143.215.230.184'; % secondaryIP of surgery room

global lightval
lightval = 'INT0=4000';
modlight = Adjust_Light;
waitfor(modlight);
imagerGUI = Imager;
