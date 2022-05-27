function startStimulus

global DcomState

mod = getmoduleID;

msg = ['G;' mod ';~'];

fwrite(DcomState.serialPortHandle,msg);

