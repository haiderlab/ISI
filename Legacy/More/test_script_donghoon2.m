% clear
% clc 

[g_ar_1, map_1] = test_fun_donghoon('../../../Data/ISI/Animal Testing/Mouse_4_A19014/08_12/1/000.mat','../../../Data/ISI/Animal Testing/Mouse_4_A19014/08_12/2/000.mat',0);
[g_ar_2, map_2] = test_fun_donghoon('../../../Data/ISI/Animal Testing/Mouse_4_A19014/08_12/1/000.mat','../../../Data/ISI/Animal Testing/Mouse_4_A19014/08_12/2/001.mat',1);
% tt = (map_1 - map_2)/2;
% figure;   imagesc((rad2deg(tt)*206/360)+44 ); colormap jet; colorbar