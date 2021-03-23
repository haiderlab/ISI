 function [area,com_loc,degrees] = ISImakecontour(loc,filtval,azimuthbit)

locmap = [loc 'ISImap.mat'];
load(locmap);

%% median Filter
%filtval = [3,3]
VFS = medfilt2(abs_map,filtval);
if azimuthbit == 1
    contourmap =(rad2deg(VFS)*205/360)+45;
    contourmap_10 = round(contourmap,-1);
    stepsize = 10;
    degrees = (min(min(contourmap_10)):stepsize:max(max(contourmap_10)))';

elseif azimuthbit == -1
    contourmap =(rad2deg(VFS)*71.6/360)-4.9;
    contourmap_10 = round(contourmap/5 )*5;
    stepsize = 5;
    degrees = (-10:5:35)';
end
%%

% [~, ~, alpha] = imread('loc1el_removed.png');
% mask = cdata == 0;
% contourmap_10(mask) = nan;
%%

area = zeros(length(degrees),1);
com_loc = zeros(length(degrees),2);
for i = 1:length(degrees)
    [area(i), com_loc(i,:)] = quantifyanalysis(contourmap_10,degrees(i));
end

%%

% 
% figure;
% subplot(2,2,2); 
% imagesc(contourmap); colorbar; colormap jet 



% subplot(2,2,3); 
% 
% subplot(2,2,4); 
% if azimuthbit == 1
%     imagesc((rad2deg(abs_map)*206/360)+44); colorbar; colormap jet
% elseif azimuthbit == -1
%     imagesc((rad2deg(abs_map)*74.3/360)-2.45); colorbar; colormap jet
% end

 % practice_gradient(loc,contourmap_10);
  
% subplot(2,2,1);imshow(mat2gray(g_im_1)); hold on; 
% [C_1,h_1] = contour(contourmap_10,'r');
% 
figure; imagesc(contourmap); colorbar; colormap jet 
figure; imagesc(contourmap_10); colorbar; colormap jet 
figure; imshow(mat2gray(g_im_1));


%%
figure; imshow(mat2gray(g_im_1)); hold on;[C_1,h_1] = contour(contourmap_10,'r','LineWidth', 2); hold off
% figure; imagesc(contourmap_10); colorbar; colormap jet; hold on; [C_1,h_1] = contour(contourmap_10,'r', 'LineWidth', 2);hold off

% imshow(contourmap_10,[])
%figure; imagesc(contourmap); colorbar; colormap jet
%figure; imagesc(contourmap_10); colorbar; colormap jet

end
 
 



