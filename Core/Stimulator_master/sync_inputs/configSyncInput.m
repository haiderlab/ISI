function configSyncInput

global analogIN FrameRate


% analogIN = daq.createSession('mcc');
% analogIN.Rate = 10000; 
% actualInputRate = get(analogIN, 'Rate');
% % Setting up input channel (Photodiode & Grab Time)
% addAnalogInputChannel(analogIN,'Board0',0,'Voltage');
% addAnalogInputChannel(analogIN,'Board0',1,'Voltage');

daq.reset;
analogIN = daq.createSession('mcc');
addAnalogInputChannel(analogIN,'Board0',0,'Voltage');
%lh = analogIN.addlistener('DataAvailable', @plotData);
analogIN.Rate = FrameRate*1000;
analogIN.IsContinuous = true;
%analogIN.startBackground();

%Shows open ports and data
%disp(analogIN)
end