function Stimulator(secondaryIP)

global FrameRate
%Initialize stimulus parameter structures
configurePstate('PG')
configureMstate(secondaryIP);
configureLstate

%Host-Host communication
configDisplayCom    %stimulus computer
FrameRate = input('Enter frame rate: ');
configSyncInput

% configEyeShutter

%Open GUIs
MainWindow
Looper
paramSelect