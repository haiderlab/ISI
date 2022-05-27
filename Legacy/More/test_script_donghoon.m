%% M
test_fun_donghoon('../../../Data/ISI/Animal_Testing/Mouse_4_A19014/08_21/2/000.mat','../../../Data/ISI/Animal_Testing/Mouse_4_A19014/08_21/4/000.mat',0);
test_fun_donghoon('../../../  Data/ISI/Animal_Testing/Mouse_4_A19014/08_21/2/000.mat','../../../Data/ISI/Animal_Testing/Mouse_4_A19014/08_21/4/001.mat',1);

%% Fourier 
[map_1, g_im_1] = fourier_after_saving('Y:\haider\Data\ISI\Animal_Testing\Mouse_4_A19014\08_12\2\avg_000');
[map_2, g_im_2] = fourier_after_saving('Y:\haider\Data\ISI\Animal_Testing\Mouse_4_A19014\08_12\2\avg_001');


% Av_M
if g_im_1 ~= g_im_2
    vec = findsize(g_ar_1,g_ar_2);
    g_ar_1 = g_ar_1(vec(3):vec(3)+vec(1)-1, vec(4):vec(4)+vec(2)-1, :);
    map_1 = map_1(vec(3):vec(3)+vec(1)-1, vec(4):vec(4)+vec(2)-1, :);
    g_ar_2 = g_ar_2(vec(5):vec(5)+vec(1)-1, vec(6):vec(6)+vec(2)-1, :);
    map_2 = map_2(vec(5):vec(5)+vec(1)-1, vec(6):vec(6)+vec(2)-1, :);
    tt = (map_1 - map_2)/2;
else
    tt = (map_1 - map_2)/2;
end
figure;imagesc((rad2deg(tt)*206/360)+44 ); colormap jet; colorbar

trash_test();