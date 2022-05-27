% Display results
function feedback(ims)
initNum = 0;
tmp = {};
for kk = 1:5
    initNum = initNum + 40;
    tt = {};
    for ii = 0:200:length(ims)
        num1 = ii + initNum;
        if num1 <= length(ims)-2
            interv = [num1-2:num1+2]; 
            tt = [tt ims(interv)];
        end
    end
        tmp{kk} = tt;
        tt = {};
end
figure;
%subplot(3,3,1),imshow(computeAverageFrame(tmp{1}),[]),title('At 36 degrees')
% or below
subplot(3,3,1),imagesc(computeAverageFrame(tmp{1})),title('At 36 degrees')
subplot(3,3,2),imagesc(computeAverageFrame(tmp{2})),title('At 72 degrees')
subplot(3,3,3),imagesc(computeAverageFrame(tmp{3})),title('At 108 degrees')
subplot(3,3,4),imagesc(computeAverageFrame(tmp{4})),title('At 144 degrees')
subplot(3,3,5),imagesc(computeAverageFrame(tmp{5})),title('At 180 degrees')
subplot(3,3,6),imagesc(computeAverageFrame(tmp{2}) - computeAverageFrame(tmp{1})),title('72-36 degrees')
subplot(3,3,7),imagesc(computeAverageFrame(tmp{3}) - computeAverageFrame(tmp{2})),title('108-72 degrees')
subplot(3,3,8),imagesc(computeAverageFrame(tmp{4}) - computeAverageFrame(tmp{3})),title('144-108 degrees')
subplot(3,3,9),imagesc(computeAverageFrame(tmp{5}) - computeAverageFrame(tmp{4})),title('180-144 degrees')
end



