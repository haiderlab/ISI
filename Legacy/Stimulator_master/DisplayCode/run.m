function run

global GUIhandles ACQserial Pstate Mstate

nt = getnotrials;



%%%%Send initial parameters to display
sendPinfo
waitforDisplayResp
sendMinfo
waitforDisplayResp
%%%%%%%%%%%%%%%%%%%%%%%%%%

ScanImageBit = get(GUIhandles.main.twophotonflag,'value');  %Flag for the link with scanimage

%%%Get the Acquisition ready:
if ScanImageBit
    prepACQ
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i = 0;
%%%Real-time loop...
while Mstate.running && i<nt

    i = i + 1;

    set(GUIhandles.main.showTrial,'string',['Trial ' num2str(i) ' of ' num2str(nt)] ), drawnow

    [c r] = getcondrep(i);  %get cond and rep for this trialno

    %%%Update ScanImage with Trial/Cond/Rep
    if ScanImageBit  %This gets sent before trial starts
        updateACQtrial(i)
    end
    %%%%%%%%%%%%%%%

    %%%Organization of commands is important for timing in this part of loop
'a'
    buildStimulus(c,i)    %Tell stimulus to buffer the images
    waitforDisplayResp   %Wait for serial port to respond from display

    startStimulus      %Tell Display to show its buffered images. TTL from stimulus computer will trigger acquisition
'b'
    if ScanImageBit
        waitforACQ          %Wait for acquisition to finish writing to disc
    else
        waitforDisplayResp   %Wait for serial port to respond from display at end of trial
    end
'c'
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end

%Before, I had this in the 'mainwindow callback routine, which messed
%things up on occasion.
%This is executed at the end of experiment and when abort button is hit
if get(GUIhandles.main.twophotonflag,'value');
    fwrite(ACQserial.serialPortHandle,['abort' '!']); %Tell ScanImage to hit 'abort' button
end
