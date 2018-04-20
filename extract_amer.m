clc; clear all; close all;

%% Load and reduce data
load('reduced_bathy.mat');

[reduced_depth, reduced_UTM_WE, reduced_UTM_SN] = reduceResolution(depth, UTM_WE, UTM_SN, 5);

reduced_UTM_WE = reduced_UTM_WE - min(reduced_UTM_WE);
reduced_UTM_SN = reduced_UTM_SN - min(reduced_UTM_SN);

[reduced_mesh_UTM_WE, reduced_mesh_UTM_SN] = meshgrid(reduced_UTM_WE, reduced_UTM_SN);

[fx,fy] = gradient(reduced_depth,0.2);

% Trajectories
figure; hold on;

mesh(reduced_mesh_UTM_WE, reduced_mesh_UTM_SN, reduced_depth);
quiver(reduced_mesh_UTM_WE, reduced_mesh_UTM_SN, fx, fy);
plot3([reduced_mesh_UTM_WE(1470), reduced_mesh_UTM_WE(1698), reduced_mesh_UTM_WE(7657)], [reduced_mesh_UTM_SN(1470), reduced_mesh_UTM_SN(1698), reduced_mesh_UTM_SN(7657)], [reduced_depth(1470), reduced_depth(1698), reduced_depth(7657)], 'ro');