function studyData(src, event)
% This function determines whether stimulus is threshold
    %filename = 'Time_Stimulus.xlsx'
    tic;
    t = {}
    if event.Data > 0.02
        t = [t,'J'];
    end
    %xlswrite(filename,t);
end
