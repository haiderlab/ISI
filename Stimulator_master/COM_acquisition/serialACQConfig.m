function serialACQConfig

%Modification of MP285Config, for configuration of serial port connection to ScanImage.	

global ACQserial

ACQserial.port='COM3';

% close all open serial port objects on the same port and remove
% the relevant object form the workspace
	port=instrfind('Port',ACQserial.port);
	if length(port) > 0; 
		fclose(port); 
		delete(port);
		clear port;
	end

% make serial object
ACQserial.serialPortHandle = serial(ACQserial.port);
% set(ACQserial.serialPortHandle, 'BaudRate', 19200, 'Parity', 'none' , ...
%      'StopBits', 1);  %These values must match the ones at the acquisition computer

%Establish serial port event callback criterion
ACQserial.serialPortHandle.BytesAvailableFcnMode = 'Terminator';
ACQserial.serialPortHandle.Terminator = 99; %Magic number to identify request from ScanImage

% open and check status 
fopen(ACQserial.serialPortHandle);
stat=get(ACQserial.serialPortHandle, 'Status');
if ~strcmp(stat, 'open')
    disp([' serialConfig: trouble opening port; cannot proceed']);
    ACQserial.serialPortHandle=[];
    out=1;
    return;
end
    
ACQserial.serialPortHandle.bytesavailablefcn = @ScanImageAlert;  

fwrite(ACQserial.serialPortHandle, '!')
%serialTalk('Hello');

fwrite(ACQserial.serialPortHandle,['flush' '!']) %Flush out the buffer at ScanImage

%%%I don't know why this close/open is necessary, but otherwise extraneous
%%%things get stuck in the buffer
fclose(ACQserial.serialPortHandle);
delete(ACQserial.serialPortHandle);
clear ACQserial.serialPortHandle;

global ACQserial
ACQserial.port='COM3';
ACQserial.serialPortHandle = serial(ACQserial.port);
fopen(ACQserial.serialPortHandle)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
