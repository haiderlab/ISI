function varargout = MainWindow(varargin)
% MAINWINDOW M-file for MainWindow.fig
%      MAINWINDOW, by itself, creates a new MAINWINDOW or raises the existing
%      singleton*.
%
%      H = MAINWINDOW returns the handle to a new MAINWINDOW or the handle to
%      the existing singleton*.
%
%      MAINWINDOW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAINWINDOW.M with the given input arguments.
%
%      MAINWINDOW('Property','Value',...) creates a new MAINWINDOW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MainWindow_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MainWindow_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MainWindow

% Last Modified by GUIDE v2.5 15-Nov-2018 17:44:00

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MainWindow_OpeningFcn, ...
                   'gui_OutputFcn',  @MainWindow_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before MainWindow is made visible.
function MainWindow_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MainWindow (see VARARGIN)

% Choose default command line output for MainWindow
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes MainWindow wait for user response (see UIRESUME)
% uiwait(handles.figure1);


global GUIhandles Mstate shutterState

Mstate.running = 0;

%Set GUI to the default established in configureMstate
set(handles.screendistance,'string',num2str(Mstate.screenDist))
set(handles.analyzerRoots,'string',Mstate.analyzerRoot)
set(handles.animal,'string',Mstate.anim)
set(handles.unitcb,'string',Mstate.unit)
set(handles.exptcb,'string',Mstate.expt)
set(handles.hemisphere,'string',Mstate.hemi)
set(handles.screendistance,'string',Mstate.screenDist)
set(handles.monitor,'string',Mstate.monitor)
set(handles.stimulusIDP,'string',Mstate.stimulusIDP)

GUIhandles.main = handles;

%initialize eye shutter settings
shutterState.use=0;
shutterState.ini=0;


% --- Outputs from this function are returned to the command line.
function varargout = MainWindow_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function animal_Callback(hObject, eventdata, handles)
% hObject    handle to animal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of animal as text
%        str2double(get(hObject,'String')) returns contents of animal as a double

global Mstate

Mstate.anim = get(handles.animal,'string');

anaroot = get(handles.analyzerRoots,'string');
Mstate.analyzerRoot = anaroot;

roots = parseString(Mstate.analyzerRoot,';');

