function varargout = Imager(varargin)
% IMAGER MATLAB code for Imager.fig
%      IMAGER, by itself, creates a new IMAGER or raises the existing
%      singleton*.
%
%      H = IMAGER returns the handle to a new IMAGER or the handle to
%      the existing singleton*.
%
%      IMAGER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IMAGER.M with the given input arguments.
%
%      IMAGER('Property','Value',...) creates a new IMAGER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Imager_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Imager_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Imager

% Last Modified by GUIDE v2.5 17-May-2019 15:58:00

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Imager_OpeningFcn, ...
                   'gui_OutputFcn',  @Imager_OutputFcn, ...
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

end
% --- Executes just before Imager is made visible.
function Imager_OpeningFcn(hObject, eventdata, handles, varargin)
% Close current serial connections
if isempty(instrfind)
else
    fclose(instrfind);
end
% Choose default command line output for Imager
% handles.output = hObject;

%Preallocate handles
handles.live = false;
handles.acq = false;
handles.Size = 128;
sit = serial('COM1','Tag','ilser','Terminator','CR','DataTerminalReady',...
    'on','RequestToSend','on');
fopen(sit);
handles.sit = sit;
global lightval
tempval = strsplit(lightval,'=');
set(handles.Lvalue,'String',str2num(tempval{2}));
fprintf(sit,lightval)
fclose(handles.sit);
%matroxlist
handles.m = matroxcam(2,"Y:\haider\Docs\Armel Nsiangani\Frame Grabber\Final_DCF.dcf");

img = snapshot(handles.m);
handles.im = image(handles.axes2,img);

axis off

% Update handles structure
guidata(hObject, handles);

global imagerhandles FPS
FPS = 10;
handles.FrameRate = FPS;
imagerhandles = handles;  %% we need this for the timerfcn callback
% imagerhandles.roi = [256 256];
% imagerhandles.roisize = 100;

% imagerhandles.hwroi = [256 256];  %% Center of the image data region of interest (assumes 2x2 binning)
% imagerhandles.hwroisize = 128;

% UIWAIT makes Imager wait for user response (see UIRESUME)
% uiwait(handles.figure1);
end

% --- Outputs from this function are returned to the command line.
function varargout = Imager_OutputFcn(hObject, eventdata, handles) 
handles.output = hObject;
varargout{1} = handles.output;
end

% --- Executes on button press in LaunchLive_Button.
function LaunchLive_Button_Callback(hObject, eventdata, handles)
% hObject    handle to LaunchLive_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.live == false %Not live
    handles.live = true;
    vid = preview(handles.m,handles.im);

    set(handles.LaunchLive_Button, 'String','Stop Live');
else %Live
    handles.live = false;
    img = snapshot(handles.m);
    handles.im = image(handles.axes2,img);
    %stoppreview;

    set(handles.LaunchLive_Button, 'String','Start Live');
end

guidata(hObject, handles);
%Toggles live video
end

% --- Executes on button press in ViewROI.
function ViewROI_Callback(hObject, eventdata, handles)
% hObject    handle to ViewROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%Select the Region Of Interest
hold off
axis off
frame = get(get(handles.axes2,'children'),'cdata');
I = imcrop(frame,handles.ROI);
I1 = rgb2gray(I);
image(handles.axes3,I1)
hold on
colormap(handles.axes3,jet)
axis off

global imagerhandles
imagerhandles = handles;
end

% --- Executes during object creation, after setting all properties.
function axes2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes2
end

% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(hObject);
end

% --- Executes on button press in CaptureImage.
function CaptureImage_Callback(hObject, eventdata, handles)
% hObject    handle to CaptureImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
frame = get(get(handles.axes2,'children'),'cdata');
image(handles.axes3, frame);  
axes(handles.axes3)
title('Please select ROI')
hold on
axis off
handles.ROI = getPosition(imrect);
global ROIcrop
    ROIcrop = handles.ROI;

guidata(hObject, handles);
end

function figure1_DeleteFcn(hObject,eventdata,handles)
delete(hObject)
end

% --- Executes on slider movement.
function Illumination_Callback(hObject, eventdata, handles)
% hObject    handle to Illumination (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
val = get(hObject,'Value');
val = round(val);
str = sprintf('INT0=%d',val);
%set(handles.ValueLight,'string',val);
set(handles.Lvalue,'String',val);
fopen(handles.sit);
fprintf(handles.sit,str);
global lightval;
lightval = str;
fclose(handles.sit);
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
end

% --- Executes during object creation, after setting all properties.
function Illumination_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Illumination (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject,'Min',1)
set(hObject,'Max',4000)
set(hObject, 'Value', 1000);
set(hObject, 'SliderStep', [1/4000 , 10/4000 ]);
% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
end

% --- Executes during object creation, after setting all properties.
function ROI_size_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ROI_size (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function RecordTime_box_Callback(hObject, eventdata, handles)
% hObject    handle to RecordTime_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.recordingTime = str2double(get(hObject,'String'));
% Hints: get(hObject,'String') returns contents of RecordTime_box as text
%        str2double(get(hObject,'String')) returns contents of RecordTime_box as a double
guidata(hObject, handles);
end

% --- Executes during object creation, after setting all properties.
function RecordTime_box_CreateFcn(hObject, eventdata, handles)
% hObject    handle to RecordTime_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function imager_record(hObject, eventdata,  handles) %NOT USING THIS
%Initialize this function when the mainWindow uses "Run"
%Will begin recording ROI image frames at set intervals
 
RecordTime_box_Callback(hObject, eventdata, handles)
FrameRate_Callback(hObject, eventdata, handles)

handles.i = handles.recordingTime * handles.FrameRate; %recording Time is in seconds, Frame rate is in FPS
ims = [];
for i = 1:handles.i %Capture images from feed 
    tic
    frame = get(get(handles.axes2,'children'),'cdata');
    I = imcrop(frame,handles.ROI);
    I1 = rgb2gray(I);
    colormap(jet)
    
    ims = [ims {I1}];
    t = toc;
    pause((1/handles.FrameRate)-t) 
end
handles.timevec = [1/handles.FrameRate:1/handles.FrameRate:handles.recordingTime]; 
handles.ims = ims;
guidata(hObject, handles);

%Save images
save('imager_ImageRecording','handles')
end

function FrameRate_Callback(hObject, eventdata, handles)
% hObject    handle to FrameRate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.FrameRate = str2double(get(hObject,'String'));
global FPS
    FPS = handles.FrameRate;
% Hints: get(hObject,'String') returns contents of FrameRate as text
%        str2double(get(hObject,'String')) returns contents of FrameRate as a double
guidata(hObject, handles);
end

% --- Executes during object creation, after setting all properties.
function FrameRate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FrameRate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on button press in RecordButton.
function RecordButton_Callback(hObject, eventdata, handles)
% hObject    handle to RecordButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global imagerhandles
imagerhandles = handles;

sendtoImager_test
sprintf('File Saved')
end

function Lvalue_Callback(hObject, eventdata, handles)

end

% --- Executes during object creation, after setting all properties.
function Lvalue_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

