init;
Mx = -1:0.1:1; My = -1:0.1:1;
[X,Y] = meshgrid(Mx,My);
GX=Y; GY=X;
quiver(Mx,My,GX,GY,'black');

figure(2) 
Z = X.*Y;
%Z=2*X.^2+X.*Y+4*Y.^2+Y-X+3;
contour3(X,Y,Z,20,'black');
surface(X,Y,Z);
grid off
view(-15,25)
