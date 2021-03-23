function generate_grandmap(ISIdatavec,foldername,azimuthbit)
% This takes account of the number of runs that were used in each location
% ex) if loc1 has 10 fw and 5 bw, loc2 has 7 fw and 8 bw, then the grand
% forward would be (10loc1_fw + 7loc2_fw)/17, and the grand backward would
% be (5loc1_bw + 8loc2_bw)/13. 

tic 
for i= 1:length(ISIdatavec)
    %load([ISIdatavec{i}.RL 'ISImap.mat']);
    load([ISIdatavec{i} 'ISImap.mat']);
    forward{i} = valmap_1;
    forward_nrun{i} = nrun_1;
    g_im_forward{i} = g_im_1;
    backward{i} = valmap_2;
    backward_nrun{i} = nrun_2;
end

grand_forward = zeros(size(forward{1}));
grand_backward =zeros(size(backward{1}));
g_im = zeros(size(g_im_forward{1}));
grand_forward_nrun = 0;
grand_backward_nrun = 0;

for i = 1:length(ISIdatavec)
    grand_forward = grand_forward + forward_nrun{i} * forward{i};
    grand_backward = grand_backward + backward_nrun{i} * backward{i};
    g_im = g_im + g_im_forward{i};
    grand_forward_nrun = grand_forward_nrun + forward_nrun{i};
    grand_backward_nrun = grand_backward_nrun + backward_nrun{i};

end
g_im = g_im/length(ISIdatavec); 
grand_forward = grand_forward/grand_forward_nrun; 
grand_backward = grand_backward/grand_backward_nrun;


mkdir(foldername)
map_1 = angle(grand_forward);
map_2 = angle(grand_backward);
abs_map = azimuthbit * (map_1 - map_2)/2;
g_im_1 = g_im;
save([foldername '/ISImap.mat'], 'map_1','g_im_1', 'map_2', 'abs_map', 'grand_forward','grand_backward');


[area,locvec,degrees]= ISImakecontour([foldername, '/'],[20,20],azimuthbit);

disp('Generating Grandmap with three maps takes:')
toc

end
