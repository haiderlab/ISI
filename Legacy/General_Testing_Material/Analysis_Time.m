% This is the analysis of the saved data
% Analysis & getting pick times
% Make sure to load this from Getting_Stimulus_Time
%function [dataTT, dataTTReal] = Analysis_Time(rate)
%global dataTT dataTTReal

dataX = timeStim; 
rate = 10000;
dataK = kmeans(dataX,2);
dataD = diff(dataK);
firstgroup = dataK(1);

if firstgroup == 1
    peakmarker = 1;
else
    peakmarker = -1;
end

time = linspace(0,length(dataX)/rate,length(dataX));
% save peak
peaks = find(dataD == peakmarker);
% Time of stimulus 
peaktimes1 = time(peaks);

% Time before onset of stimulus 
%peaktimes2 = time(peaks(1)-1);

% Remember that the first time (peaktimes2 == the time right before onset
% of stimulus)
%peaktimes = [peaktimes1];


