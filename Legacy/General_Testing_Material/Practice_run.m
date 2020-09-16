% Practice trying to establish reading signal from Daq device
devices = daq.getDevices;
% Check for slot
devices(1);

s = daq.createSession('ni');
%Input from photodiode
addAnalogInputChannel(s,'Dev1',0,'Voltage');
s.Rate = 8000;

%Acquire scan
%data = s.inputSingleScan;

%Start Session
for i = 1:100
[data , time] = s.startForeground;

%Plotting

plot(time,data);
pause(1);

end
xlabel('Time (secs) ');
ylabel('Voltage');
