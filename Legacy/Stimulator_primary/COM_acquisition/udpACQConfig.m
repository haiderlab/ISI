
function udpACQConfig

%Modification of MP285Config, for configuration of serial port connection to ScanImage.	

global ACQserial

rip = '143.215.230.157';  %remote IP address (acquisition computer)

% close all open udp port objects on the same port and remove
% the relevant object form the workspace
port = instrfindall('RemoteHost',rip);
if length(port) > 0; 
    fclose(port); 
    delete(port);
    clear port;
end

% make udp object named 'stim'
ACQserial.serialPortHandle = udp(rip,'RemotePort',8766,'LocalPort',8744);

set(ACQserial.serialPortHandle, 'Datagramterminatemode', 'off')

% open and check status 
fopen(ACQserial.serialPortHandle);
stat=get(ACQserial.serialPortHandle, 'Status');
if ~strcmp(stat, 'open')
    disp([' StimConfig: trouble opening port; cannot proceed']);
    ACQserial.serialPortHandle=[];
    out=1;
    return;
end

%Establish serial port event callback criterion (Primary doesn't use callbacks, it waits)
% ACQserial.serialPortHandle.BytesAvailableFcnMode = 'Terminator';
% ACQserial.serialPortHandle.Terminator = 99; %Magic number to identify request from Stimulus ('c' as a string)
% ACQserial.serialPortHandle.bytesavailablefcn = @ScanImageAlert;  

fwrite(ACQserial.serialPortHandle,['flush' '!'])
