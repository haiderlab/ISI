function Stimulator

%Set paths of new version
% path('C:\Stimulator_master\COM_display',path)
% path('C:\Stimulator_master\COM_acquisition',path)
% path('C:\Stimulator_master\DisplayCode',path)
% path('C:\Stimulator_master\GUIs',path)

%Initialize stimulus parameter structures
configurePstate('PG')
configureMstate
configureLstate

%Host-Host communication
configDisplayCom    %stimulus computer

%configEyeShutter

%Open GUIs
MainWindow
Looper 
paramSelect