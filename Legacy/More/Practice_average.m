%% Script copied from Stanley's lab for analysis
function Practice_average(ims)
resizeImage = {};
for i = 1:length(ims)
    pImage = imresize(ims{i}, [512 512]);
    resizeImage{i} = pImage;
end
resizeImage = cat(3,resizeImage{:});
bound = [1,512,1,512];
thresh = 6;
label = 1;


% compute ratio and R-Ro / Ro
% Armel
% baseline = mean(frames_trim_raw(:,:,1:37),3)';
% signal = mean(frames_trim_raw(:,:,38:100),3)';
baseline = mean(resizeImage(:,:,1:100),3)';
signal = mean(resizeImage(:,:,101:550),3)';
sub = signal-baseline;
sub_ratio = sub./baseline ;
ratio = signal./baseline;
Ratio = ratio;   

%% Added due to altered contrast from IOS signal
Min=0.993;
Max=1.02;
Ratio(find(ratio<Min))= Min;
Ratio(find(ratio>Max))= Max;

%%
sigma_gauss= 3;
ratio_gfilt = imgaussfilt(Ratio,sigma_gauss);% gaussian filter
level = multithresh(ratio_gfilt(bound(3):bound(4),bound(1):bound(2)),thresh(1,1));%thresholding
seg_ratio = imquantize(ratio_gfilt(bound(3):bound(4),bound(1):bound(2)),level);
seg_ratio = seg_ratio==1;% transform 2 and 1 in 0 and 1
[seg_ratio_c,num] = bwlabel(seg_ratio,8);
max_v = max(max(seg_ratio_c));
[~,number_v]=max(histc(seg_ratio_c(:),1:max_v));


%%
iosfig=figure;

subplot(2,2,1)
image(Ratio,'CDataMapping','scaled');
colorbar
title('stim/baseline')
ax = gca;
%         ax.YDir = 'normal';

subplot(2,2,3)
image(ratio_gfilt,'CDataMapping','scaled')
colorbar
title(['Gaussian filter (sigma=' num2str(sigma_gauss) ')' ])
ax = gca;
%         ax.YDir = 'normal';

subplot(2,2,4)
image(seg_ratio_c,'CDataMapping','scaled')
ylim([1 size(ratio_gfilt,1)])
colorbar
title(['Threshold (' num2str(thresh(1,1)) ')' ])
ax = gca;
%         ax.YDir = 'normal';
%%

%     label = input('What is the appropriate label?'); %look at seg_ratio_c variable to determine
ind_l=seg_ratio_c==label(1,1);
new_ratio=zeros(size(seg_ratio_c,1),size(seg_ratio_c,2));
new_ratio(ind_l)=1;
s  = regionprops(new_ratio,'centroid');% find centroid of larger connected area
centroid = cat(1, s.Centroid);
centroid = centroid + [bound(1)-1 bound(3)-1];
%     if ( centroid(:,1) > 350 || centroid(:,1) < 100 || centroid(:,2) > 200 || centroid(:,2) < 50)
%         seg_ratio_c(ind_l)=0;
%     end

%% determining surround
[surroundrow surroundcol] = find(seg_ratio_c);
surround = [surroundrow, surroundcol];
%% Plotting centroids
subplot(2,2,1)
hold on
plot(centroid(:,1), centroid(:,2), 'r*')
%caxis([0 16383])
hold off

subplot(2,2,3)
hold on
plot(centroid(:,1), centroid(:,2), 'r*')
hold off

subplot(2,2,4)
hold on
plot(centroid(:,1) - bound(3), centroid(:,2) - bound(1), 'r*')
hold off

subplot(2,2,2)
image(Ratio,'CDataMapping','scaled');
hold on
plot(centroid(:,1), centroid(:,2), 'r*')
hold off
axis([centroid(1)-50 centroid(1)+50 centroid(2)-50 centroid(2)+50])
colorbar
title('stim/baseline')
ax = gca;
