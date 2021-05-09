function configDisplayCom

global DcomState Mstate

%Modification of MP285Config, for configuration of udp port connection to visual stimulus PC (pep) 	

%DcomState is not initialized in the .ini file, nor is it saved in the state.headerString 

%close all open udp port objects on the same port and remove
%the relevant object form the workspace
port = instrfindall('RemoteHost',Mstate.stimulusIDP);
%port = instrfindall('RemoteHost','10.1.50.224');
%port = '10.1.50.224';
if length(port) > 0; 
    fclose(port); 
    delete(port);
    clear port;
end

% make udp object named 'stim'
DcomState.serialPortHandle = udp(Mstate.stimulusIDP,'RemotePort',8866,'LocalPort',8844);
%DcomState.serialPortHandle = udp('10.1.50.224','RemotePort',8866,'LocalPort',8844);

set(DcomState.serialPortHandle, 'OutputBufferSize', 1024)
set(DcomState.serialPortHandle, 'InputBufferSize', 1024)
set(DcomState.serialPortHandle, 'Datagramterminatemode', 'off')

%Establish serial port event callback criterion  
DcomState.serialPortHandle.BytesAvailableFcnMode = 'Terminator';
DcomState.serialPortHandle.Terminator = '~'; %Magic number to identify request from Stimulus ('c' as a string)
DcomState.serialPortHandle.bytesavailablefcn = @Displaycb;  

% open and check status 
fopen(DcomState.serialPortHandle);
stat=get(DcomState.serialPortHandle, 'Status');
if ~strcmp(stat, 'open')
    disp([' StimConfig: trouble opening port; cannot proceed']);
    DcomState.serialPortHandle=[];
    out=1;
    return;
end

% 
% %Serial port version
% 
% function configDisplayCom
% 
% global DcomState
% 
% %Modification of MP285Config, for configuration of serial port connection to visual stimulus PC (pep) 	
% 
% %DcomState is not initialized in the .ini file, nor is it saved in the state.headerString
% 
% Stimport='COM1';  
% 
% % close all open serial port objects on the same port and remove
% % the relevant object form the workspace
% port=instrfind('Port',Stimport);
% if length(port) > 0; 
%     fclose(port); 
%     delete(port);
%     clear port;
% end
% 
% % make serial object named 'stim'
% DcomState.serialPortHandle = serial(Stimport);
% % set(DcomState.serialPortHandle, 'BaudRate', 19200, 'Parity', 'none', ...
% %    'StopBits', 1);  %These values must match the ones at the stimulus computer
% 
% set(DcomState.serialPortHandle, 'OutputBufferSize', 1024)
% 
% %Establish serial port event callback criterion
% DcomState.serialPortHandle.BytesAvailableFcnMode = 'Terminator';
% DcomState.serialPortHandle.Terminator = '~'; %Magic number to identify request from Stimulus ('c' as a string)
% 
% % open and check status 
% fopen(DcomState.serialPortHandle);
% stat=get(DcomState.serialPortHandle, 'Status');
% if ~strcmp(stat, 'open')
%     disp([' StimConfig: trouble opening port; cannot proceed']);
%     DcomState.serialPortHandle=[];
%     out=1;
%     return;
% end
% 
% DcomState.serialPortHandle.bytesavailablefcn = @Displaycb;  
% 
