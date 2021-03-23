function sizevec = findsize(GLin, RLin)
% sizevec = [row_length, col_length, GL_rowstart, GL_colstart, RL_rowstart, RL_colstart]

sizevec = zeros(1,6);


[GL,GLrow,GLcol] = getridofwhite(GLin);
[RL,RLrow,RLcol] = getridofwhite(RLin);
%plotimgs(GL,RL);


%% Using L2 distance to find the appropriate match of the photo of all pictures
[row1,col1] = size(RL);
[row2,col2] = size(GL);

sizevec(1) = min(row1,row2);
sizevec(2) = min(col1,col2);

rowdiff = abs(row1-row2);
coldiff = abs(col1-col2);
L2distvec = zeros(rowdiff+1,coldiff+1);

for j = 1:rowdiff+1
    if row1 >row2
        RLtemp1= RL(j:row2+j-1,:);
        GLtemp1 =GL;
    else
        GLtemp1= GL(j:row1+j-1,:);
        RLtemp1 =RL;    
    end
    for i = 1: coldiff+1
        if col1 >col2
            RLtemp2= RLtemp1(:,i:col2+i-1);
            GLtemp2 =GLtemp1;
        else
            GLtemp2= GLtemp1(:,i:col1+i-1);
            RLtemp2 =RLtemp1;
        end
        L2dist_temp = sum(sum((RLtemp2 - GLtemp2).^2));
        L2distvec(j,i) = L2dist_temp;
    end
end

%%
i = 1; j= 1;
if rowdiff ~= 0
    [L2distvec,j] = min(L2distvec);
end
if coldiff ~= 0
    [~,i] = min(L2distvec);
end

j = j(1);

%%
if row1 >row2
    RLtemp1= RL(j:row2+j-1,:);
    GLtemp1 =GL;
    
    sizevec(3) = 1;
    sizevec(5) = j;
else
    GLtemp1= GL(j:row1+j-1,:);
    RLtemp1 =RL;   
    
    sizevec(3) = j;
    sizevec(5) = 1;
end

if col1 >col2
    RLtemp2= RLtemp1(:,i:col2+i-1);
    GLtemp2 =GLtemp1;
    
    sizevec(4) = 1;
    sizevec(6) = i;
else
    GLtemp2= GLtemp1(:,i:col1+i-1);
    RLtemp2 =RLtemp1;
    
    sizevec(4) = i;
    sizevec(6) = 1;
end

RL_new = RLtemp2;
GL_new = GLtemp2;


%%

sizevec(3) = sizevec(3) + GLrow;
sizevec(4) = sizevec(4) + GLcol;
sizevec(5) = sizevec(5) + RLrow;
sizevec(6) = sizevec(6) + RLcol;



%%
%plotimgs(GL_new,RL_new);



end