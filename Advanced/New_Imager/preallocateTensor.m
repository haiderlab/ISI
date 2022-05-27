function preallocateTensor

global FPS Tens ROIcrop GUIhandles

%  total_time =  str2num(get(findobj('Tag','timetxt'),'String'));
 total_time = GUIhandles.main.timetxt;
 maxframes = ceil(total_time*FPS);
 
if get(GUIhandles.main.analysisFlag,'value') || ~get(GUIhandles.main.streamFlag,'value')            
    Tens = zeros(round(ROIcrop(4)),round(ROIcrop(3)),maxframes,'uint16');
else
    Tens = 0;
end
