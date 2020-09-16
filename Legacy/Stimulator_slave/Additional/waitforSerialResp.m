function waitforSerialResp  

global comState


comhandle = comState.serialPortHandle;


n = get(comhandle,'BytesAvailable');
if n > 0
    fread(comhandle,n); %clear the buffer
end

while n == 0
    n = get(comhandle,'BytesAvailable'); %Wait for response
end

pause(.5) %Hack to finish the read

n = get(comhandle,'BytesAvailable');
if n > 0
    fread(comhandle,n); %clear the buffer
end

