function varargout = script_GUI(varargin)
%SCRIPT_GUI MATLAB code file for script_GUI.fig
%      SCRIPT_GUI, by itself, creates a new SCRIPT_GUI or raises the existing
%      singleton*.
%
%      H = SCRIPT_GUI returns the handle to a new SCRIPT_GUI or the handle to
%      the existing singleton*.
%
%      SCRIPT_GUI('Property','Value',...) creates a new SCRIPT_GUI using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to script_GUI_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      SCRIPT_GUI('CALLBACK') and SCRIPT_GUI('CALLBACK',hObject,...) call the
%      local function named CALLBACK in SCRIPT_GUI.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help script_GUI

% Last Modified by GUIDE v2.5 20-Jun-2018 12:49:06

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @script_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @script_GUI_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
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


% --- Executes just before script_GUI is made visible.
function script_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for script_GUI
handles.output = hObject;
handles.iFrame = 1;
parameters = evalin('base','parameters');
handles.imageThreshold = parameters.imageThreshold;
handles.areaThreshold = parameters.areaThreshold;
handles.maxArea = parameters.maxArea;
handles.diskSize = parameters.diskSize;
handles.images = parameters.images;
handles.centerx = parameters.x;
handles.centery = parameters.y;
handles.N = parameters.N;

% Add Frame total
totFrames = sprintf('/ %d', parameters.N);
set(handles.maxFrames_text, 'String', totFrames);

% Plot initial video frame
axes(handles.originalvideo_plot)
imshow(parameters.images(:,:,1,handles.iFrame));
axes(handles.processedtest_plot)
imshow(parameters.images(:,:,1,handles.iFrame));

set(handles.frameSlider,'Min', 1);
set(handles.frameSlider,'Max', handles.N);
set(handles.frameSlider,'Value', 1);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes script_GUI wait for user response (see UIRESUME)
% uiwait(handles.param_GUI);


% --- Outputs from this function are returned to the command line.
function varargout = script_GUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function frame_text_Callback(hObject, eventdata, handles)
% hObject    handle to frame_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.iFrame = str2double(get(hObject,'String'));
% Hints: get(hObject,'String') returns contents of frame_text as text
%        str2double(get(hObject,'String')) returns contents of frame_text as a double
guidata(hObject,handles)
frameUpdater(hObject,handles)

% --- Executes during object creation, after setting all properties.
function frame_text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to frame_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function disksize_text_Callback(hObject, eventdata, handles)
% hObject    handle to disksize_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.diskSize = str2double(get(hObject,'String'));

guidata(hObject, handles)

% Hints: get(hObject,'String') returns contents of disksize_text as text
%        str2double(get(hObject,'String')) returns contents of disksize_text as a double


% --- Executes during object creation, after setting all properties.
function disksize_text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to disksize_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function maxArea_text_Callback(hObject, eventdata, handles)
% hObject    handle to maxArea_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.maxArea = str2double(get(hObject,'String'));
guidata(hObject, handles)
% Hints: get(hObject,'String') returns contents of maxArea_text as text
%        str2double(get(hObject,'String')) returns contents of maxArea_text as a double


% --- Executes during object creation, after setting all properties.
function maxArea_text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxArea_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function imageThreshold_text_Callback(hObject, eventdata, handles)
% hObject    handle to imageThreshold_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.imageThreshold = str2double(get(hObject,'String'));
guidata(hObject, handles)
% Hints: get(hObject,'String') returns contents of imageThreshold_text as text
%        str2double(get(hObject,'String')) returns contents of imageThreshold_text as a double


% --- Executes during object creation, after setting all properties.
function imageThreshold_text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to imageThreshold_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function areaThreshold_text_Callback(hObject, eventdata, handles)
% hObject    handle to areaThreshold_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.areaThreshold = str2double(get(hObject,'String'));
guidata(hObject, handles)
% Hints: get(hObject,'String') returns contents of areaThreshold_text as text
%        str2double(get(hObject,'String')) returns contents of areaThreshold_text as a double


% --- Executes during object creation, after setting all properties.
function areaThreshold_text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to areaThreshold_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in applychange_pushbutton.
function applychange_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to applychange_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    i = handles.iFrame;
    images = handles.images;
    h = fspecial('disk',handles.diskSize);
    
    imshow(handles.images(:,:,1,i));axes(handles.originalvideo_plot)
    imshow(handles.images(:,:,1,i));axes(handles.processedtest_plot)
    
    Q = imcomplement(imfilter(squeeze(images(:,:,1,i)),h)) > handles.imageThreshold;
    imfill(Q,'holes');
    P = regionprops(Q,'Area','Centroid','PixelIdxList');
    z = [P(:).Area];
    largeRegionIdx = find(z > handles.areaThreshold & z < handles.maxArea);
    
    L = length(largeRegionIdx);
    w = reshape([P(largeRegionIdx).Centroid]',[2 L])';
    ds = sum(bsxfun(@minus,w,[handles.centerx handles.centery]).^2,2);
    [~,minIdx] = min(ds);
    
    q = false(size(Q));
    
    q(P(largeRegionIdx(minIdx)).PixelIdxList) = true;
    q = imdilate(q,strel('disk',handles.diskSize/2));

    imshow(images(:,:,1,i));
    axis equal tight off
    hold on
    ylabel(num2str(i),'fontsize',16,'fontweight','bold','Rotation',0,'Units', 'Normalized', 'Position', [-0.25, 0.4, 0])
    B = bwboundaries(q);
    plot(B{1}(:,2),B{1}(:,1),'m-','linewidth',2); axes(handles.processedtest_plot)
    drawnow
    hold off
    

% --- Executes on button press in finalize_pushbutton.
function finalize_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to finalize_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
assignin('base','areaThreshold',handles.areaThreshold)
assignin('base','diskSize',handles.diskSize)
assignin('base','imageThreshold',handles.imageThreshold)
assignin('base','maxArea',handles.maxArea)
close


% --- Executes on button press in frameup_pushbutton.
function frameup_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to frameup_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.iFrame = handles.iFrame + 1;
guidata(hObject, handles)
applychange_pushbutton_Callback(hObject, eventdata, handles)
frameUpdater(hObject,handles)


% --- Executes on button press in framedown_pushbutton.
function framedown_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to framedown_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.iFrame = handles.iFrame - 1;
guidata(hObject, handles)
applychange_pushbutton_Callback(hObject, eventdata, handles)
frameUpdater(hObject,handles)

% --- Executes on button press in lastframe_pushbutton.
function lastframe_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to lastframe_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.iFrame = handles.N;
guidata(hObject, handles)
applychange_pushbutton_Callback(hObject, eventdata, handles)
frameUpdater(hObject,handles)

% --- Executes on button press in firstframe_pushbutton.
function firstframe_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to firstframe_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.iFrame = 1;
guidata(hObject, handles)
applychange_pushbutton_Callback(hObject, eventdata, handles)
frameUpdater(hObject,handles)

% --- Updates frames for textbox and slider
function frameUpdater(hObject,handles)
set(handles.frame_text, 'String', sprintf('%d', handles.iFrame))
set(handles.frameSlider, 'Value', handles.iFrame);

% --- Executes on slider movement.
function frameSlider_Callback(hObject, eventdata, handles)
% hObject    handle to frameSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

val = round(get(hObject, 'Value'));
set(hObject, 'Value', val);
handles.iFrame = val;
guidata(hObject, handles)
applychange_pushbutton_Callback(hObject, eventdata, handles)
frameUpdater(hObject,handles)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function frameSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to frameSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
