function waitforACQ

%%%%This is no longer needed in 2 computer set-up

%This waits for the acquisition computer to finish acquiring and writing to disc

global ACQserial

%%%First make sure buffer is clear:
n = get(ACQserial.serialPortHandle,'BytesAvailable');
if n > 0
    fread(ACQserial.serialPortHandle,n); %clear the buffer
end
n = 0;  %Need this, or it won't enter next loop (if there were leftover bits)!!!!

%%%Now wait...
while n == 0
    n = get(ACQserial.serialPortHandle,'BytesAvailable'); %Wait for response
end
pause(.5) %wait to collect the rest of the string

%%%Show the response
n = get(ACQserial.serialPortHandle,'BytesAvailable');
Resp = fread(ACQserial.serialPortHandle,n);
Resp = char(Resp)';

if strcmp(Resp(1:2),'DW')
    sprintf('Done writing data. Next trial.')
else
    sprintf('Warning... No "done saving" response from Scanimage')
end

