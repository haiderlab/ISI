%% Gaussian Filter
% I don't understand how to filter the phase - donghoon-
VFS = tt;
hh = fspecial('gaussian',size(VFS),12); 
hh = hh/sum(hh(:));
VFS = ifft2(fft2(VFS).*abs(fft2(hh) )); %Filtering , why abs? - donghoon


%% Threshold
gradmag = abs(VFS);
threshSeg = 1.75*std(VFS(:)); % setting threshold with standard deviation? , z = 1.75
imseg = (sign(gradmag-threshSeg/2) + 1)/2;  %threshold visual field sign map at +/-1.5sig
                                     % is it? it seems like at +/- 0.88
                                           
id = find(imseg); 
imdum = imseg.*VFS; %fully have values that > z = 0.88, times 0.5 to the values that are > -0.88
figure; imagesc((rad2deg(imdum)*206/360)+44); colorbar;
%figure; imagesc((rad2deg(tt)*74.4/360)-3.5);caxis([-20 100]); colormap jet; hold on; colorbar; 
figure; imshow(mat2gray(g_im_1)); hold on; 
[C_1,h_1] = imcontour(rad2deg(imdum)*(206/360)+44,'g'); w = h_1.LineWidth; h_1.LineWidth = 2.5; 
h_1.TextList = [-30:130];h_1.ShowText = 'on'; h_1.TextStep = 0.5; hold on
p = mat2gray(imdum);
s = regionprops(p,'centroid');centroids = cat(1,s.Centroid); plot(centroids(:,1),centroids(:,2),'b*'); hold off
%h_1.ZData<100
%figure; imshow(xxx, []); hold on;[C,h] = imcontour(imdum,7,'g'); 
%w = h.LineWidth; h.LineWidth = 2; 










