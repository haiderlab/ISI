
function ResetTerminator

global DcomState

fclose(DcomState.serialPortHandle)
DcomState.serialPortHandle.BytesAvailableFcnMode = 'Terminator';
fopen(DcomState.serialPortHandle)