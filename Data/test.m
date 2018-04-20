clc; clear all; close all;

load('reduced_bathy.mat');

Waypoints = [[repmat([Geo_WE(51), Geo_WE(451)], 1, 11)];[sort([Geo_SN(50:40:450),Geo_SN(50:40:450)])]];

[mesh_Geo_WE, mesh_Geo_SN] = meshgrid(Geo_WE, Geo_SN);

figure;
s = surf(mesh_Geo_WE, mesh_Geo_SN, depth);
s.EdgeColor = 'none';

[reduced_depth, reduced_Geo_WE, reduced_Geo_SN] = reduceResolution(depth, Geo_WE, Geo_SN, 5);

[reduced_mesh_Geo_WE, reduced_mesh_Geo_SN] = meshgrid(reduced_Geo_WE, reduced_Geo_SN);

figure; hold on;
mesh(reduced_mesh_Geo_WE, reduced_mesh_Geo_SN, reduced_depth);
plot3(Waypoints(1, :), Waypoints(2, :), zeros(1, 22), 'bo');
xlabel('WE');
ylabel('NS');
zlabel('Depth (m)');