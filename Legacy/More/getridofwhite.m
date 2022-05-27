function [outpic,rowind,colind] = getridofwhite(pic)
%% get rid of all white lines in column
[row,col] = size(pic);

temp = sum(pic,1);
mask = temp == row * 255; 
index = find(mask);

if ~isempty(index)
    if index(1) ~= 1
      index = [1 index]; 
    end
else
    index = 1;
end
if index(end) ~= col
    index = [index col];
end

temp2 = diff(index);
[~,ind] = max(temp2);
newpic = pic(:,index(ind):index(ind+1));

colind = index(ind)-1;
%% get rid of all white lines in column 
[row,col] = size(newpic);

temp = sum(newpic,2);
mask = temp == col * 255; 
index = find(mask);
if ~isempty(index)
    if index(1) ~= 1
       index = [1 ;index]; 
    end
else
    index = 1;
end
if index(end) ~= row
    index = [index ;row];
end

temp2 = diff(index);
[~,ind] = max(temp2);
newpic2 = newpic(index(ind):index(ind+1),:);

rowind = index(ind)-1;


outpic = newpic2;

%figure;
%subplot(1,2,1);imshow(output,[]);
%subplot(1,2,2);imshow(pic,[]);
end