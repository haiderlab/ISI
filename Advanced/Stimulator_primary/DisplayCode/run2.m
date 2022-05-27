function run2

global GUIhandles Pstate Mstate trialno syncInfo analogIN

if Mstate.running %otherwise 'getnotrials' won't be defined for play sample
    nt = getnotrials;
end

ScanImageBit = get(GUIhandles.main.twophotonflag,'value');  %Flag for the link with scanimage
ISIbit =  get(GUIhandles.main.intrinsicflag,'Value');
%Commented By Alan
%Behaviorbit =  get(GUIhandles.main.mouseBehavior,'value');

if Mstate.running && trialno<=nt  %'trialno<nt' may be redundant.
    
    set(GUIhandles.main.showTrial,'string',['Trial ' num2str(trialno) ' of ' num2str(nt)] ), drawnow

    [c r] = getcondrep(trialno);  %get cond and rep for this trialno

    if ISIbit
        % Armel commented below
        %analogIN.startForeground();  %Start sampling acquistion and stimulus syncs
    end
    
    %%%Update ScanImage with Trial/Cond/Rep
    if ScanImageBit  %This gets sent before trial starts
        updateACQtrial(trialno)
    end
    %%%%%%%%%%%%%%%
    %Alan commented
%     if Behaviorbit
%        
%         %Send stuff to Arduino
%         %Wait for Arduino to say it received instructions                                                                                  
%     end

    %%%Organization of commands is important for timing in this part of loop
   
    buildStimulus(c,trialno)    %Tell stimulus to buffer the images (also controls shutter)
    waitforDisplayResp   %Wait for serial port to respond from display

    startStimulus      %Tell Display to show its buffered images. TTL from stimulus computer "feeds back" to trigger 2ph acquisition
    
    %In 2ph mode, we don't want anything significant to happen after startStimulus, so that
    %scanimage will be ready to accept TTL
    
    
    if ISIbit
        sendtoImager(sprintf(['S %d' 13],trialno-1))  %Matlab now enters the frame grabbing loop (I will also save it to disk)
        
        %%%Timing is not crucial for this last portion of the loop (both display and frame grabber/saving is inactive)...
        
        % Armel commented below
        %stop(analogIN)  %Stop sampling acquistion and stimulus syncs
        
        % Armel commented below
%         [syncInfo.dispSyncs syncInfo.acqSyncs syncInfo.dSyncswave] = getSyncTimes;   
%         syncInfo.dSyncswave = [];  %Just empty it for now
%         saveSyncInfo(syncInfo)  %append .analyzer file
        


        %[looperInfo.conds{c}.repeats{r}.dispSyncs looperInfo.conds{c}.repeats{r}.acqSyncs looperInfo.conds{c}.repeats{r}.dSyncswave] = getSyncTimes;
        
        onlineAnalysis(c,r,syncInfo)     %Compute F1

        
    end
    
   % Armel commented below 
%    if Behaviorbit
       
        %Get stuff from Arduino - Can make it wait for matlab to signal it
        %is ready to receive data, then send to matlab
        %Append analyzer file - should put raw up/down here
        
%    end
   
    trialno = trialno+1;
    
    %This would otherwise get called by Displaycb 
    if ISIbit
        run2  %Nothing should happen after this
    end
        
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
else
    
    %Before, I had this in the 'mainwindow callback routine, which messed
    %things up on occasion.
    %This is executed at the end of experiment and when abort button is hit
    if get(GUIhandles.main.twophotonflag,'value');
        Stimulus_localCallback('abort'); %Tell ScanImage to hit 'abort' button
    end
    
    %set(GUIhandles.param.playSample,'enable','off')
    
    Mstate.running = 0;
    set(GUIhandles.main.runbutton,'string','Run')
    
    if get(GUIhandles.main.intrinsicflag,'value')
        %set(GUIhandles.param.playSample,'enable','off')
        saveOnlineAnalysis
    end

end


