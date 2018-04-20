clc; clear all; close all;

%% Load and reduce data
load('../reduced_bathy.mat');
load('../mission_data_05.mat');

[reduced_depth, reduced_UTM_WE, reduced_UTM_SN] = reduceResolution(depth, UTM_WE, UTM_SN, 5);

[reduced_mesh_UTM_WE, reduced_mesh_UTM_SN] = meshgrid(reduced_UTM_WE, reduced_UTM_SN);

%% Simulate

t1 = now;
[measures] = simulate_INS(ground_truth, dt);
fprintf('INS simulation time elapsed  -> %d\n', now - t1);

t1 = now;
[positions, velocities, angles] = integrateINS(init_state_vector, measures, dt);
fprintf('INS integration time elapsed -> %d\n', now - t1);

t1 = now;
[state_hat, G_hat] = dead_reckoning(init_state_vector, [angles; velocities], dt);
fprintf('Dead reckoning time elapsed  -> %d\n', now - t1);

%% Plot results

v = linspace(-50, 0, 8);

% Trajectories
figure;
contour(reduced_mesh_UTM_WE, reduced_mesh_UTM_SN, reduced_depth, v, 'ShowText','on');

figure;
contour(reduced_mesh_UTM_WE(51:100, :), reduced_mesh_UTM_SN(51:100, :), reduced_depth(51:100, :), v, 'ShowText','on');

figure; hold on;

mesh(reduced_mesh_UTM_WE, reduced_mesh_UTM_SN, reduced_depth);
plot3(Waypoints(1, :), Waypoints(2, :), zeros(1, length(Waypoints)), 'bo');
plot3(Beacons(1, :), Beacons(2, :), zeros(1, length(Beacons)), 'bd', 'LineWidth', 4);
plot3(ground_truth(1, :), ground_truth(2, :), zeros(1, length(ground_truth)), 'g', 'LineWidth', 2);
plot3(state_hat(1, :), state_hat(2, :), state_hat(3, :), 'r-.', 'LineWidth', 2);

i = 0;
for k=1:length(state_hat)
    if (mod(k,100) == 0)
        idx_G = ((k-1)*3);
        draw_ellipse(state_hat(1:2, k), G_hat(idx_G+1:idx_G+2, 1:2), 0.9, 'r', 0.3);
        
%         plot3(views((i*3)+1,:), views((i*3)+2,:), views((i*3)+3,:), 'yo');
        
        i = i + 1;
    end
end

xlabel('NS');
ylabel('SN');
zlabel('Depth (m)');
legend('Seafloor', 'Waypoints', 'Beacons', 'Ground truth', 'Dead reckoning');
title('Trajectories');

% Error comparison
figure; hold on;

deadReckoning_MSE   = sqrt( (ground_truth(2, :) - state_hat(2, :)).^2 + (ground_truth(1, :) - state_hat(1, :)).^2 );

plot(deadReckoning_MSE);

xlabel('t');
ylabel('MSE (m)');
legend('Dead reckoning');
title('Error comparison');

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

subplot(211); hold on;
plot(angles(1, :));
plot(angles(2, :));
plot(angles(3, :));
xlabel('t (s)');
ylabel('Angle (rad)');
legend('Roll', 'Pitch', 'Yaw');
title('Integrated angles')

subplot(212); hold on;
plot(velocities(1, :));
plot(velocities(2, :));
plot(velocities(3, :));
xlabel('t (s)');
ylabel('Velocity (m/s)');
legend('Vx', 'Vy', 'Vz');
title('Integrated velocities')

