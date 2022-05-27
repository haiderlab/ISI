
global DcomState

root = 'C:\Stimulator_primary\Calibration\';

port = instrfindall;
if length(port) > 0; 
    fclose(port); 
    delete(port);
    clear port;
end

configDisplayCom    %stimulus computer

PR650 = serial('COM6','BaudRate',9600,'InputBufferSize',4096);
fopen(PR650)

%% This needs to be executed immediately after the 650 is turned on

%fprintf(PR650,'S1,,,,,0,1,1') %adaptive
%I decided that I don't like the adaptive because it doesn't give me
%anything for the low values
fprintf(PR650,'S1,,,,,1000,1,1') %set integration time (ms)
pause(2)

n = get(PR650,'BytesAvailable');
if n > 0
    bout = fread(PR650,n); 
end  %
sprintf('%c',bout)


%% Execute this cell to get the luminance measurements

%clear the input buffer
n = get(PR650,'BytesAvailable');
if n > 0
    bout = fread(PR650,n); 
else
    bout = '';
end 
sprintf('%c',bout)

dom =0:1:255;
clear Y x y
fid = fopen([root 'luminance'],'w');
for i=1:3
    for k=1:length(dom)
        
        j = dom(k);
        RGB = '000000000';
        RGB(3*(i-1)+1:i*3) = sprintf('%03s',num2str(j))

        fwrite(DcomState.serialPortHandle,['Q;RGB;' RGB ';~']); %Give display command
        waitforDisplayResp

        sprintf('Measuring Gun #%d = %d\n',i,j)

        %Make sure buffer is clear before write command
        n = get(PR650,'BytesAvailable');
        if n > 0
            fread(PR650,n);
        end

        %Make measurement
        fprintf(PR650,['M1' 13]);

        %Wait for response
        n = 0;
        while n == 0
            n = get(PR650,'BytesAvailable');
        end
        pause(4) %let it get the rest of the string
        n = get(PR650,'BytesAvailable');
        
        bout = fread(PR650,n);
        
        data = sprintf('%c',bout)
        delims = find(data == ',');
        
        %Store CIE values:
        Y(i,k) = str2num(data(delims(2)+1:delims(3)-1))
        x(i,k) = str2num(data(delims(3)+1:delims(4)-1))
        y(i,k) = str2num(data(delims(4)+1:end))
        Err(i,k) = str2num(data(1:delims(1)-1))
        
        sprintf('%c',bout)

        %Write to file
        fprintf(fid,'%c',bout);

    end
end
%save([root 'CIEvalues.mat'],'x','y','Y','Err','dom')
%close display
fwrite(DcomState.serialPortHandle,'C;~')

%%

%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%

%%

fprintf(PR650,'S1,,,,,0,1,1')
n = get(PR650,'BytesAvailable');
if n > 0
    bout = fread(PR650,n); 
end %clear buffer
pause(1)

%%
fwrite(DcomState.serialPortHandle,['Q;RGB;128000000;~']); %Give display command
waitforDisplayResp

nreps = 3;
clear dom Iall
for rep = 1:nreps
    fwrite(PR650, ['M5' 13]);
    pause(2)

    n = 0;
    while n == 0
        n = get(PR650,'BytesAvailable');
    end
    pause(10) %let it get the rest of the string

    n = get(PR650,'BytesAvailable');
    if n > 0
        bout = fread(PR650,n);
    end

    %Convert bout into usable Matlab variable
    bout = [13; bout; 13];
    id = find(bout == 13);
    nstring = median(diff(id));
    k = 1;
    for i = 1:length(id)-1
        strpc = bout(id(i)+1:id(i+1)-1);
        length(strpc)
        if length(strpc) == nstring-1
            dum = sprintf('%c',strpc);
            delim = find(dum == ',');
            Iall(k,rep) = str2num(dum(delim+1:end));
            dom(k) = str2num(dum(1:delim-1));
            k = k+1;
        end
    end
end

I = mean(Iall');

save([root 'spectrum_red.mat'],'I','dom')
%fwrite(DcomState.serialPortHandle,'C;~')

%%

fwrite(DcomState.serialPortHandle,['Q;RGB;000128000;~']); %Give display command
waitforDisplayResp

nreps = 3;
clear dom Iall
for rep = 1:nreps
    fwrite(PR650, ['M5' 13]);
    pause(2)

    n = 0;
    while n == 0
        n = get(PR650,'BytesAvailable');
    end
    pause(10) %let it get the rest of the string

    n = get(PR650,'BytesAvailable');
    if n > 0
        bout = fread(PR650,n);
    end

    %Convert bout into usable Matlab variable
    bout = [13; bout; 13];
    id = find(bout == 13);
    nstring = median(diff(id));
    k = 1;
    for i = 1:length(id)-1
        strpc = bout(id(i)+1:id(i+1)-1);
        length(strpc)
        if length(strpc) == nstring-1
            dum = sprintf('%c',strpc);
            delim = find(dum == ',');
            Iall(k,rep) = str2num(dum(delim+1:end));
            dom(k) = str2num(dum(1:delim-1));
            k = k+1;
        end
    end
end

I = mean(Iall');

save([root 'spectrum_green.mat'],'I','dom')
%fwrite(DcomState.serialPortHandle,'C;~')

%%

fwrite(DcomState.serialPortHandle,['Q;RGB;000000128;~']); %Give display command
waitforDisplayResp

nreps = 3;
clear dom Iall
for rep = 1:nreps
    fwrite(PR650, ['M5' 13]);
    pause(2)

    n = 0;
    while n == 0
        n = get(PR650,'BytesAvailable');
    end
    pause(10) %let it get the rest of the string

    n = get(PR650,'BytesAvailable');
    if n > 0
        bout = fread(PR650,n);
    end

    %Convert bout into usable Matlab variable
    bout = [13; bout; 13];
    id = find(bout == 13);
    nstring = median(diff(id));
    k = 1;
    for i = 1:length(id)-1
        strpc = bout(id(i)+1:id(i+1)-1);
        length(strpc)
        if length(strpc) == nstring-1
            dum = sprintf('%c',strpc);
            delim = find(dum == ',');
            Iall(k,rep) = str2num(dum(delim+1:end));
            dom(k) = str2num(dum(1:delim-1));
            k = k+1;
        end
    end
end

I = mean(Iall');

save([root 'spectrum_blue.mat'],'I','dom')
fwrite(DcomState.serialPortHandle,'C;~')

%%