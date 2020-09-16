%% Resize stack
resizeImage = {};
for i = 1:length(ims)
    img = double (imresize(ims{i}, [512 512]));
    resizeImage{i} = img;
end
resizeImage = cat(3,resizeImage{:});
% Time vector
t = linspace(0,(max(timeStimReal)-min(timeStimReal))/1000,length(timeStim));
tt = linspace(min(timeStimReal),max(timeStimReal),length(timeStim));
tt_trans = tt';
% Finding indexes from when Phothodiode is rising
threshold = 3.5;
bars = find(abs(diff(timeStim > threshold)')>0);
barsON = bars(1:2:end-2);
barStartIDx = FindIndexCloseTo(tt_trans(barsON), timevecReal(1));
barsON = barsON(barStartIDx+1:end-1);
%%
timeF = tt_trans(barsON(1));
period = ((tt_trans(barsON(4))- tt_trans(barsON(3))))/1000;
% Left section
% 1 sec = 1000 millisec before rise
% Let's find index
idx_L_frames_stim = [];
for yy = 1:length(barsON)
    idx_L_frames_stim(yy) =  FindIndexCloseTo(timevecReal, (tt_trans(barsON(yy))-1000));
end
limit = length(idx_L_frames_stim);

%% Map
respA = [];
fc = 0.5; %Cutoff frequency
fs = 10; % Sampling rate
[b,a] = butter(10,fc/(fs/2));% Temporal filter with Butterworth flter 
endL = (round(period) + 1)*10;
% x_values = [58:68];
% y_values = [270:280];
x_values = [355:365];
y_values = [385:395];
% x_values = [365:385];
% y_values = [350:370];

for i = y_values(1):y_values(end)
    i
    for j = x_values(1):x_values(end)
        pixel_intensity = squeeze(resizeImage(i,j,:));
        for k = 1:limit
            f = pixel_intensity(idx_L_frames_stim(k):idx_L_frames_stim(k)+endL);
            b_1 = nanmean(pixel_intensity(idx_L_frames_stim(k):idx_L_frames_stim(k)+10),1);
            tmp = f - b_1;
            tmp = filter(b,a,tmp)*20;
            resp(:,k) = tmp;
        end
        single_pix_Avg = nanmean(resp,2);
        respA = [respA single_pix_Avg];
    end
end
 finalR_1 = nanmean(respA,2);
% finalR_2 = nanmean(respA,2); 
% finalR_3 = nanmean(respA,2); 
% finalR_4 = nanmean(respA,2);
% finalR_5 = nanmean(respA,2);
% clearvars -except finalR_1 finalR_2 finalR_3 finalR_4 finalR_5 step
% Single trace
%v = -1000:step:5000+15*step;
%%
%v = -1000:100:round(period)*1000;
for iii = 1:limit
ttime(:,iii) = timevecReal(idx_L_frames_stim(iii):idx_L_frames_stim(iii)+endL)/1000;
end
x = nanmean(ttime,2);
x = x - (x(1)+1);
figure;
% Delays
% delay_1 = find(finalR_1 == min(finalR_1));
% delay_2 = find(finalR_2 == min(finalR_2));
% delay_3 = find(finalR_3 == min(finalR_3));
% delay_4 = find(finalR_4 == min(finalR_4));
% delay_5 = find(finalR_5 == min(finalR_5));
id_z = FindIndexCloseTo(x, 0);
plot([x(id_z),x(id_z)],[-5,5],'r--','LineWidth',2)
ylim([-5 5])
hold on
plot(x,finalR_1,'k')%,x,finalR_2,'b')
% hold on
% id_t = FindIndexCloseTo(x, 10);
% plot([x(id_t),x(id_t)],[-3.5,4],'m--','LineWidth',2)

%% 45 deg.
figure;
 plot(len_1_f,abs(finalR_1),'k','LineWidth',1);
 title('Frequency domain in ROI')
xlabel('f (Hz)')
ylabel('|P1(f)|')
ylim([0 0.1])
grid on
hold on
plot([0.1,0.1],[0,0.1],'r--', 'LineWidth',2)
%set(gca, 'YScale', 'log')
set(gca, 'XScale', 'log')
% % 90 deg.
% plot(v,finalR_2,'k','LineWidth',3);
% plot([v(delay_2),v(delay_2)],[-3.5,3.5],'k--','LineWidth',3)
% % 0 deg.
% plot(v,finalR_3,'b','LineWidth',1);
% plot([v(delay_3),v(delay_3)],[-3.5,3.5],'b--','LineWidth',1)
% 23 deg.
plot(v,finalR_4,'m','LineWidth',1);
plot([v(delay_4),v(delay_4)],[-3.5,3.5],'m--','LineWidth',1)
% 63 deg.
plot(v,finalR_5,'k','LineWidth',2); 
plot([v(delay_5),v(delay_5)],[-3.5,3.5],'k--','LineWidth',2)
title ({'Box Color = 0 deg.', 'Magenta = 23 deg.','Black LW (1,2,3) = 45, 63, 90 deg. respectively'})
xlabel 'Time (Milliseconds)'
ylabel 'Reflectance'



% plot(-1000:100:10000,finalR_2,'b');
% hold on
% plot(-1000:100:10000,finalR_3,'y');
% hold on
% plot(-1000:100:10000,finalR_4,'m');
% hold on  
% plot(-1000:100:10000,finalR_5,'g');
% hold on
% plot([0,0],[-0.4,0.4],'--')
% title 'Red - 45 degree | Blocks: A = red, B = blue, C = yellow, D = mangeta, E = green'

%% Regions
figure;
img = imresize(ims{1}, [512 512]);
%img = imagesc((rad2deg(map_1))); colorbar; colormap jet;
% image(y-value, x-value)
x_values = [390:400];
y_values = [145:155];
img(y_values,x_values,:) = 0;
%img(370:470,210:310,:) = 0;
imshow(img);
drawnow;
hold on

% %rectangle('Position',[230,120,100,100],'EdgeColor','r','LineWidth',2);
% rectangle('Position',[210,370,100,100],'EdgeColor','b','LineWidth',2);
% %rectangle('Position',[125,50,100,100],'EdgeColor','g','LineWidth',2);
% rectangle('Position',[260,250,100,100],'EdgeColor','y','LineWidth',2);
% 
% title 'Map'



