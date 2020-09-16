function Displaycb(obj,event)
%Callback function from Stimulus PC

global DcomState GUIhandles

n=get(DcomState.serialPortHandle,'BytesAvailable');
if n > 0
    inString = fread(DcomState.serialPortHandle,n);
    inString = char(inString');
else
    return
end

inString = inString(1:end-1)  %Get rid of the terminator

%'nextT' is the string sent after stimulus is played
%If it just played a stimulus, and scanimage is not acquiring, then run
%next trial...
if strcmp(inString,'nextT') && ~get(GUIhandles.main.twophotonflag,'value') && ~get(GUIhandles.main.intrinsicflag,'value');    
    run2    
end
