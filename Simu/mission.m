clc; clear all; close all;

%% Load and reduce data
load('../Data/reduced_bathy.mat');

% Waypoints = [[UTM_WE(randi(length(UTM_WE), 1, 10))];[UTM_SN(randi(length(UTM_SN), 1, 10))]];
Waypoints = [repmat([UTM_WE(50), UTM_WE(450), UTM_WE(450), UTM_WE(50)], 1, 6);
            sort([UTM_SN(50:33.34:450), UTM_SN(50:33.34:450)])];

% length_WE = UTM_WE(450) - UTM_WE(50);
% length_SN = UTM_SN(450) - UTM_SN(50);
% 
% N = 2; % N^2 beacons // Density -> N^2 / area
% Beacons = [];
% 
% step_WE = length_WE/N;
% step_SN = length_SN/N;
% 
% for i = 0:N-1
%     for j = 0:N-1
%         Beacons = [Beacons, [randi([ceil(UTM_WE(50) + i*step_WE), floor(UTM_WE(50) + (i+1)*step_WE)]);
%                             randi([ceil(UTM_SN(50) + j*step_SN), floor(UTM_SN(50) + (j+1)*step_SN)])]];
%     end
% end


        
%% Simulate
dt = 0.5;
init_state_vector = [UTM_WE(25); UTM_SN(25); 0.0; 0.0; 0.0; 0.0];

[ground_truth, measurements, views] = simu_auv(init_state_vector, Waypoints, depth, dt);

save('../mission_data_05.mat', 'dt', 'Waypoints', 'init_state_vector', 'ground_truth', 'measurements');