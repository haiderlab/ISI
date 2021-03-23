function [GLout RLout] = resizeISI(GLin, RLin)

vec = findsize(GLin(:,:,1),RLin(:,:,1));

GLout = GLin(vec(3):vec(3)+vec(1)-1, vec(4):vec(4)+vec(2)-1, 1);
RLout = RLin(vec(5):vec(5)+vec(1)-1, vec(6):vec(6)+vec(2)-1, :);

end
