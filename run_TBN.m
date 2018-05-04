clc; clear all; close all;

%% Load and reduce data
load('Data/reduced_bathy.mat');
load('Data/mission_data_05.mat');

[reduced_depth, reduced_UTM_WE, reduced_UTM_SN] = reduceResolution(depth, UTM_WE, UTM_SN, 5);

[reduced_mesh_UTM_WE, reduced_mesh_UTM_SN] = meshgrid(reduced_UTM_WE, reduced_UTM_SN);

%% Simulate INS

tic;
[measures] = simulate_INS(ground_truth, dt);
fprintf('INS simulation time elapsed  -> %d\n', toc);

tic;
[positions, velocities, angles] = integrateINS(init_state_vector, measures, dt);
fprintf('INS integration time elapsed -> %d\n', toc);

%% Methods comparison

% Dead reckoning

kalman_state_vector = init_state_vector(1:3);

tic;
[state_hat, G_hat] = dead_reckoning(kalman_state_vector, [angles; velocities], dt, []);
fprintf('Dead reckoning time elapsed  -> %d\n', toc);

dRG_MSE = sqrt( (ground_truth(1, :) - state_hat(1, :)).^2 + (ground_truth(2, :) - state_hat(2, :)).^2 + (ground_truth(3, :) - state_hat(3, :)).^2 );

% Errors vectors
tic;
TBN_MSE = [];
t_TBN = [];
N = [];


for i = 2
    % Number of beacons in the area
    n = i;
    N = [N, n];
    
    TBN_MSE_tmp = [];
    t_tmp = [];
    
    for j = 1:2
        
        disp(['i = ', num2str(i),' | j = ', num2str(j)]);
        
        start_loop = toc;
        
        [Beacons, views] = generateViewsTBN(n, UTM_WE, UTM_SN, ground_truth);
        
%         kalman_state_vector = [init_state_vector(1:3); reshape(Beacons, 2*length(Beacons), 1)];

        kalman_state_vector = init_state_vector(1:3);
        
        start_kalman = toc;
        [state_hat_tbn, G_hat_tbn] = dead_reckoning(kalman_state_vector, [angles; velocities], dt, views, Beacons);
        t_tmp = [t_tmp, toc - start_kalman];

        TBN_MSE_tmp = [TBN_MSE_tmp; sqrt( (ground_truth(1, :) - state_hat_tbn(1, :)).^2 + (ground_truth(2, :) - state_hat_tbn(2, :)).^2 + (ground_truth(3, :) - state_hat_tbn(3, :)).^2 )];
        
        disp(['Time elapsed for this loop -> ', num2str(toc - start_loop)]);
    end
    
    t_tmp = mean(t_tmp);
    TBN_MSE_tmp = mean(TBN_MSE_tmp);
    
    t_TBN = [t_TBN, t_tmp];
    TBN_MSE = [TBN_MSE; TBN_MSE_tmp];
    
end

%% Plot results

% Trajectories

figure; hold on;

mesh(reduced_mesh_UTM_WE, reduced_mesh_UTM_SN, reduced_depth);
plot3(Waypoints(1, :), Waypoints(2, :), zeros(1, length(Waypoints)), 'bo');
plot3(Beacons(1, :), Beacons(2, :), zeros(1, length(Beacons)), 'bd', 'LineWidth', 4);
plot3(ground_truth(1, :), ground_truth(2, :), zeros(1, length(ground_truth)), 'g', 'LineWidth', 2);
plot3(state_hat(1, :), state_hat(2, :), state_hat(3, :), 'r-.', 'LineWidth', 2);
plot3(state_hat_tbn(1, :), state_hat_tbn(2, :), state_hat_tbn(3, :), 'b-.', 'LineWidth', 2);

for k=1:length(views)
        plot([views(5, k); views(7, k)], [views(6, k); views(8, k)], 'r', 'LineWidth', 2);
end

i = 0;
for k=1:length(state_hat)
    if (mod(k,100) == 0)
        idx_G = ((k-1)*3);
        
        draw_ellipse(state_hat(1:2, k), G_hat(idx_G+1:idx_G+2, 1:2), 0.9, 'r', 0.3);
        draw_ellipse(state_hat_tbn(1:2, k), G_hat_tbn(idx_G+1:idx_G+2, 1:2), 0.9, 'b', 0.3);
        
        i = i + 1;
    end
end

xlabel('NS');
ylabel('SN');
zlabel('Depth (m)');
legend('Seafloor', 'Waypoints', 'Beacons', 'Ground truth', 'Dead reckoning', 'TBN', 'Views');
title('Trajectories');

% % Error comparison
figure; hold on;

% plot(dRG_MSE);

for k = 1:size(TBN_MSE, 1)
    plot(TBN_MSE(k, :));
end

xlabel('t');
ylabel('MSE (m)');
% legend('Dead reckoning', 'TBN');
title('Error comparison');

% % INS Simulation
% figure;
% 
% subplot(121); hold on;
% plot(measures(1, :));
% plot(measures(2, :));
% plot(measures(3, :));
% xlabel('t (s)');
% ylabel('Angular velocity (rad/s)');
% legend('Roll axis', 'Pitch axis', 'Yaw axis');
% 
% subplot(122); hold on;
% plot(measures(4, :));
% plot(measures(5, :));
% plot(measures(6, :));
% xlabel('t (s)');
% ylabel('Linear acceleration (m/s)');
% legend('x axis', 'y axis', 'z axis');
% 
% % Reconstruted data
% figure;
% 
% subplot(211); hold on;
% plot(angles(1, :));
% plot(angles(2, :));
% plot(angles(3, :));
% xlabel('t (s)');
% ylabel('Angle (rad)');
% legend('Roll', 'Pitch', 'Yaw');
% title('Integrated angles')
% 
% subplot(212); hold on;
% plot(velocities(1, :));
% plot(velocities(2, :));
% plot(velocities(3, :));
% xlabel('t (s)');
% ylabel('Velocity (m/s)');
% legend('Vx', 'Vy', 'Vz');
% title('Integrated velocities')

