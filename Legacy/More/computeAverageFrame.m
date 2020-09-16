% This function takes frames from ims and create an average frame 
function avgFrame = computeAverageFrame(ims)
% resizing all frames
resizeImage = {};
orgImage = ims;
for i = 1:length(ims)
    pImage = imresize(orgImage{i}, [512 512]);
    resizeImage{i} = pImage;
end

% Computing the average 
sumImage = double(resizeImage{1});
for i = 2:length(resizeImage)
    sumImage = sumImage + double(resizeImage{i}) ;
    
end

% Adjust for onset
avgFrame = (sumImage/length(resizeImage)) - double(resizeImage{1});








