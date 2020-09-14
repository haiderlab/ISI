function [idx_f, sh1_R_f,len_1_f] = transformFourier(intensity_f, Fs,inputFreq)

ff1_f = fft(intensity_f);
sh1_f = fftshift(ff1_f);
sh1_R_f = sh1_f(floor(length(intensity_f)/2): end);
ly_f = length(intensity_f);
f_1_f = (-ly_f/2:ly_f/2-1)/ly_f*Fs;
len_1_f = f_1_f(floor(length(f_1_f)/2): end);


p = abs(sh1_R_f);
idx_f = find(len_1_f >= (inputFreq - (inputFreq*5/100)) & (len_1_f < (inputFreq + (inputFreq*5/100))));
end














