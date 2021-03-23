function varphase = g_map(movMix,timevecReal,inputFreq,plotbit)
stack_b = movMix(:,:,11:end);
[s1,s2,s3] = size(stack_b);
timeAdjustedDiff_f = diff(timevecReal(2:end))/1000; % what is it? -donghoon
Fs_f = 1 ./ mode(timeAdjustedDiff_f);
freq_indices = round(inputFreq/Fs_f*s3);   
DFTvector = exp(-2*pi*1i/s3*freq_indices*(0:s3-1));
stack_a = reshape(stack_b,s1*s2,s3);
vals = stack_a * DFTvector';


valmap = reshape(vals,s1,s2);
phasemap = angle(valmap);
if plotbit == 1
    imagesc(phasemap); colormap jet
end
phasemapvec = phasemap(:);
phasemapvec(phasemapvec<0.025 & phasemapvec>-0.025) = nan;
var1 = nanvar(phasemapvec); % variance could be inaccurate due to periodicity of phase (ex) 0.3pi = 2.3pi = -1.7pi)
phasemapvec(phasemapvec < 0) = phasemapvec(phasemapvec < 0) + 2*pi;
varphase = min(nanvar(phasemapvec), var1);
end
