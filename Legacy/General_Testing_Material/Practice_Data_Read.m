load('C:\neurodata\AnalyzerFiles_new\xx0\u000_000\48s_00000\000')
tic
for i=1:length(ims)
    imshow(ims{i})
end
toc

%% 
for j = 1:length(ims)
    
    imwrite(ims{j},sprintf('im_test_%d.jpg',timevec(j)))
    
end