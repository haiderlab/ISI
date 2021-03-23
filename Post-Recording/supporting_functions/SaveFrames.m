function SaveFrames(g_im_1,abs_map,h)
% Original
o_img = g_im_1;
VFS = medfilt2(abs_map,[20 20]);
contourmap =(rad2deg(VFS)*205/360)+45;
contourmap_10 = round(contourmap,-1);
M = contour(contourmap_10);
figure;imshow(o_img,[]);hold on;
contour(contourmap_10, 'r', 'LineWidth',2); 
% After cranio
c_img = single(cat(2,h));
c_img = imresize(c_img,0.5);
clearvars -except o_img c_img
figure;imshow(c_img,[]);
end