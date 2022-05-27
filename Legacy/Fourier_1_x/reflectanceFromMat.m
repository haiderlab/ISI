function reflectanceFromMat(x,y,z,t,r);
% This function plots the reflectance of 1 pixel from all images in ims
% x is ims = cell array found in .mat file
% y & z are pixel coordinates ex. pi(1,2) = pi(y,z)
% t is time vector stored after saving data. You need to download the .mat 
% That's where timevec is found
% p = for resized (1) or not resized (0) image
if r == 0
    timeStep = t; % timevec is loaded in the saved bin file
    ims = x;
    pixO = zeros(1,length(ims)); % Original
    % pixR = zeros(1,length(ims)); % Resized
    
    for i = 1:length(ims)
        pixO(i) = ims{i}(y,z); % Give reflectance before resize
    end
    
    plot(timeStep,pixO);
    title('Reflectance of 1 pixel');
    xlabel('Time (sec)');
    ylabel('R - value');
end

if r == 1
    timeStep = t; % timevec is loaded in the saved bin file
    ims = x;
    %pixO = zeros(1,length(ims)); % Original
    pixR = zeros(1,length(ims)); % Resized
    
    for i = 1:length(ims)
        p = imresize(ims{i},[512 512]); % Resizing image
        pixR(i) = p(y,z); % Give reflectance after resize
        % Note that after resize, pixel coordinates change
        % Ex. B/f (1552,1976) == After (512,512
    end
    
    plot(timeStep,pixR);
    title('Reflectance of 1 pixel');
    xlabel('Time (sec)');
    ylabel('R - value');
end





