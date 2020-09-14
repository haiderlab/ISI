function updateACQtrial(trialno)

%%%%%%%%Update ScanImage with Trial/Cond/Rep %%%%%%%%%%%%%%%%%

global looperInfo Lstate

[cond] = getcondrep(trialno);


Nloop = length(Lstate.param); %no. of looping parameters
if Nloop == 1
    
    pdum = looperInfo.conds{cond}.symbol{1};
    vdum = looperInfo.conds{cond}.val{1};

    Stimulus_localCallback(['TrialInfo;' ...
        num2str(trialno) ';' ...
        pdum ';' ...
        num2str(vdum)]);

elseif Nloop == 2
    
    pdum1 = looperInfo.conds{cond}.symbol{1};
    vdum1 = looperInfo.conds{cond}.val{1};
    pdum2 = looperInfo.conds{cond}.symbol{2};
    vdum2 = looperInfo.conds{cond}.val{2};

    Stimulus_localCallback(['TrialInfo;' ...
        num2str(trialno) ';' ...
        pdum1 ';' ...
        num2str(vdum1) ';' ...
        pdum2 ';' ...
        num2str(vdum2)]);


elseif Nloop == 3

    pdum1 = looperInfo.conds{cond}.symbol{1};
    vdum1 = looperInfo.conds{cond}.val{1};
    pdum2 = looperInfo.conds{cond}.symbol{2};
    vdum2 = looperInfo.conds{cond}.val{2};
    pdum3 = looperInfo.conds{cond}.symbol{3};
    vdum3 = looperInfo.conds{cond}.val{3};

    Stimulus_localCallback(['TrialInfo;' ...
        num2str(trialno) ';' ...
        pdum1 ';' ...
        num2str(vdum1) ';' ...
        pdum2 ';' ...
        num2str(vdum2) ';' ...
        pdum3 ';' ...
        num2str(vdum3)]);
end



