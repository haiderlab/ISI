function run2
global GUIhandles Pstate Mstate trialno syncInfo analogIN

if Mstate.running %otherwise 'getnotrials' won't be defined for play sample
    nt = getnotrials;
end

ScanImageBit = GUIhandles.main.twophotonflag;  
ISIbit =  GUIhandles.main.intrinsicflag;
if Mstate.running && trialno<=nt  %'trialno<nt' may be redundant.
    try
        set(GUIhandles.main.showTrial,'string',['Trial ' num2str(trialno) ' of ' num2str(nt)] ), drawnow
    catch
        fprintf('Matrox Board... \n')
    end
    [c r] = getcondrep(trialno);  %get cond and rep for this trialno
    buildStimulus(c,trialno)    %Tell stimulus to buffer the images (also controls shutter)
    waitforDisplayResp   %Wait for serial port to respond from display
    startStimulus      
    %Tell Display to show its buffered images. 
    %TTL from stimulus computer "feeds back" to trigger 2ph acquisition
    if ISIbit
        sendtoImager(sprintf(['S %d' 13],trialno-1))  
        %Matlab now enters the frame grabbing loop 
    end
    trialno = trialno+1;
    
    if ISIbit
       run2  %Nothing should happen after this
    end  
else
    
end


