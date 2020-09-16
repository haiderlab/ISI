x1=15;
x2=150;
y1=15;
y2=150;
x = [x1, x2, x2, x1, x1];
y = [y1, y1, y2, y2, y1];
im = imread('smile.jpg');
hold on
image(im);
plot(x, y, 'r-', 'LineWidth', 1);