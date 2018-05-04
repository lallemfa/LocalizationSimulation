clc; clear all; close all;

%% Load and reduce data
load('Data/reduced_bathy.mat');
load('Data/mission_data_05.mat');

[mesh_UTM_WE, mesh_UTM_SN] = meshgrid(UTM_WE, UTM_SN);

dim = length(UTM_WE)*length(UTM_SN);

cloud = [reshape(mesh_UTM_WE, 1, dim), reshape(mesh_UTM_SN, 1, dim), reshape(depth, 1, dim)];

[reduced_depth, reduced_UTM_WE, reduced_UTM_SN] = reduceResolution(depth, UTM_WE, UTM_SN, 5);
[reduced_mesh_UTM_WE, reduced_mesh_UTM_SN] = meshgrid(reduced_UTM_WE, reduced_UTM_SN);

[views] = generateViewsICP(ground_truth, UTM_WE, UTM_SN, cloud);

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
ICP_MSE = [];
ICP_t = [];


for i = 2
    
    ICP_MSE_tmp = [];
    t_tmp = [];
    
    for j = 1
        
        disp(['i = ', num2str(i),' | j = ', num2str(j)]);
        
        start_loop = toc;
        
        [views] = generateViewsICP(ground_truth, reduced_UTM_WE, reduced_UTM_SN, reduced_cloud);
        
        kalman_state_vector = init_state_vector(1:3);
        
        start_kalman = toc;
        [state_hat_icp, G_hat_icp] = dead_reckoning(kalman_state_vector, [angles; velocities], dt, views, []);
        t_tmp = [t_tmp, toc - start_kalman];

        ICP_MSE_tmp = [ICP_MSE_tmp; sqrt( (ground_truth(1, :) - state_hat_icp(1, :)).^2 + (ground_truth(2, :) - state_hat_icp(2, :)).^2 + (ground_truth(3, :) - state_hat_icp(3, :)).^2 )];
        
        disp(['Time elapsed for this loop -> ', num2str(toc - start_loop)]);
        
    end
    
    t_tmp = mean(t_tmp);
    ICP_MSE_tmp = mean(ICP_MSE_tmp);
    
    ICP_t = [ICP_t, t_tmp];
    ICP_MSE = [ICP_MSE; ICP_MSE_tmp];
    
end

%% Plot results

% Trajectories

figure; hold on;

mesh(reduced_mesh_UTM_WE, reduced_mesh_UTM_SN, reduced_depth);
plot3(Waypoints(1, :), Waypoints(2, :), zeros(1, length(Waypoints)), 'bo');
plot3(ground_truth(1, :), ground_truth(2, :), zeros(1, length(ground_truth)), 'g', 'LineWidth', 2);
plot3(state_hat(1, :), state_hat(2, :), state_hat(3, :), 'r-.', 'LineWidth', 2);
plot3(state_hat_icp(1, :), state_hat_icp(2, :), state_hat_icp(3, :), 'b-.', 'LineWidth', 2);

i = 0;
for k=1:length(state_hat)
    if (mod(k,100) == 0)
        idx_G = ((k-1)*3);
        
        draw_ellipse(state_hat(1:2, k), G_hat(idx_G+1:idx_G+2, 1:2), 0.9, 'r', 0.3);
        draw_ellipse(state_hat_icp(1:2, k), G_hat_icp(idx_G+1:idx_G+2, 1:2), 0.9, 'b', 0.3);
        
        i = i + 1;
    end
end

xlabel('NS');
ylabel('SN');
zlabel('Depth (m)');
legend('Seafloor', 'Waypoints', 'Ground truth', 'Dead reckoning', 'TBN');
title('Trajectories');

% % Error comparison
figure; hold on;

% plot(dRG_MSE);

for k = 1:size(ICP_MSE, 1)
    plot(ICP_MSE(k, :));
end

xlabel('t');
ylabel('MSE (m)');
% legend('Dead reckoning', 'TBN');
title('Error comparison');

figure; hold on;

plot(ICP_t);

ylabel('Time (s)');
title('Running time evolution');

