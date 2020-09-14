function varargout = Adjust_Light(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @Adjust_Light_OpeningFcn, ...
    'gui_OutputFcn',  @Adjust_Light_OutputFcn, ...
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
end
% --- Executes just before Adjust_Light is made visible.
    function Adjust_Light_OpeningFcn(hObject, eventdata, handles, varargin)
    
        % Initialization
        %Preallocate handles
        handles.live = false;
        handles.acq = false;
        handles.Size = 128;
        handles.factor = 1.00;
        handles.recordingTime = 1;
        global lightval;
        % Illumination
        sit = serial('COM1','Tag','ilser','Terminator','CR','DataTerminalReady',...
            'on','RequestToSend','on');
        fopen(sit);
        handles.sit = sit;
        tempval = strsplit(lightval,'=');
        set(handles.lightIntensity,'string',str2num(tempval{2}));

        fprintf(sit,lightval)
        fclose(handles.sit);
       
        
        % Update handles structure
        guidata(hObject, handles);
        global imagerhandles FPS
        FPS = 10;
        imagerhandles = handles;  %% we need this for the timerfcn callback

    end
% --- Outputs from this function are returned to the command line.
    function varargout = Adjust_Light_OutputFcn(hObject, eventdata, handles)
        handles.output = hObject;
        varargout{1} = handles.output;
    end
  
% --- Executes on slider movement.
function Illumination_slider_Callback(hObject, eventdata, handles)
global lightval;
fopen(handles.sit);
val = get(hObject,'Value');
val = round(val);
str = sprintf('INT0=%d',val);
set(handles.lightIntensity,'string',val);
lightval = str;

fprintf(handles.sit,str);
fclose(handles.sit);
end
% --- Executes during object creation, after setting all properties.
function Illumination_slider_CreateFcn(hObject, eventdata, handles)
set(hObject,'Min',1)
set(hObject,'Max',4000)
set(hObject, 'Value', 1000);
set(hObject, 'SliderStep', [1/4000 , 10/4000 ]);
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
end
function FrameRate_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function FrameRate_Callback(hObject, eventdata, handles)
    handles.FrameRate = str2double(get(hObject,'String'));
    global FPS
    FPS = handles.FrameRate;
    guidata(hObject, handles);
end
