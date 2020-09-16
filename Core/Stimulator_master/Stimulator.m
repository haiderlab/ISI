function Stimulator(slaveIP)

global FrameRate
%Initialize stimulus parameter structures
configurePstate('PG')
configureMstate(slaveIP);
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