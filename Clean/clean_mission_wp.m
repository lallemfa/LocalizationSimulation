clc; clear all; close all;

%% Load and reduce data
load('../Data/reduced_bathy.mat');

[mesh_UTM_WE, mesh_UTM_SN] = meshgrid(UTM_WE, UTM_SN);

dim = length(UTM_WE)*length(UTM_SN);

cloud = [reshape(mesh_UTM_WE, 1, dim); reshape(mesh_UTM_SN, 1, dim); reshape(depth, 1, dim)];

[reduced_depth, reduced_UTM_WE, reduced_UTM_SN] = reduceResolution(depth, UTM_WE, UTM_SN, 5);
[reduced_mesh_UTM_WE, reduced_mesh_UTM_SN] = meshgrid(reduced_UTM_WE, reduced_UTM_SN);

Waypoints = [repmat([UTM_WE(50), UTM_WE(450), UTM_WE(450), UTM_WE(50)], 1, 6);
            sort([UTM_SN(50:33.34:450), UTM_SN(50:33.34:450)])];

%% Beacons generation

N = 200;

Beacons = [1:N;
            randi([ceil(UTM_WE(50)), floor(UTM_WE(450))], 1, N);
            randi([ceil(UTM_SN(50)), floor(UTM_SN(450))], 1, N)];

%% Simulate
dt = 0.5;
init_state_vector = [UTM_WE(25); UTM_SN(25); 0.0; 0.0; 0.0; 0.0];

[ground_truth] = simu_auv(init_state_vector, Waypoints, dt);

[views] = generateViews(ground_truth, Beacons, UTM_WE, UTM_SN, cloud);

save('../clean_mission_data.mat', 'dt', 'Waypoints', 'init_state_vector', 'ground_truth', 'Beacons', 'views');

%% Plot mission

figure; hold on;

mesh(reduced_mesh_UTM_WE, reduced_mesh_UTM_SN, reduced_depth);
plot3(Waypoints(1, :), Waypoints(2, :), zeros(1, length(Waypoints)), 'bo');
plot3(Beacons(2, :), Beacons(3, :), zeros(1, length(Beacons)), 'bd', 'LineWidth', 4);
plot3(ground_truth(1, :), ground_truth(2, :), zeros(1, length(ground_truth)), 'g', 'LineWidth', 2);

for k=1:length(views)
    if (mod(k,40) == 0)
        view = views(k);
        plot3(view.cloud(3, :), view.cloud(4, :), view.cloud(5, :), 'r.');
        if ~isempty(view.beacon)
            plot([view.beacon(5,:); view.beacon(7,:)], [view.beacon(6,:); view.beacon(8,:)], 'r', 'LineWidth', 2);
        end
    end
end



xlabel('NS');
ylabel('SN');
zlabel('Depth (m)');
legend('Seafloor', 'Waypoints', 'Beacons', 'Ground truth');
title('Trajectories');
