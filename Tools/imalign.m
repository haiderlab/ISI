function [moved, fixed, combined] = imalign(moving, fixed)
% Aligns a moving image to a fixed image and returns the aligned images as
% well as a combined image (one overlaid on the other). Enables the user to
% crop the aligned images. Images are also written as JPG files.

    %% Convert to grayscale if necessary
    [~, ~, numberOfColorChannels] = size(fixed);
    if numberOfColorChannels > 1
        fixed = rgb2gray(fixed);
    end
    [~, ~, numberOfColorChannels] = size(moving);
    if numberOfColorChannels > 1
        moving = rgb2gray(moving);
    end

    %% Control Points
    [selectedMovingPoints, selectedFixedPoints] = cpselect(moving, fixed,'Wait',true);

    %% Fit geometric transformation to control point pairs
    tform = fitgeotrans(selectedMovingPoints, selectedFixedPoints, 'nonreflectivesimilarity');
    outputView = imref2d(size(fixed)); %spatial referencing obj used to specify world coordinate system of fixed image
    moved = imwarp(moving, tform, 'OutputView', outputView); %OutputView lets you see transformed image in same relation to origin as fixed
    
    %% Fuse
    combined = imfuse(moved, fixed);
    
    %% Crop moved image
    uiwait(msgbox('Please click and drag a region to crop, then right click and select "Crop Image"'))
    figure
    [combined, rect] = imcrop(combined); %note gray space will be added when crop region goes over image boundary
    moved = imcrop(moved, rect);
    fixed = imcrop(fixed, rect);
        
    %% Save images as JPG files
    imwrite(moved, 'align_moved.jpg');
    imwrite(fixed, 'align_fixed.jpg');
    imwrite(combined, 'align_combined.jpg');
end