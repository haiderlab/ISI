function paramSelect_new

global GUIhandles playSampleFlag

handles = {};
modStrings{1} = 'Periodic Grater';
modStrings{2} = 'Flash Grater';
modStrings{3} = 'Rain Dropper';
modStrings{4} = 'Filtered Noise';
modStrings{5} = 'Manual Mapper';
modStrings{6} = 'Coherent Motion';
handles.module = modStrings;


GUIhandles.param = handles;


playSampleFlag = 0;


% Loading the stimulus 
global Pstate directionValue

path = 'Y:\haider\Code\ISI\Run_Experiment\full_run_new_GUI\Core\Params\';

if directionValue == 1
    file = 'horizontal.param';
else
    file = 'vertical.param';
end
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
    oldPstate = Pstate;
    newPstate(oldPstate);  %Remakes the global
end

end
