function nt = getnotrials

global looperInfo

nc = getnoconds;

nt = 0;
for c = 1:nc
    nr = length(looperInfo.conds{c}.repeats);
    nt = nt+nr;
end