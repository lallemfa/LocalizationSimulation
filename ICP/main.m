clc; close all; clear all;

%%

m = 80; % width of grid
n = m^2; % number of points

% [X,Y] = meshgrid(linspace(-2,2,m), linspace(-2,2,m));
% 
% X = reshape(X,1,[]);
% Y = reshape(Y,1,[]);
% 
% Z = perlin2D(80);
% Z = reshape(Z,1,[]);

[X_surf, Y_surf, Z_surf] = peaks(m);

X = reshape(X_surf, 1, []);
Y = reshape(Y_surf, 1, []);
Z = reshape(Z_surf, 1, []);

D = [X; Y; Z];

% Translation values (a.u.):
Tx = rand() - 1;
Ty = rand() - 1;
Tz = rand() - 1;

% Translation vector
T = [Tx; Ty; Tz];

% Rotation values (rad.):
rx = rand() - 1;
ry = rand() - 1;
rz = rand() - 1;

Rx = [1 0 0;
      0 cos(rx) -sin(rx);
      0 sin(rx) cos(rx)];
  
Ry = [cos(ry) 0 sin(ry);
      0 1 0;
      -sin(ry) 0 cos(ry)];
  
Rz = [cos(rz) -sin(rz) 0;
      sin(rz) cos(rz) 0;
      0 0 1];

% Rotation matrix
R = Rx*Ry*Rz;

% Transform data-matrix plus noise into model-matrix 
M = R * D + repmat(T, 1, n);

%%
[Ricp, Ticp, ER, t] = icp(D, M, 15);

Dicp = Ricp * M + repmat(Ticp, 1, n);

figure; 
subplot(121); hold on;
plot3(D(1,:),D(2,:),D(3,:),'bo');
plot3(M(1,:),M(2,:),M(3,:),'ro');

subplot(122); hold on;
plot3(D(1,:),D(2,:),D(3,:),'bo');
plot3(Dicp(1,:),Dicp(2,:),Dicp(3,:),'gd');


R - Ricp

T - Ticp
