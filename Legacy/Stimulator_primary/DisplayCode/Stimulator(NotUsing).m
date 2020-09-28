function Stimulator

%Set paths of new version
% path('C:\Stimulator_primary\COM_display',path)
% path('C:\Stimulator_primary\COM_acquisition',path)
% path('C:\Stimulator_primary\DisplayCode',path)
% path('C:\Stimulator_primary\GUIs',path)

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