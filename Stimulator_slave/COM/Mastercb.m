function Mastercb(obj,event)
%Callback function 'Stimulator' PC

global comState screenPTR loopTrial


try
    n = get(comState.serialPortHandle,'BytesAvailable');
     
    if n > 0
        inString = fread(comState.serialPortHandle,n);
        inString = char(inString');
    else
        return
    end
    
    inString = inString(1:end-1)  %Get rid of the terminator
    
    
    delims = find(inString == ';');
    msgID = inString(1:delims(1)-1);  %Tells what button was pressed at master
    if strcmp(msgID,'M') || strcmp(msgID,'C') || strcmp(msgID,'S')
        paramstring = inString(delims(1):end); %list of parameters and their values
    elseif strcmp(msgID,'B')        
        modID = inString(delims(1)+1:delims(2)-1); %The stimulus module (e.g. 'grater')
        loopTrial = str2num(inString(delims(2)+1:delims(3)-1));
        paramstring = inString(delims(3):end); %list of parameters and their values
    else
        modID = inString(delims(1)+1:delims(2)-1); %The stimulus module (e.g. 'grater')
        paramstring = inString(delims(2):end); %list of parameters and their values
    end
    delims = find(paramstring == ';');
    
    switch msgID
        
        case 'M'  %Update sent info from "main" window
            
            for i = 1:length(delims)-1
                
                dumstr = paramstring(delims(i)+1:delims(i+1)-1);
                id = find(dumstr == '=');
                psymbol = dumstr(1:id-1);
                pval = dumstr(id+1:end);
                updateMstate(psymbol,pval)
                
            end
            
        case 'P'  %Update sent info from "param" window.
            
            configurePstate(modID)
            for i = 1:length(delims)-1
                dumstr = paramstring(delims(i)+1:delims(i+1)-1);
                id = find(dumstr == '=');
                psymbol = dumstr(1:id-1);
                pval = dumstr(id+1:end);
                updatePstate(psymbol,pval)
            end
            
        case 'B'  %Build stimulus; update looper info and buffer to video card.
            
            for i = 1:length(delims)-1
                dumstr = paramstring(delims(i)+1:delims(i+1)-1);
                id = find(dumstr == '=');
                psymbol = dumstr(1:id-1);
                pval = dumstr(id+1:end);
                updatePstate(psymbol,pval)
            end
            
            %'if' statement so that it only builds/buffers the random ensemble
            %on first trial. e.g. we want to reset the looper variables
            %(above) for variables like 'rseed', but not build the ensemble
            %all over again. 
            %if ~strcmp(modID,'FG') || loopTrial == 1 || loopTrial == -1
                makeTexture(modID)  
            %end
            makeSyncTexture
            
            %The above if statement was commented out because it doesn't
            %allow me to change parameters for different trials.
            
            %loop Trial = -1 signifies 'sample' stimulus, which is
            %necessary to stop shutter control.
            
            
        case 'G'  %Go Stimulus
            
            playstimulus(modID)
            %pause(2)
            
            fwrite(comState.serialPortHandle,'nextT~')
            
        case 'MON'  %Monitor info
            
            global Mstate
            
            Mstate.monitor = modID;
            updateMonitor
            
        case 'C'  %Close Display
            Screen('Close')
            Screen('CloseAll');
            %clear all
            %close all
            Priority(0);         
            
        case 'Q'  %Used by calibration.m at the Master (not part of 'Stimulator')
            
            paramstring = paramstring(2:end);            
            RGB = [str2num(paramstring(1:3)) str2num(paramstring(4:6)) str2num(paramstring(7:9))];
            Screen(screenPTR, 'FillRect', RGB)
            Screen(screenPTR, 'Flip');
           
        case 'S'  %Move shutter
            eye = str2num(paramstring(delims(1)+1:delims(2)-1)); %setting of LE shutter
            pos = str2num(paramstring(delims(2)+1:delims(3)-1)); %setting of RE shutter
            moveShutter(eye,pos);
            
            %pause(2)
            
    end
    
    
    if ~strcmp(msgID,'G')
        fwrite(comState.serialPortHandle,'a')  %dummy so that Master knows it finished
    end
    

    
catch
    
    Screen('CloseAll');
    ShowCursor;
    
    msg = lasterror;
    msg.message
    msg.stack.file
    msg.stack.line
    
    fwrite(comState.serialPortHandle,'a')  %dummy so that Master knows it finished
    
end
