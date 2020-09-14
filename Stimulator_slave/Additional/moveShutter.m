function moveShutter(eye,pos)

global daq shutterState

shutterState=bitset(shutterState,eye,1-pos);

disp(shutterState)

DaqDOut(daq, 1, shutterState);