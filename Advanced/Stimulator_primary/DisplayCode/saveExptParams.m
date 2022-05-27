function saveExptParams

global Mstate Pstate Lstate looperInfo

%Save the analzer file

Analyzer.M = Mstate;
Analyzer.P = Pstate;
Analyzer.L = Lstate;
Analyzer.loops = looperInfo;


title = [Mstate.anim '_' sprintf('u%s',Mstate.unit) '_' Mstate.expt];

roots = parseString(Mstate.analyzerRoot,';');

%Save each root:
for i = 1:length(roots)

    dd = [roots{i} '\' Mstate.anim];
dd
    if(~exist(dd))
        mkdir(dd);  %if there is a new animal
    end

    dd = [dd '\' title '.analyzer'];

    ['Saving analyzer file at location:  ' dd]

    save(dd ,'Analyzer')
    
end

