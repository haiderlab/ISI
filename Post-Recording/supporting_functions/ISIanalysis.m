function [area,locvec] = ISIanalysis(ISIdata)
plotbit = 1; % Do you want to plot in ISIpreprocessing?
savebit = 1; % Do you want to save output from ISIpreprocessing?

tic
loc_GL = ISIdata.GL;
loc_RL = ISIdata.RL;
load([loc_RL '000.mat'], 'Pstate')
limit_loc_fw = 0;
limit_loc_bw = 0;

ori = Pstate.param{1,19};
ori = ori{3};

if ori == 0
    azimuthbit = 1;
else
    azimuthbit = -1;
end

outputF = ISIpreprocess(loc_GL,[loc_RL '000.mat'],limit_loc_fw,plotbit,savebit);%Average out 1 run to 1 period
outputB = ISIpreprocess(loc_GL,[loc_RL '001.mat'],limit_loc_bw,plotbit,savebit,outputF.g_im);


if exist('outputF','var') && exist('outputB','var')
    ISImakemap(loc_RL,azimuthbit,outputF,outputB); % Generate raw phasemap
else
    ISImakemap(loc_RL,azimuthbit); % Generate raw phasemap
end

[area,locvec,degrees]= ISImakecontour(loc_RL,[15,15],azimuthbit); % Generate filtered phasemaps & contour

%%
suptitle(strrep(loc_RL,'_',' '))
disp(strrep(loc_RL,'_',' '));
toc
disp(' ');
end

