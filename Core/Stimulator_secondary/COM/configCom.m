function configCom(primaryIP)

global comState

%Modification of MP285Config, for configuration of udp port connection to visual stimulus PC (pep) 	

%comState is not initialized in the .ini file, nor is it saved in the state.headerString

rip = primaryIP;

% close all open serial port objects on the same port and remove
% the relevant object from the workspace
port=instrfindall('RemoteHost',rip);
%port = '198.202.68.38';
if length(port) > 0; 
    fclose(port); 
    delete(port);
    clear port;
end

% make udp object named 'stim'
comState.serialPortHandle = udp(rip,'RemotePort',8844,'LocalPort',8866);

%For unknown reasons, the output buffer needs to be set to the amount that the input
%buffer needs to be.  For example, we never exptect to send a packet higher
%than 512 bytes, but the receiving seems to want the output buffer to be
%high as well.  Funny things happen if I don't do this.  (For UDP)
set(comState.serialPortHandle, 'InputBufferSize', 1024)
set(comState.serialPortHandle, 'OutputBufferSize', 1024)  %This is necessary for UDP!!!

set(comState.serialPortHandle, 'Datagramterminatemode', 'off')  %things are screwed w/o this


%Establish serial port event callback criterion
comState.serialPortHandle.BytesAvailableFcnMode = 'Terminator';
comState.serialPortHandle.Terminator = '~'; %Magic number to identify request from Stimulus ('c' as a string)

% open and check status 
fopen(comState.serialPortHandle);
stat=get(comState.serialPortHandle, 'Status');
if ~strcmp(stat, 'open')
    disp([' StimConfig: trouble opening port; cannot proceed']);
    comState.serialPortHandle=[];
    out=1;
    return;
end

comState.serialPortHandle.bytesavailablefcn = @Primarycb;  

