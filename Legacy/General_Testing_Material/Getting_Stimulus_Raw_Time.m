
%function Getting_Stimulus_Raw_Time
global dataTT dataTTReal
daq.reset;
devices = daq.getDevices;
s = daq.createSession('mcc');
% Photodiode channel
addAnalogInputChannel(s,'Board0',0,'Voltage');
% Listener & getting data
lh = s.addlistener('DataAvailable', @plotData);
s.Rate = 10000;
s.IsContinuous = true;
s.startBackground();
% Alan add this to SendToImager so that it runs when the experiment starts
% make sure to end this with s.stop after the total time
% (Pre+Stimulus+Post) runs out

