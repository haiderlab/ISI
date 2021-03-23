function ISImakemap(loc,azimuthbit,outputF,outputB)
%loc = location of the file
%azimuthbit = 1 if azimuth, -1 if elevation
%% Fourier 
if nargin <=2
    load([loc 'ISIavg_000']);
    outputF.movMix = movMix;
    outputF.timevecReal = timevecReal;
    outputF.inputFreq = inputFreq;
    outputF.g_im = g_im;
    outputF.nrun = nrun;

    load([loc 'ISIavg_001']);
    outputB.movMix = movMix;
    outputB.timevecReal = timevecReal;
    outputB.inputFreq = inputFreq;
    outputB.g_im = g_im;
    outputB.nrun = nrun;
    outputB.nrun = nrun;
end

nrun_1 = outputF.nrun;
nrun_2 = outputB.nrun;

[map_1, pmap_1,valmap_1, g_im_1] = generate_map(outputF);
[map_2, pmap_2,valmap_2, g_im_2] = generate_map(outputB);

% If vasculature of map1 and map2 are not equal, it is needed to match them
if min(size(g_im_1) == size(g_im_2))
else
    disp('forward - backward g_im size mismatch')
    vec = findsize(g_im_1,g_im_2);
    g_im_1 = g_im_1(vec(3):vec(3)+vec(1)-1, vec(4):vec(4)+vec(2)-1, :);
    map_1 = map_1(vec(3):vec(3)+vec(1)-1, vec(4):vec(4)+vec(2)-1, :);
    
    load([loc 'ISIavg_000'])
    g_im = g_im(vec(3):vec(3)+vec(1)-1, vec(4):vec(4)+vec(2)-1, :);
    movMix = movMix(vec(3):vec(3)+vec(1)-1, vec(4):vec(4)+vec(2)-1, :);

    save([loc 'ISIavg_000'], 'movMix','timevecReal','inputFreq','g_im');

    
    g_im_2 = g_im_2(vec(5):vec(5)+vec(1)-1, vec(6):vec(6)+vec(2)-1, :);
    map_2 = map_2(vec(5):vec(5)+vec(1)-1, vec(6):vec(6)+vec(2)-1, :);
end

tt = (map_1 - map_2)/2;

if azimuthbit == 1 % if elevation tt = map_2(fw) - map_1(bw);
    abs_map = tt;
    figure;imagesc((rad2deg(tt)*206/360)+44 ); colormap jet; colorbar
else
    abs_map = -tt;
    figure;imagesc((rad2deg(abs_map)*74.3/360)-2.45); colorbar; colormap jet

end

save([loc 'ISImap.mat'], 'map_1','g_im_1', 'map_2', 'abs_map', 'valmap_1', 'valmap_2','nrun_1','nrun_2');
% valmap and nrun are used for grandmap generation

end
