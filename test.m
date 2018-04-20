clc; clear all; close all;

bathy = peaks(100);

x = 0:99;
y = 0:99;

[X, Y] = meshgrid(x, y);

bathy = reshape(bathy,[100,100]);

i = -10:10;
j = -5:5;

[I, J] = meshgrid(i, j);
view = [reshape(I,[1,231]); reshape(J,[1,231]); zeros(1, 231)];

theta = pi/4;

R = [cos(theta) sin(theta);
    -sin(theta) cos(theta)];

trans_x = 50;
trans_y = 50;

view = [R*view(1:2, :); view(3, :)] + [trans_x; trans_y; 0];

for k=1:length(view)
    view(3, k) = bathy(floor(view(1, k)), floor(view(2, k))) + 1;
end


figure; hold on;
surf(X, Y, bathy);
plot3(view(1, :), view(2, :), view(3, :), 'r.');

view = [R\view(1:2, :); view(3, :)];

figure;
plot3(view(1, :), view(2, :), view(3, :), 'r.');

figure;
contour(I, J, reshape(view(3, :),[11,21]));