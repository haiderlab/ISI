function UpdateAndGo(cond)

global DcomState

%Sends loop information and start display

global looperInfo Pstate

bflag = strcmp(looperInfo.conds{cond}.symbol{1},'blank');

msg = 'Update&Go';

if bflag  %if it is a blank condition
    
    msg = sprintf('%s;%s=%.4f',msg,'contrast',0);
    
else %if it is not a blank condition
    
    %%%Send the contrast in Pstate in case last trial was a blank%%%
    for j = 1:length(Pstate.param)
        if strcmp('contrast',Pstate.param{j}{1})
            idx = j;
            break;
        end
    end
    msg = sprintf('%s;%s=%.4f',msg,'contrast',Pstate.param{idx}{3});
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    

    Nparams = length(looperInfo.conds{cond}.symbol);
    for i = 1:Nparams
        pval =looperInfo.conds{cond}.val{i};
        psymbol =looperInfo.conds{cond}.symbol{i};

        %Find parameter in Pstruct
        for j = 1:length(Pstate.param)
            if strcmp(psymbol,Pstate.param{j}{1})
                idx = j;
                break;
            end
        end
        prec = Pstate.param{idx}{2};  %Get precision

        %change value based on looper
        switch prec
            case 'float'
                msg = sprintf('%s;%s=%.4f',msg,psymbol,pval);
            case 'int'
                msg = sprintf('%s;%s=%d',msg,psymbol,round(double(pval)));
            case 'string'
                msg = sprintf('%s;%s=%s',msg,psymbol,pval);
        end
    end

end

msg = [msg ';~'];  %add the "Terminator"

fwrite(DcomState.serialPortHandle,msg,'async');

