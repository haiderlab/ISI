function moveShutter(eye,pos)

global DcomState

msg=['S;' num2str(eye) ';' num2str(pos) ';~'];

fwrite(DcomState.serialPortHandle,msg);
    