function varargout = paramSelect(varargin)
% PARAMSELECT M-file for paramSelect.fig
%      PARAMSELECT, by itself, creates a new PARAMSELECT or raises the existing
%      singleton*.
%
%      H = PARAMSELECT returns the handle to a new PARAMSELECT or the handle to
%      the existing singleton*.
%
%      PARAMSELECT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PARAMSELECT.M with the given input arguments.
%
%      PARAMSELECT('Property','Value',...) creates a new PARAMSELECT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before paramSelect_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to paramSelect_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help paramSelect

% Last Modified by GUIDE v2.5 15-Nov-2018 17:43:42

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @paramSelect_OpeningFcn, ...
                   'gui_OutputFcn',  @paramSelect_OutputFcn, ...
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



% --- Executes just before paramSelect is made visible.
function paramSelect_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to paramSelect (see VARARGIN)

% Choose default command line output for paramSelect
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes paramSelect wait for user response (see UIRESUME)
% uiwait(handles.figure1);

global GUIhandles playSampleFlag

modStrings{1} = 'Periodic Grater';
modStrings{2} = 'Flash Grater';
modStrings{3} = 'Rain Dropper';
modStrings{4} = 'Filtered Noise';
modStrings{5} = 'Manual Mapper';
modStrings{6} = 'Coherent Motion';

%set(handles.module,'string',modStrings)

set(handles.module,'string',modStrings)
GUIhandles.param = handles;

refreshParamView

playSampleFlag = 0;

% --- Outputs from this function are returned to the command line.
function varargout = paramSelect_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in parameterList.
function parameterList_Callback(hObject, eventdata, handles)
% hObject    handle to parameterList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns parameterList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from parameterList

global Pstate

idx = get(handles.parameterList,'value');

set(handles.paramEditVal,'string',num2str(Pstate.param{idx}{3}));
set(handles.paramEdit,'string',Pstate.param{idx}{1});

% --- Executes during object creation, after setting all properties.
function parameterList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to parameterList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function paramEditVal_Callback(hObject, eventdata, handles)
% hObject    handle to paramEditVal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of paramEditVal as text
%        str2double(get(hObject,'String')) returns contents of paramEditVal as a double

pval = get(handles.paramEditVal,'string');
psymbol = get(handles.paramEdit,'string');

updatePstate(psymbol,pval)
refreshParamView


% --- Executes during object creation, after setting all properties.
function paramEditVal_CreateFcn(hObject, eventdata, handles)
% hObject    handle to paramEditVal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in loadParams.
function loadParams_Callback(hObject, eventdata, handles)
% hObject    handle to loadParams (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global Pstate

[file path] = uigetfile({'*.param';'*.analyzer'},'Load parameter state','Y:\haider\Code\ISI\Run_Experiment\Final_version_dev_rig\Params\New\20secP');

id = find(file == '.');
fext = file(id+1:end);

if file  %if 'cancel' was not pressed
    file = [path file];
    
    if strcmp(fext,'param')  %selecting saved param file
        load(file,'-mat','Pstate')
    elseif strcmp(fext,'analyzer')  %selecting old experiment
        load(file,'-mat','Analyzer')
        Pstate = Analyzer.P;
    end
    
    %Create new Pstate based on current parameter list.  For example, if a
    %new variable is created that was not in the saved Pstate this will
    %assign it the default value.  It also resorts them according to default.
    oldPstate = Pstate;
    newPstate(oldPstate);  %Remakes the global
    
    refreshParamView
    
end



% --- Executes on button press in saveParams.
function saveParams_Callback(hObject, eventdata, handles)
% hObject    handle to saveParams (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global Pstate

[file path] = uiputfile('*.param','Save as','Y:\haider\Code\ISI\Run_Experiment\Final_version_dev_rig\Params\New\20secP');

if file  %if 'cancel' was not pressed
    file = [path file];
    save(file,'Pstate')
end


% --- Executes on selection change in module.
function module_Callback(hObject, eventdata, handles)
% hObject    handle to module (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns module contents as cell array
%        contents{get(hObject,'Value')} returns selected item from module

mod = getmoduleID;  %return 2 element string
configurePstate(mod) 
refreshParamView

% --- Executes during object creation, after setting all properties.
function module_CreateFcn(hObject, eventdata, handles)
% hObject    handle to module (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in send.
function send_Callback(hObject, eventdata, handles)
% hObject    handle to send (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global DcomState Mstate

set(handles.playSample,'enable','off')

Mstate.running = 0; %I don't think this is necessary, but doing it just in case for when I do 'sendMinfo'

updateMstate %this is only necessary for screendistance

%%%%Send parameters to display
sendPinfo
waitforDisplayResp
sendMinfo
waitforDisplayResp
%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%Tell it to buffer the stimulus
mod = getmoduleID;
%-1 (after B) is where trial number usually goes when looping.  I make it
%-1 so that it knows we are in "sample mode".
msg = ['B;' mod ';-1;~'];  
fwrite(DcomState.serialPortHandle,msg);  %Tell it to buffer images
waitforDisplayResp
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

set(handles.playSample,'enable','on')
playSample_Callback(hObject, eventdata, handles)

% --- Executes on button press in playSample.
function playSample_Callback(hObject, eventdata, handles)
% hObject    handle to playSample (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%runSample

global Mstate

startStimulus      %Tell Display to show its buffered images. 
%waitforDisplayResp   %Wait for serial port to respond from display at end of trial
