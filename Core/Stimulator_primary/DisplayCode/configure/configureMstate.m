function configureMstate(secondaryIP)

global Mstate

Mstate.anim = 'xx0';
Mstate.unit = '000';
Mstate.expt = '000';

Mstate.hemi = 'left';
Mstate.screenDist = 25;

Mstate.monitor = 'LIN';  %This should match the default value in Display

updateMonitorValues

Mstate.syncSize = 2; %Armel changed this from value 4 
                       %Size of the screen sync in cm

Mstate.running = 0;

%Mstate.analyzerRoot = ['C:\VStimFiles\AnalyzerFiles' ' ; ' '\\ACQUISITION\neurostuff\AnalyzerFiles'];
Mstate.analyzerRoot = 'C:\neurodata\AnalyzerFiles_new';
%Mstate.analyzerRoot = 'Y:\haider\Data\ISI\Animal_Testing';

%Mstate.stimulusIDP = '143.215.230.184';  %Neighbor (ISI computer)
Mstate.stimulusIDP = secondaryIP; %ip address of secondary at dev rig;

