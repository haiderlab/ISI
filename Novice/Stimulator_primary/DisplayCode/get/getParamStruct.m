function PStruct = getParamStruct

global Pstate Mstate

for i = 1:length(Pstate.param)
    eval(['PStruct.' Pstate.param{i}{1} '= Pstate.param{i}{3} ;'])
end

