function [c r] = getcondrep(trialno)

%trialno is 1 to N

global looperInfo

nc = length(looperInfo.conds);

for c = 1:nc
    nr = getnoreps(c);
    for r = 1:nr
        if trialno == looperInfo.conds{c}.repeats{r}.trialno;
            return
        end
    end
end
