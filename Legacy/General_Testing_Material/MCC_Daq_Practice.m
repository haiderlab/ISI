% Practice run for MCC Daq
% Inputting and displaying 2 similtaneous anal. Signal

daq.reset;
devices = daq.getDevices;
s = daq.createSession('mcc');
% Photodiode channel
addAnalogInputChannel(s,'Board0',0,'Voltage');
% Analog channel
% addAnalogInputChannel(s,'Board0',1,'Voltage');
data = s.startForeground;
 for i = 1:10000
     [data , time] = s.startForeground;
     plot(time,data);
     pause(0.05);
     xlabel('Time (secs) ');
     ylabel('Voltage');

 end

%figure;






