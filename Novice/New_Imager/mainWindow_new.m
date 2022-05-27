function mainWindow_new

global GUIhandles Mstate shutterState

handles = {};
Mstate.running = 0;
%Set GUI to the default established in configureMstate
handles.screendistance = num2str(Mstate.screenDist);
handles.analyzerRoots = Mstate.analyzerRoot;
handles.animal = Mstate.anim;
handles.unitcb = Mstate.unit;
handles.exptcb = Mstate.expt;
handles.hemisphere = Mstate.hemi;
handles.screendistance = Mstate.screenDist;
handles.monitor = Mstate.monitor;
handles.stimulusIDP = Mstate.stimulusIDP;
handles.intrinsicflag = 1;
handles.twophotonflag = 0;
handles.analysisFlag = 0;
handles.runbutton = 'Run';
handles.showTrial = [];
handles.streamFlag = 1;

GUIhandles.main = handles;

% When we click Run 
global Mstate GUIhandles Pstate trialno analogIN inputM

if ~Mstate.running
    %Check if this analyzer file already exists!
    roots = parseString(Mstate.analyzerRoot,';');
    for i = 1:length(roots)  %loop through each root
        title = [Mstate.anim '_' sprintf('u%s',Mstate.unit) '_' Mstate.expt];
        dd = [roots{i} '\' Mstate.anim '\' title '.analyzer'];
    end
    
    
    global inputM; %DS modified, saving directory.
    if ~exist([inputM.analyzerRoot '\' inputM.mouseID],'dir')
        mkdir([inputM.analyzerRoot '\' inputM.mouseID]);
    end
    if ~exist([inputM.analyzerRoot '\' inputM.mouseID '\' inputM.date],'dir')
        mkdir([inputM.analyzerRoot '\' inputM.mouseID '\' inputM.date]);
    end
    
    fname = [inputM.analyzerRoot '\' inputM.mouseID '\' inputM.date '\' num2str(inputM.ses)];
    
    while exist(fname,'dir')
        inputM.ses = num2str(str2num(inputM.ses) + 1);
        disp(['Directory ' inputM.ses ' exists']);
        fname = [inputM.analyzerRoot '\' inputM.mouseID '\' inputM.date '\' num2str(inputM.ses)];
    end
    if ~exist(fname,'dir')
        mkdir(fname);
    end
    
    
    
    %Check if this data file already exists!
    if GUIhandles.main.intrinsicflag
        
        [Oflag dd] = checkforOverwrite;
        if Oflag
            return
        else
            dd
            [status,msg,ID]=mkdir(dd);
        end
    end
    
    Mstate.running = 1;  %Global flag for interrupt in real-time loop ('Abort')
    
    %Update states just in case user has not pressed enter after inputing
    %fields:
    updateLstate
    updateMstate
    
    makeLoop;  %makes 'looperInfo'.  This must be done before saving the analyzer file.
    saveExptParams  %Save .analyzer. Do this before running... in case something crashes
    %set(handles.runbutton,'string','Abort')
    
    %%%%Send initial parameters to display
    sendPinfo
    waitforDisplayResp
    sendMinfo
    waitforDisplayResp
    %%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%%Get the 2photon Acquisition ready:
    if GUIhandles.main.twophotonflag %get(GUIhandles.main.twophotonflag,'value')  %Flag for the link with scanimage
        prepACQ
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%%Send inital parameters to ISI imager GUI
    P = getParamStruct;
    if GUIhandles.main.intrinsicflag
        total_time = P.predelay+P.postdelay+P.stim_time;
        GUIhandles.main.timetxt = total_time;
        sendtoImager(sprintf(['I %2.3f' 13],total_time))
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    trialno = 1;
    % Save Files new
    run2
    
else
    Mstate.running = 0;  %Global flag for interrupt in real-time loop ('Abort')
    %set(handles.runbutton,'string','Run')
end


end
