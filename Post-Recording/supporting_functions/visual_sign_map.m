function visual_sign_map(azimuth,elevation,th1,th2,plotbit) %,a,e)
% Azimuth = map from azimuth direction
% Elevation = map from elevation direction 
% th1 = VFS filter 1 --> low val. decreases amount of noise (bckgrd)
% th2 = gaussian filter --> high val. increases smooth (blurryness)
azimuth_file = load([azimuth, '/ISImap.mat']);
elevation_file = load([elevation, '/ISImap.mat']);

vec = findsize(azimuth_file.g_im_1,elevation_file.g_im_1);
g_im = azimuth_file.g_im_1(vec(3):vec(3)+vec(1)-1, vec(4):vec(4)+vec(2)-1, :);
azimuthmap = azimuth_file.abs_map(vec(3):vec(3)+vec(1)-1, vec(4):vec(4)+vec(2)-1, :);
g_im_2 = elevation_file.g_im_1(vec(5):vec(5)+vec(1)-1, vec(6):vec(6)+vec(2)-1, :);
elevationmap = elevation_file.abs_map(vec(5):vec(5)+vec(1)-1, vec(6):vec(6)+vec(2)-1, :);

%% median Filter
median_threshold = [4,4];
gaussian_threshold = th1;
[M,N] = size(g_im);

VFS_azimuth = imgaussfilt(azimuthmap,gaussian_threshold); % gaussian filter (aka lowpass)
contourmap_azimuth =(rad2deg(VFS_azimuth)*206/360)+ 44;%44
contourmap_10_azimuth = round(contourmap_azimuth,-1);


VFS_elevation = imgaussfilt(elevationmap,gaussian_threshold); % gaussian filter (aka lowpass)
contourmap_elevation =(rad2deg(VFS_elevation)*74.3/360)-2.45; %-2.45;
contourmap_10_elevation = round(contourmap_elevation/5)*5;

if plotbit == 1
    figure;subplot(2,3,1);imagesc(contourmap_azimuth); colorbar; colormap jet
    subplot(2,3,2);imagesc(contourmap_10_azimuth); colorbar; colormap jet
    subplot(2,3,3);imagesc((rad2deg(azimuthmap)*206/360)+44); colorbar; colormap jet
    subplot(2,3,4);imagesc(contourmap_elevation); colorbar; colormap jet
    subplot(2,3,5);imagesc(contourmap_10_elevation); colorbar; colormap jet
    subplot(2,3,6);imagesc((rad2deg(elevationmap)*74.3/360)-2.45); colorbar; colormap jet
end
%%
resizecoeff = 1/4;
g_im = g_im(mod(M,resizecoeff)+1:end,mod(N,resizecoeff)+1:end);
contourmap_azi_orig = contourmap_azimuth(mod(M,resizecoeff)+1:end,mod(N,resizecoeff)+1:end);
contourmap_ele_orig = contourmap_elevation(mod(M,resizecoeff)+1:end,mod(N,resizecoeff)+1:end);
contourmap_azimuth = imresize(contourmap_azi_orig,resizecoeff);
contourmap_elevation = imresize(contourmap_ele_orig,resizecoeff);
g_im = imresize(g_im,resizecoeff);


contourmap_azimuth(g_im == 300) = 44;
contourmap_elevation(g_im == 300) = -2.45;

[azi_mag,azi_dir] = imgradient(contourmap_azimuth);
[ele_mag,ele_dir] = imgradient(contourmap_elevation);

figure; subplot(2,2,1); imagesc(azi_dir); colorbar; colormap jet;
subplot(2,2,2); imagesc(ele_dir); colorbar; colormap jet;

S = -1* (azi_dir - ele_dir); subplot(2,2,3); imagesc(S); colorbar; colormap jet;
subplot(2,2,3); imagesc(sind(S)); colorbar; colormap jet;
VFS = sind(S);
hh = fspecial('gaussian',size(VFS),th2); 
hh = hh/sum(hh(:));
VFS = ifft2(fft2(VFS).*abs(fft2(hh))); 
%%
%Cleaning for better contour - Armel 
gradmag = abs(VFS); 
threshSeg = 2.0*std(VFS(:));
imseg = (sign(gradmag-threshSeg/2) + 1)/2;  %threshold visual field sign map at +/-1.5sig
id = find(imseg);
imdum = imseg.*VFS; imdum(id) = imdum(id)+1.1;
patchSign = getPatchSign(imseg,VFS);
id = find(patchSign ~= 0);
patchSign(id) = sign(patchSign(id) - 1);
SE = strel('disk',2,0);
imseg = imopen(imseg,SE);
patchSign = getPatchSign(imseg,VFS);
imout = ploteccmap(patchSign,[1.1 2.1]);


subplot(2,2,4); imagesc(VFS,[-1 1]); colorbar; colormap jet;
suptitle(['Threshold 1 = ' num2str(th1) ', Threshold 2 = ' num2str(th2)]);
figure; imagesc(VFS, [-1 1]); colorbar; colormap jet;
suptitle(['Threshold 1 = ' num2str(th1) ', Threshold 2 = ' num2str(th2)]);


if plotbit == 1
    % VFS on vasculature
    figure; imshow(mat2gray(g_im));hold on;
    contour(nanmean(imout,3), 'k', 'LineWidth',2)
    
    % Azimuth
    figure; imshow(mat2gray(g_im_2));hold on;
    contour(contourmap_10_azimuth, 'r', 'LineWidth',2); title 'Azimuth'
    figure; imagesc(contourmap_azimuth); colormap jet; colorbar;hold off
    figure; imshow(mat2gray(g_im_2));
    
    
    % Elevation
    figure; imshow(mat2gray(g_im_2));hold on;
    contour(nanmean(contourmap_10_elevation,3), 'g', 'LineWidth',2); title 'Elevation'
    figure; imagesc(contourmap_elevation); colormap jet; colorbar;
    
    % Both 
    figure; imshow(mat2gray(g_im_2));hold on;
    contour(contourmap_10_azimuth, 'r', 'LineWidth',2);
    contour(contourmap_10_elevation, 'g', 'LineWidth',2);
    
    % VFS - raw 
    figure; imagesc(VFS, [-1 1]); colormap jet; hold on; 
    contour(nanmean(imout,3), 'k', 'LineWidth',2);
    
    figure; imagesc(contourmap_10_azimuth);colormap jet;colorbar; hold on;
    contour(imresize(nanmean(imout,3),4),'k'); hold off; 


end


end
