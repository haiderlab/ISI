function [moved, fixed, combined] = imalign(moving, fixed)
% Aligns a moving image to a fixed image and returns the aligned images as
% well as a combined image (one overlaid on the other). Enables the user to
% crop the aligned images. Images are also written as JPG files.
% 
% Usage steps:
% 1. Call the function with two images: moving (the image to move to align
% with the fixed image) and fixed (the image that will stay in the same
% position).
% 2. Select control points (points on the images that correspond to each
% other and will be used for alignment) by alternating between clicking on
% the fixed and moving images so that corresponding points have the same
% number. Exit out of the control point selection tool when finished.
% 3. Optional: choose whether or not to show the selected control points as
% red dots on the output images.
% 4. Optional: crop the image by clicking and dragging to select the
% cropping region. Then right click and select "Crop Image".
% 5. Optional: add yellow circles to the image by dragging and resizing
% them into the correct position. Double click the circle once it is
% positioned correctly. You will then be prompted if you'd like to add more
% circles.

    %% Convert to grayscale if necessary
    [~, ~, numberOfColorChannels] = size(fixed);
    if numberOfColorChannels > 1
        fixed = rgb2gray(fixed);
    end
    [~, ~, numberOfColorChannels] = size(moving);
    if numberOfColorChannels > 1
        moving = rgb2gray(moving);
    end

    %% Control points
    [selectedMovingPoints, selectedFixedPoints] = cpselect(moving, fixed,'Wait',true);

    %% Fit geometric transformation to control point pairs
    shouldAddControlPoints = questdlg({'Would you like to add red marks at the selected control points to the images?'},'Add Control Points Prompt','No','Yes','No');
    if strcmp('Yes',shouldAddControlPoints)
        shape = 'FilledCircle';
        fractionOfImage = 1/150;
        color = 'red';
        
        % moving - determine shape positions
        [ny,nx,~] = size(moving);
        radius = round(min([nx ny])*fractionOfImage);
        radiusCol = zeros(size(selectedMovingPoints,1),1);
        radiusCol(:) = radius;
        movingShapePositions = [selectedMovingPoints radiusCol];
        
        % fixed - determine shape positions
        [ny,nx,~] = size(fixed);
        radius = round(min([nx ny])*fractionOfImage);
        radiusCol = zeros(size(selectedFixedPoints,1),1);
        radiusCol(:) = radius;
        fixedShapePositions = [selectedFixedPoints radiusCol];
        
        % insert shapes
        moving = insertShape(moving, shape, movingShapePositions, 'Color', color);
        fixed = insertShape(fixed, shape, fixedShapePositions, 'Color', color);
    end
    
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
    
    %% Add yellow circle
    optionYesOverwrite = 'Yes - Overwrite Existing JPG Images';
    optionYesNew = 'Yes - Use New JPG Images ("_circle" filename)';
    shouldAddCircle = questdlg({'Would you like to add a circle to the images?', 'If yes, position the circle and double click to confirm position.'},'Add Circle Prompt','No',optionYesOverwrite,optionYesNew,'No');
    if strcmp(optionYesOverwrite,shouldAddCircle) || strcmp(optionYesNew,shouldAddCircle)
        figure
        imshow(combined);
        [ny,nx,~] = size(combined);
        combinedCenter = round([nx ny]/2);
        radius = round(min([nx ny])/6);
        hROI = drawcircle('Center',combinedCenter,'Radius',radius,'Color','y');
        try
            position = customWait(hROI);
            shape = 'FilledCircle';
            combinedWithCircle = insertShape(combined, shape, position);
            movedWithCircle = insertShape(moved, shape, position);
            fixedWithCircle = insertShape(fixed, shape, position);
            
            % Ask if add another circle
            shouldAddAnotherCircle = questdlg({'Would you like to add another circle to the images?', 'If yes, position the circle and double click to confirm position.'},'Add Circle Prompt','No','Yes','No');
            while strcmp('Yes',shouldAddAnotherCircle)
                imshow(combinedWithCircle);
                [ny,nx,~] = size(combined);
                combinedCenter = round([nx ny]/2);
                radius = round(min([nx ny])/6);
                hROI = drawcircle('Center',combinedCenter,'Radius',radius,'Color','y');
                try
                    position = customWait(hROI);
                    shape = 'FilledCircle';
                    combinedWithCircle = insertShape(combinedWithCircle, shape, position);
                    movedWithCircle = insertShape(movedWithCircle, shape, position);
                    fixedWithCircle = insertShape(fixedWithCircle, shape, position);
                catch
                    uiwait(msgbox('An error occurred - circle deleted'));
                end
                shouldAddAnotherCircle = questdlg({'Would you like to add another circle to the images?', 'If yes, position the circle and double click to confirm position.'},'Add Circle Prompt','No','Yes','No');
            end
            
            % Write JPG images
            if strcmp(optionYesNew,shouldAddCircle)
                imwrite(movedWithCircle, 'align_moved_circle.jpg');
                imwrite(fixedWithCircle, 'align_fixed_circle.jpg');
                imwrite(combinedWithCircle, 'align_combined_circle.jpg');
            elseif strcmp(optionYesOverwrite,shouldAddCircle)
                imwrite(movedWithCircle, 'align_moved.jpg');
                imwrite(fixedWithCircle, 'align_fixed.jpg');
                imwrite(combinedWithCircle, 'align_combined.jpg');
            end
        catch
            uiwait(msgbox('An error occurred - circle deleted'));
        end
    end
    
end

function position = customWait(hROI)
% Waits for user to double click circle ROI before returning its position
    l = addlistener(hROI, 'ROIClicked', @clickCallback);
    uiwait;
    delete(l);
    position = [hROI.Center hROI.Radius];
end
    
function clickCallback(~,evt)
% Resumes program execution when you double-click the circle ROI
    if strcmp(evt.SelectionType,'double')
        uiresume;
    end
end