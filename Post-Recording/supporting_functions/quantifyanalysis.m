function [area, com_loc] = quantifyanalysis(map,val)

A = map == val;
%figure;imshow(A,[]);
% Method 1, using mean
x = 1 : size(A, 2); % Columns.
y = 1 : size(A, 1); % Rows.
[X, Y] = meshgrid(x, y);
meanA = mean(A(:));
centerOfMassX = mean(A(:) .* X(:)) / meanA;
centerOfMassY = mean(A(:) .* Y(:)) / meanA;
% Method 2: using regionprops
props = regionprops(true(size(A)), A, 'WeightedCentroid');

area = sum(sum(A));
com_loc = [round(centerOfMassX),round(centerOfMassY)];

end