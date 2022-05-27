%% Fourier
function [phasemap,powermap,valmap, g_im] = generate_map(output)
%Modified in 1/8/2020 to be matrix multiplication 


%loc = location of the file
%azimuthbit = 1 if azimuth, -1 if elevation

%%
g_im = output.g_im;
stack_b = output.movMix(:,:,11:end);
[s1,s2,s3] = size(stack_b);
phasemap = zeros(s1,s2);
powermap = zeros(s1,s2);

%zeropads = zeros(s1,s2,s3 * 6);
%zeropads(:,:,1:180) = stack_b;
%stack_b = zeropads; 


timeAdjustedDiff_f = diff(output.timevecReal(2:end))/1000; % what is it? -donghoon
Fs_f = 1 ./ mode(timeAdjustedDiff_f);
freq_indices = round(output.inputFreq/Fs_f*s3);  
DFTvector = exp(-2*pi*1i/s3*freq_indices*(0:s3-1));
stack_a = reshape(stack_b,s1*s2,s3);
vals = stack_a * DFTvector';


valmap = reshape(vals,s1,s2);
phasemap = angle(valmap);
powermap = abs(valmap).^2;


end


