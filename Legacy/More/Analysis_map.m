% Analysis from online 
%% Array of images  & Period
resizeImage = {};
for i = 1:length(ims)
    img = double (imresize(ims{i}, [512 512]));
    resizeImage{i} = img;
end
resizeImage = cat(3,resizeImage{:});
% Time vector
t = linspace(0,(max(timeStimReal)-min(timeStimReal))/1000,length(timeStim));
tt = linspace(min(timeStimReal),max(timeStimReal),length(timeStim));
% Finding indexes from when Phothodiode is rising 
% Finding period
threshold = 3.5;
bars = find(abs(diff(timeStim > threshold)')>0);
barsON = bars(1:2:end);   
tt_trans = tt';
timeF = tt_trans(barsON(1));
period = (tt_trans(barsON(4))- tt_trans(barsON(3)));

%% Find frames during stimulus
frames_stim_idx = [];
for yy = 1:length(barsON)
    frames_stim_idx(yy) =  FindIndexCloseTo(timevecReal, (tt_trans(barsON(yy))));
end

% Frame sampling time (sec) & Phase
indx_Time_vec = find(timevecReal>timevecReal(frames_stim_idx(1)) & timevecReal<timevecReal(frames_stim_idx(end)));
frameST = (timevecReal(indx_Time_vec) - timevecReal(1))/1000;
% Time in sec of 
frameAngle = frameST/period*2*pi;

%% Computing Map
k = 1;
for ii = indx_Time_vec(1):indx_Time_vec(end)
    ii
    img = 4096 - resizeImage(:,:,ii);
    
    if ii == indx_Time_vec(1)
        acc = zeros(size(img));
    end
    acc = acc + exp(1i*frameAngle(k)).*img;
    k = k+1;
end

FO = 4096 - mean(resizeImage(:,:,indx_Time_vec(1):indx_Time_vec(2)),3);
%acc = acc - FO*sum(exp(1i*frameAngle));
%acc = 2*acc ./(k-1);

figure;
imagesc(rad2deg(angle(2*acc))); colorbar; 
title('Forward map');