dirinfo = dir([roots{1} '\' Mstate.anim]); %Use the first root path for the logic below

if length(dirinfo) > 2 %If the animal folder exists and there are files in it
    
    lastunit = dirinfo(end).name(6:8);
    lastexpt = dirinfo(end).name(10:12);

    newunit = lastunit; 
    newexpt = sprintf('%03d',str2num(lastexpt)+1); %Go to next experiment number
    
else  %if animal folder does not exist or there aren't any files.  The new folder will
        %be created when you hit the 'run' button
    
    newunit = '000';
    newexpt = '000';

end

Mstate.unit = newunit;
Mstate.expt = newexpt;
set(handles.exptcb,'string',newexpt)
set(handles.unitcb,'string',newunit)

UpdateACQExptName   %Send expt info to acquisition


% --- Executes during object creation, after setting all properties.
function animal_CreateFcn(hObject, eventdata, handles)
% hObject    handle to animal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function hemisphere_Callback(hObject, eventdata, handles)
% hObject    handle to hemisphere (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of hemisphere as text
%        str2double(get(hObject,'String')) returns contents of hemisphere as a double

global Mstate

%This is not actually necessary since updateMstate is always called prior
%to showing stimuli...
Mstate.hemi = get(handles.hemisphere,'string');

% --- Executes during object creation, after setting all properties.
function hemisphere_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hemisphere (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function screendistance_Callback(hObject, eventdata, handles)
% hObject    handle to screendistance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of screendistance as text
%        str2double(get(hObject,'String')) returns contents of screendistance as a double

global Mstate

%This is not actually necessary since updateMstate is always called prior
%to showing stimuli...  
Mstate.screenDist = str2num(get(handles.screendistance,'string'));


% --- Executes during object creation, after setting all properties.
function screendistance_CreateFcn(hObject, eventdata, handles)
% hObject    handle to screendistance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in runbutton.
function runbutton_Callback(hObject, eventdata, handles)
% hObject    handle to runbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Mstate GUIhandles Pstate trialno analogIN inputM

%Run it!
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
    if get(GUIhandles.main.intrinsicflag,'value')

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
    
%     if strcmp('RD',getmoduleID) %if raindropper
%         if getParamVal('randseed_bit') %if random seed bit is set
%             rval = round(rand(1)*1000)/1000;
%             updatePstate('rseed',rval)
%         end
%     end

    saveExptParams  %Save .analyzer. Do this before running... in case something crashes

    set(handles.runbutton,'string','Abort')    
    
    %%%%Send initial parameters to display
    sendPinfo
    waitforDisplayResp
    sendMinfo
    waitforDisplayResp
    %%%%%%%%%%%%%%%%%%%%%%%%%%

    %%%Get the 2photon Acquisition ready:
    if get(GUIhandles.main.twophotonflag,'value');  %Flag for the link with scanimage
        prepACQ
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    
    %%%Send inital parameters to ISI imager GUI
    P = getParamStruct;
    if get(GUIhandles.main.intrinsicflag,'value')
        total_time = P.predelay+P.postdelay+P.stim_time;
        GUIhandles.main.timetxt = total_time;
        sendtoImager(sprintf(['I %2.3f' 13],total_time))
        
        %Make sure analog in is not running
        %stop(analogIN)
        %analogIN.stop
        %flushdata(analogIN)        
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
    trialno = 1;
    
    % Save Files new 
    
    %In 2 computer version 'run2' is no longer a loop, but gets recalled
    %after each trial... 
    %In 'endAcquisition' (2ph), below (intrinsic), or 'Displaycb' (no acquisition)
    
    run2  
    
    %%%%What the hell was I doing here before?
%     while trialno<=getnotrials
%         run2
%     end
%     Mstate.running = 0;
%     set(GUIhandles.main.runbutton,'string','Run')
%     
%     if get(GUIhandles.main.intrinsicflag,'value')        
%         %set(GUIhandles.param.playSample,'enable','off')
%         saveOnlineAnalysis
%     end
    
    %We don't want anything significant to happen after 'run2', so that
    %scanimage will be ready to accept TTL
    
else
    Mstate.running = 0;  %Global flag for interrupt in real-time loop ('Abort')    
    set(handles.runbutton,'string','Run')    
end

%This is done to ensure that user builds a new stimulus before doing
%'playsample'.  Otherwise it will open the shutter.
%set(GUIhandles.param.playSample,'enable','off')


% --- Executes on button press in unitcb.
function unitcb_Callback(hObject, eventdata, handles)
% hObject    handle to unitcb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Mstate

newunit = sprintf('%03d',str2num(Mstate.unit)+1);
Mstate.unit = newunit;
set(handles.unitcb,'string',newunit)

newexpt = '000';
Mstate.expt = newexpt;
set(handles.exptcb,'string',newexpt)

UpdateACQExptName   %Send expt info to acquisition

% --- Executes on button press in exptcb.
function exptcb_Callback(hObject, eventdata, handles)
% hObject    handle to exptcb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global Mstate

newexpt = sprintf('%03d',str2num(Mstate.expt)+1);
Mstate.expt = newexpt;
set(handles.exptcb,'string',newexpt)

UpdateACQExptName   %Send expt info to acquisition


% --- Executes on button press in closeDisplay.
function closeDisplay_Callback(hObject, eventdata, handles)
% hObject    handle to closeDisplay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global DcomState

fwrite(DcomState.serialPortHandle,'C;~')


% --- Executes on button press in twophotonflag.
function twophotonflag_Callback(hObject, eventdata, handles)
% hObject    handle to twophotonflag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of twophotonflag

global GUIhandles

flag = get(handles.twophotonflag,'value');
set(GUIhandles.main.twophotonflag,'value',flag)

% if flag
%     set(handles.intrinsicflag,'value',0);
%     set(GUIhandles.main.intrinsicflag,'value',0)
% end



function analyzerRoots_Callback(hObject, eventdata, handles)
% hObject    handle to analyzerRoots (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of analyzerRoots as text
%        str2double(get(hObject,'String')) returns contents of analyzerRoots as a double


%This is not actually necessary since updateMstate is always called prior
%to showing stimuli...
Mstate.analyzerRoot = get(handles.analyzerRoots,'string');

% --- Executes during object creation, after setting all properties.
function analyzerRoots_CreateFcn(hObject, eventdata, handles)
% hObject    handle to analyzerRoots (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





% --- Executes on button press in REflag.
function REflag_Callback(hObject, eventdata, handles)
% hObject    handle to REflag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of REflag

REbit = get(handles.REflag,'value');
moveShutter(2,REbit)
waitforDisplayResp



% --- Executes on button press in LEflag.
function LEflag_Callback(hObject, eventdata, handles)
% hObject    handle to LEflag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of LEflag

LEbit = get(handles.LEflag,'value');
moveShutter(1,LEbit)
waitforDisplayResp



function monitor_Callback(hObject, eventdata, handles)
% hObject    handle to monitor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of monitor as text
%        str2double(get(hObject,'String')) returns contents of monitor as a double

global Mstate

Mstate.monitor = get(handles.monitor,'string');

updateMonitorValues
sendMonitor

% --- Executes during object creation, after setting all properties.
function monitor_CreateFcn(hObject, eventdata, handles)
% hObject    handle to monitor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function stimulusIDP_Callback(hObject, eventdata, handles)
% hObject    handle to stimulusIDP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of stimulusIDP as text
%        str2double(get(hObject,'String')) returns contents of stimulusIDP as a double


% --- Executes during object creation, after setting all properties.
function stimulusIDP_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stimulusIDP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in intrinsicflag.
function intrinsicflag_Callback(hObject, eventdata, handles)
% hObject    handle to intrinsicflag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of intrinsicflag


global GUIhandles

flag = get(handles.intrinsicflag,'value');
set(GUIhandles.main.intrinsicflag,'Value',flag);

if flag
    set(handles.twophotonflag,'value',0);
    set(GUIhandles.main.twophotonflag,'value',0)
end

% --- Executes on button press in analysisFlag.
function analysisFlag_Callback(hObject, eventdata, handles)
% hObject    handle to analysisFlag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of analysisFlag

global GUIhandles

flag = get(handles.analysisFlag,'value');
set(GUIhandles.main.analysisFlag,'value',flag)

if flag
    set(handles.streamFlag,'value',0);
    set(GUIhandles.main.streamFlag,'value',0)
end


% --- Executes on button press in streamFlag.
function streamFlag_Callback(hObject, eventdata, handles)
% hObject    handle to streamFlag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of streamFlag

global GUIhandles

flag = get(handles.streamFlag,'value');
set(GUIhandles.main.streamFlag,'value',flag)

if flag
    set(handles.analysisFlag,'value',0);
    set(GUIhandles.main.analysisFlag,'value',0)
end


% --- Executes on button press in mouseBehavior.
function mouseBehavior_Callback(hObject, eventdata, handles)
% hObject    handle to mouseBehavior (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of mouseBehavior
