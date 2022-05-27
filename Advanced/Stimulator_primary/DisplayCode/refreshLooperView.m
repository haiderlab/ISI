function refreshLooperView

global Lstate GUIhandles

set(GUIhandles.looper.repeats,'string',Lstate.reps)
set(GUIhandles.looper.randomflag,'value',Lstate.rand)

set(GUIhandles.looper.formula,'string',Lstate.formula)

for i = 1:length(Lstate.param)
    
    eval(['symhandle = GUIhandles.looper.symbol' num2str(i) ';'])
    eval(['valhandle = GUIhandles.looper.valvec' num2str(i) ';'])

    set(symhandle,'string',Lstate.param{i}{1})
    set(valhandle,'string',Lstate.param{i}{2})

end
