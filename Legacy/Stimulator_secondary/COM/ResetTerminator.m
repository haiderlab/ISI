
function ResetTerminator

global comState

fclose(comState.serialPortHandle)
comState.serialPortHandle.BytesAvailableFcnMode = 'Terminator';
fopen(comState.serialPortHandle)