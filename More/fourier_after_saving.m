%% Fourier
function [map_1, g_im] = fourier_after_saving(loc)
load(loc)
stack_b = movMix;
respA = [];
timeAdjustedDiff_f = diff(timevecReal(2:end))/1000;
Fs_f = 1 ./ mode(timeAdjustedDiff_f);
for i = 1:size(stack_b,1) 
    i
    for j = 1:size(stack_b,2)
       intensity_b = squeeze(stack_b(i,j,:));
        % FFT
      [ind, sh1_R_b,len_1_b] = tr(intensity_b, Fs_f, inputFreq);
      
        % Plotting
       a = angle(sh1_R_b); %angle(sh1_R_b);
       m = a(1); 
       map_1(i,j) = m; %mod(m, 2*pi);
    end
end
%figure; imagesc(rad2deg(map_1)); colormap jet; colorbar 