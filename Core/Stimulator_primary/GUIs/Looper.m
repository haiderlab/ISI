function varargout = Looper(varargin)
% LOOPER M-file for Looper.fig
%      LOOPER, by itself, creates a new LOOPER or raises the existing
%      singleton*.
%
%      H = LOOPER returns the handle to a new LOOPER or the handle to
%      the existing singleton*.
%
%      LOOPER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LOOPER.M with the given input arguments.
%
%      LOOPER('Property','Value',...) creates a new LOOPER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Looper_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Looper_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Looper

% Last Modified by GUIDE v2.5 28-Mar-2010 14:27:46

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Looper_OpeningFcn, ...
                   'gui_OutputFcn',  @Looper_OutputFcn, ...
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


% --- Executes just before Looper is made visible.
function Looper_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Looper (see VARARGIN)

% Choose default command line output for Looper
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Looper wait for user response (see UIRESUME)
% uiwait(handles.figure1);

global GUIhandles

GUIhandles.looper = handles;

% --- Outputs from this function are returned to the command line.
function varargout = Looper_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function repeats_Callback(hObject, eventdata, handles)
% hObject    handle to repeats (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of repeats as text
%        str2double(get(hObject,'String')) returns contents of repeats as a double


% --- Executes during object creation, after setting all properties.
function repeats_CreateFcn(hObject, eventdata, handles)
% hObject    handle to repeats (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function symbol1_Callback(hObject, eventdata, handles)
% hObject    handle to symbol1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of symbol1 as text
%        str2double(get(hObject,'String')) returns contents of symbol1 as a double


% --- Executes during object creation, after setting all properties.
function symbol1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to symbol1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function symbol2_Callback(hObject, eventdata, handles)
% hObject    handle to symbol2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of symbol2 as text
%        str2double(get(hObject,'String')) returns contents of symbol2 as a double


% --- Executes during object creation, after setting all properties.
function symbol2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to symbol2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function symbol3_Callback(hObject, eventdata, handles)
% hObject    handle to symbol3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of symbol3 as text
%        str2double(get(hObject,'String')) returns contents of symbol3 as a double


% --- Executes during object creation, after setting all properties.
function symbol3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to symbol3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function symbol4_Callback(hObject, eventdata, handles)
% hObject    handle to symbol4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of symbol4 as text
%        str2double(get(hObject,'String')) returns contents of symbol4 as a double


% --- Executes during object creation, after setting all properties.
function symbol4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to symbol4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function symbol5_Callback(hObject, eventdata, handles)
% hObject    handle to symbol5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of symbol5 as text
%        str2double(get(hObject,'String')) returns contents of symbol5 as a double


% --- Executes during object creation, after setting all properties.
function symbol5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to symbol5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function valvec1_Callback(hObject, eventdata, handles)
% hObject    handle to valvec1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of valvec1 as text
%        str2double(get(hObject,'String')) returns contents of valvec1 as a double


% --- Executes during object creation, after setting all properties.
function valvec1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to valvec1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function valvec2_Callback(hObject, eventdata, handles)
% hObject    handle to valvec2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of valvec2 as text
%        str2double(get(hObject,'String')) returns contents of valvec2 as a double


% --- Executes during object creation, after setting all properties.
function valvec2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to valvec2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function valvec3_Callback(hObject, eventdata, handles)
% hObject    handle to valvec3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of valvec3 as text
%        str2double(get(hObject,'String')) returns contents of valvec3 as a double


% --- Executes during object creation, after setting all properties.
function valvec3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to valvec3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function valvec4_Callback(hObject, eventdata, handles)
% hObject    handle to valvec4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of valvec4 as text
%        str2double(get(hObject,'String')) returns contents of valvec4 as a double


% --- Executes during object creation, after setting all properties.
function valvec4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to valvec4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function valvec5_Callback(hObject, eventdata, handles)
% hObject    handle to valvec5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of valvec5 as text
%        str2double(get(hObject,'String')) returns contents of valvec5 as a double


% --- Executes during object creation, after setting all properties.
function valvec5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to valvec5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in randomflag.
function randomflag_Callback(hObject, eventdata, handles)
% hObject    handle to randomflag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of randomflag


% --- Executes on button press in loadLooper.
function loadLooper_Callback(hObject, eventdata, handles)
% hObject    handle to loadLooper (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global Lstate

[file path] = uigetfile('*.loop','Load looper state');

if file  %if 'cancel' was not pressed
    file = [path file];
    load(file,'-mat','Lstate')
    refreshLooperView
end


% --- Executes on button press in saveLooper.
function saveLooper_Callback(hObject, eventdata, handles)
% hObject    handle to saveLooper (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global Lstate

[file path] = uiputfile('*.loop','Save as');

if file  %if 'cancel' was not pressed
    file = [path file];
    updateLstate  %Make sure that stuff in GUI goes to Lstate
    save(file,'Lstate')
end



function formula_Callback(hObject, eventdata, handles)
% hObject    handle to formula (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of formula as text
%        str2double(get(hObject,'String')) returns contents of formula as a double


% --- Executes during object creation, after setting all properties.
function formula_CreateFcn(hObject, eventdata, handles)
% hObject    handle to formula (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in blankflag.
function blankflag_Callback(hObject, eventdata, handles)
% hObject    handle to blankflag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of blankflag

bflag = get(handles.blankflag,'value');
if bflag
    set(handles.blankPeriod,'enable','on')
else
    set(handles.blankPeriod,'enable','off')
end

function blankPeriod_Callback(hObject, eventdata, handles)
% hObject    handle to blankPeriod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of blankPeriod as text
%        str2double(get(hObject,'String')) returns contents of blankPeriod as a double


% --- Executes during object creation, after setting all properties.
function blankPeriod_CreateFcn(hObject, eventdata, handles)
% hObject    handle to blankPeriod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


