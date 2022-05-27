% This script is for post-processing after ISI experiment
% Outout 1: Azimuth retinotopy
% Output 2: Elevation retinotopy
% Output 3: Visual Field Sign (VFS) map

% Load package with running functions 
addpath(genpath('supporting_functions'))
%% Processing Azimuth retinotpy per Block
% Prior to running this section each block of recording must be saved 
% and nammed 000 (forward) and 001 (backward)
% See example data for structure 
% i = number of blocks recorded
% loc2.RL = location of azimuth recs. using Red Light
% loc3.GL = location of azimuth recs. using Green Light
% loc2.limitfw = Used to specify the number of trails to conside in block 
% in forward recs. (000) - Default is 0 = consider all trails
% loc2.limitbw = similar to loc2.limitfw but for backward map (001)
% loc2.azimuthbit = Specify section is for Azimuth (1) or Elevation (-1)
% ISIanalysis_new = compute map| Second paramter is camera frame rate (FPS)

for i = [1 2] 
    loc2.RL = ['Sample_data\Azimuth\' num2str(i) '\'];
    loc2.GL = 'Sample_data\Vasculature\000.mat';
    loc2.limitfw = 0;
    loc2.limitbw = 0;
    loc2.azimuthbit = 1;
    ISIanalysis_new(loc2,10);
end

%% Processing Elevation retinotpy per Block
% See Azimuth for explanation of parameters
% Since Elevation, loc2.azimuthbit = -1

for i = [1 2]
    loc2.RL = ['Sample_data\Elevation\' num2str(i) '\'];
    loc2.GL = 'Sample_data\Vasculature\000.mat';
    loc2.limitfw = 0;
    loc2.limitbw = 0;
    loc2.azimuthbit = -1;
    ISIanalysis_new(loc2,10);
end

%% Compute Average map from Blocks
% Azimuth 
loc1a.RL = 'Sample_data\Azimuth\1\';
loc2a.RL = 'Sample_data\Azimuth\2\';
loc_all_A = {loc1a loc2a};
generate_grandmap(loc_all_A,'Azimuth',1);
suptitle('Azimuth')

% Elevation 
loc3a.RL = 'Sample_data\Elevation\1\';
loc4a.RL = 'Sample_data\Elevation\2\';
loc_all_E = {loc3a loc4a};
generate_grandmap(loc_all_E,'Elevation',-1);
suptitle('Elevation')


%% VFS map
% Refer to manuscript for appropriate sample size to produce reliable VFS 
% Data in Sample_data is under sampled

clear all; close all
visual_sign_map('Azimuth','Elevation',5,3.5,1);


























