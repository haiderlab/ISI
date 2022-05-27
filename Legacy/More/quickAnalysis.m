%% Quick pixel analysis
[period_3,inputFreq_3,resizeImage_3,Fs_3, timeStamps_3,bslne_3,barsON_3,tt_3] = resizingImage(ims,timevecReal,1,timeStim,timeStimReal);

%% create average map
stack_b = resizeImage_3;
respA = [];
for i = 1:size(stack_b,1) 
    for j = 1:size(stack_b,2) 
        % Backward
        intensity_b_r = squeeze(stack_b(i,j,:));
        meanBaseline_b = bslne_3(i,j);
        intensity_b = -log10(intensity_b_r./meanBaseline_b);  
        % New methods backward
        time_R_b = (timeStamps_3 - timeStamps_3(1))/1000;
        time_Transf_b = time_R_b./period_3*2*pi;
        time_Transf_Im_b = exp(1i*time_Transf_b);
        prod_mean_b = mean(time_Transf_Im_b.*intensity_b');
       % Plot
       map_1(i,j) = prod_mean_b;
                                                                                                                                                                                                                                                      
    end
end
figure; 
imagesc(rad2deg(angle(map_1))); colorbar; colormap jet; 
title 'Quick Analysis - Not adjusted'