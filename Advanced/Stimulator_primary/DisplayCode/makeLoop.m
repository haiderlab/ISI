function makeLoop

global Lstate GUIhandles looperInfo

looperInfo = struct;  %reset 

Nparam = length(Lstate.param); %number of looper parameters

%Produces a cell array 'd', with each element corresponding to a different
%looper variable.  Each element contains a multidimensional array from
%meshgrid with as many elements as there are conditions. They are id's, not
%actually variable values.
nc = 1;
for i = 1:Nparam
    eval(['paramV = ' Lstate.param{i}{2} ';']);
    nc = nc*length(paramV);
    if i == 1
        istring = ['1:' num2str(length(paramV))]; %input string for 'meshgrid'
        ostring = ['d{' num2str(i) '}'];  %output string for meshgrid
    else
        istring = [istring ',1:' num2str(length(paramV))];
        ostring = [ostring ',' 'd{' num2str(i) '}'];
    end
    
end

istring = ['meshgrid(' istring ')'];
ostring = ['[' ostring ']'];
eval([ostring ' = ' istring ';']);

%meshgrid outputs 2D grid, even for 1D input...
if Nparam == 1
    d{1} = d{1}(1,:);
end

nr = str2num(get(GUIhandles.looper.repeats,'string'));                      


%Create random sequence across conditions, for each repeat
for rep = 1:nr
    
    if get(GUIhandles.looper.randomflag,'value')
        [dum seq{rep}] = sort(rand(1,nc));  %make random sequence
    else                          
        seq{rep} = 1:nc;                                   
    end
                                
end 

bflag = get(GUIhandles.looper.blankflag,'value');
bPer = str2num(get(GUIhandles.looper.blankPeriod,'string'));

%Make the analyzer structure
for c = 1:nc
    for p = 1:Nparam
        
        idx = d{p}(c); %index into value vector of parameter p

        paramS = Lstate.param{p}{1};
        eval(['paramV = ' Lstate.param{p}{2} ';']);  %value vector

        looperInfo.conds{c}.symbol{p} = paramS;
        looperInfo.conds{c}.val{p} = paramV(idx);

    end
    
    for r = 1:nr
        pres = find(seq{r} == c);
        looperInfo.conds{c}.repeats{r}.trialno = nc*(r-1) + pres;      
    end
    
end


%Interleave the blanks:

looperInfoDum = looperInfo;
blankcounter = 0;
if bflag
    for t = 1:nr*nc
        [c r] = getcr(t,looperInfoDum,nc);

        if rem(t-1,bPer)==0 && t~=1
            blankcounter = blankcounter+1;
            looperInfo.conds{nc+1}.repeats{blankcounter}.trialno = t + blankcounter - 1;
        end

        looperInfo.conds{c}.repeats{r}.trialno = looperInfo.conds{c}.repeats{r}.trialno + blankcounter;

    end

end

if blankcounter > 0  %If the total number of trials is less than the blank period, then no blanks are shown
    for p = 1:Nparam
        looperInfo.conds{nc+1}.symbol{p} = 'blank';
        looperInfo.conds{nc+1}.val{p} = [];
    end
end

%Put the formula in looperInfo
looperInfo.formula = get(GUIhandles.looper.formula,'string');


function [c r] = getcr(t,looperInfo,nc)

%need to input nc so that it is always the number of conditions w/o blanks

nr = length(looperInfo.conds{1}.repeats);

for c = 1:nc
    for r = 1:nr        
        
        if t == looperInfo.conds{c}.repeats{r}.trialno
            return
        end
        
    end
end
