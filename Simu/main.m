clc; clear all; close all;

%% Load and reduce data
load('../reduced_bathy.mat');

% Waypoints = [[UTM_WE(randi(length(UTM_WE), 1, 10))];[UTM_SN(randi(length(UTM_SN), 1, 10))]];
Waypoints = [repmat([UTM_WE(50), UTM_WE(450), UTM_WE(450), UTM_WE(50)], 1, 6);
            sort([UTM_SN(50:36.3636:450), UTM_SN(50:36.3636:450)])];

[reduced_depth, reduced_UTM_WE, reduced_UTM_SN] = reduceResolution(depth, UTM_WE, UTM_SN, 5);

[reduced_mesh_UTM_WE, reduced_mesh_UTM_SN] = meshgrid(reduced_UTM_WE, reduced_UTM_SN);

%% Simulate
dt = 0.1;
init_state_vector = [UTM_WE(15); UTM_SN(15); 0.0; 0.0; 0.0; 0.0];

[ground_truth, measurements] = simu_auv(init_state_vector, Waypoints, dt);

[state_hat, G_hat] = dead_reckoning(init_state_vector, measurements, dt);

[measures] = simulate_INS(ground_truth, dt);

[positions, velocities, angles] = integrateINS(init_state_vector, measures, dt);

%% Plot results

% Trajectories
figure; hold on;

mesh(reduced_mesh_UTM_WE, reduced_mesh_UTM_SN, reduced_depth);
plot3(Waypoints(1, :), Waypoints(2, :), zeros(1, length(Waypoints)), 'bo');
plot3(ground_truth(1, :), ground_truth(2, :), zeros(1, length(ground_truth)), 'g', 'LineWidth', 2);
plot3(state_hat(1, :), state_hat(2, :), state_hat(3, :), 'r-.', 'LineWidth', 2);

for k=1:length(state_hat)
    if (mod(k,20) == 0)
        idx_G = ((k-1)*3);
        draw_ellipse(state_hat(1:2, k), G_hat(idx_G+1:idx_G+2, 1:2), 0.9, 'r', 0.3);         
    end
end

xlabel('NS');
ylabel('SN');
zlabel('Depth (m)');
legend('Seafloor', 'Waypoints', 'Ground truth', 'Dead reckoning', 'SLAM');
title('Trajectories');

% Error comparison
% figure; hold on;
% 
% deadReckoning_MSE = sqrt( (ground_truth(2, :) - state_hat(2, :)).^2 + (ground_truth(1, :) - state_hat(1, :)).^2 );
% 
% plot(deadReckoning_MSE);
% 
% xlabel('t');
% ylabel('MSE (m)');
% legend('Dead reckoning');
% title('Error comparison');

% INS Simulation
figure;

subplot(121); hold on;
plot(measures(1, :));
plot(measures(2, :));
plot(measures(3, :));
xlabel('t (s)');
ylabel('Angular velocity (rad/s)');
legend('Roll axis', 'Pitch axis', 'Yaw axis');

subplot(122); hold on;
plot(measures(4, :));
plot(measures(5, :));
plot(measures(6, :));
xlabel('t (s)');
ylabel('Linear acceleration (m/s)');
legend('x axis', 'y axis', 'z axis');

% Reconstruted data
figure;

subplot(121); hold on;
plot(angles(1, :));
plot(angles(2, :));
plot(angles(3, :));
xlabel('t (s)');
ylabel('Angle (rad)');
legend('Roll', 'Pitch', 'Yaw');
title('Integrated angles')

subplot(122); hold on;
plot(velocities(1, :));
plot(velocities(2, :));
plot(velocities(3, :));
xlabel('t (s)');
ylabel('Velocity (m/s)');
legend('Vx', 'Vy', 'Vz');
title('Integrated velocities')

