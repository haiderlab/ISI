function sendMonitor(str)

global Mstate DcomState

%This updates the gamma table and screen size at the display.

msg = ['MON;' Mstate.monitor ';~'];

fwrite(DcomState.serialPortHandle,msg);
