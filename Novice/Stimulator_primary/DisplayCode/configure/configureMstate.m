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
Mstate.running = 0;
Mstate.analyzerRoot = 'C:\neurodata\AnalyzerFiles_new';
Mstate.stimulusIDP = secondaryIP; %ip address of secondary at dev rig;

