function [GLout, RLout] = alignGLRL(GLin, RLin)
% Align GL and RL without changing size of GL 

zpad = 50; %how many zeros do you want to pad?

GL =  padarray(GLin(:,:,1),[zpad zpad],255,'both');%GLrow = 1;GLcol = 1;%[GL,GLrow,GLcol] = getridofwhite(GLin);
RL = RLin(:,:,1);

[sizeGL(1),sizeGL(2)] = size(GL); % 1- row size with padding , 2-col size with padding
[sizeRL(1),sizeRL(2)] = size(RL); % 1- row size with padding , 2-col size with padding


GL_norm = GL - nanmean(nanmean(GL));
RL_norm = RL - mean(mean(RL));
%[RL,RLrow,RLcol] = getridofwhite(RLin);


c = conv2(GL_norm,rot90(conj(RL_norm),2),'valid'); % c = result of 2D-xcorr
%figure;imagesc(c);colorbar; colormap jet

[row,col] = find(c == max(max(c)));
%%
RL_padded = padarray(RLin,[row-1 col-1],255,'pre');
RL_padded = padarray(RL_padded,[sizeGL(1)-(sizeRL(1)+row-1) sizeGL(2)-(sizeRL(2)+col-1)],255,'post');
%figure;imshow(GL,[]);figure;imshow(RL_padded(:,:,1),[])

RLout = RL_padded(zpad+1:end-zpad,zpad+1:end-zpad,:);
GLout = GLin;




end