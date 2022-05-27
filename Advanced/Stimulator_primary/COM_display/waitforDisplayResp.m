function waitforDisplayResp   
tic
global DcomState 

comhandle = DcomState.serialPortHandle;

%Clear the buffer
n = get(comhandle,'BytesAvailable');
if n > 0
    fread(comhandle,n); %clear the buffer
end

%Wait...
n = 0;  %Need this, or it won't enter next loop (if there were leftover bits)!!!!
while n == 0
    n = get(comhandle,'BytesAvailable'); %Wait for response
end
pause(.5) %Hack to finish the read


n = get(comhandle,'BytesAvailable');
if n > 0
    fread(comhandle,n); %clear the buffer
end
toc

