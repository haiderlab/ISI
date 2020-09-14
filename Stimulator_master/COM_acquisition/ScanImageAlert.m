function ScanImageAlert(obj,event)
%Callback function from ScanImage PC

display('ScanImage Callback')

global serialstate

basename = fgetl(serialstate.serialPortHandle);

n=get(serialstate.serialPortHandle,'BytesAvailable');
if n > 0
    temp=fread(serialstate.serialPortHandle,n); 
end