function plotimgs(GL_new,RL_new)
figure
subplot(1,2,1);imshow(GL_new,[]);
title('Image taken with Green Light');

subplot(1,2,2);imshow(RL_new,[]);
title('Image taken with Red Light');

end