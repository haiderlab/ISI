function plotData(src, event)
% Plotting data Used for Photodiode
    persistent tempData;
    global dataTT dataTTReal
    if(isempty(tempData))
    tempData = [];
    end
    %plot(event.TimeStamps, event.Data)
    tempData = [tempData;event.Data];
    dataTT = tempData;
    t = clock ;
    dataTTReal = [dataTTReal (t(4)*3600 + t(5)*60 + t(6)) *1000];
end
