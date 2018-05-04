clc; clear all; close all;

%% Load and format data
load('../Data/ICP_data_steep.mat');

x = -(size(depth, 1)-1)/2:size(depth, 1)/2;
y = -(size(depth, 2)-1)/2:size(depth, 2)/2;

[X, Y] = meshgrid(x, y);

original_cloud = [reshape(X, [1, length(X)^2]);
                  reshape(Y, [1, length(Y)^2]);
                  reshape(depth, [1, length(depth)^2])];

clear 'X' 'Y' 'x' 'y' 'depth';

%% ICP methods comparison
% 
% deformed_cloud = generateDeformedCloud(original_cloud);
% 
% ER_brute    = [];
% ER_Delaunay = [];
% ER_kdTree   = [];
% 
% t_brute    = [];
% t_Delaunay = [];
% t_kdTree   = [];
% 
% N = 10;
% 
% for i=1:N
%     [~, ~, ER, t]   = icp(original_cloud, deformed_cloud, 15, 'Matching', 'bruteForce', 'Extrapolation', true);
%     ER_brute        = [ER_brute; ER'];
%     t_brute         = [t_brute; t'];
%     
%     [~, ~, ER, t]   = icp(original_cloud, deformed_cloud, 15, 'Matching', 'Delaunay', 'Extrapolation', true);
%     ER_Delaunay     = [ER_Delaunay; ER'];
%     t_Delaunay      = [t_Delaunay; t'];
%     
%     [~, ~, ER, t]   = icp(original_cloud, deformed_cloud, 15, 'Matching', 'kDtree', 'Extrapolation', true);
%     ER_kdTree       = [ER_kdTree; ER'];
%     t_kdTree        = [t_kdTree; t'];
% end
% 
% ER_brute    = mean(ER_brute);
% ER_Delaunay = mean(ER_Delaunay);
% ER_kdTree   = mean(ER_kdTree);
% 
% t_brute    = mean(t_brute);
% t_Delaunay = mean(t_Delaunay);
% t_kdTree   = mean(t_kdTree);
% 
% figure;
% 
% subplot(211); hold on;
% plot(ER_brute,'--x');
% plot(ER_Delaunay,'--x');
% plot(ER_kdTree,'--x');
% xlabel('Iteration');
% ylabel('d_{RMS}');
% title('Comparison of error evolution');
% legend('Brute Force', 'Delaunay', 'k-D Tree');
% 
% subplot(212); hold on;
% plot(t_brute,'--x');
% plot(t_Delaunay,'--x');
% plot(t_kdTree,'--x');
% xlabel('Iteration');
% ylabel('t (s)');
% title('Comparison of time evolution');
% legend('Brute Force', 'Delaunay', 'k-D Tree');

%% ICP methods comparison

ER_kdTree_1  = [];

t_kdTree_1   = [];

% R_error = [];
% T_error = [];

tic;
for i = 1:20
    sparse_cloud = original_cloud(:, 1:i:length(original_cloud));
    
    ER_temp = [];
    t_temp  = [];
    
%     angles_temp = [];
%     trans_temp  = [];
    
    for j = 1:10
        [deformed_cloud, angles, T] = generateDeformedCloud(sparse_cloud);
        
        [Ricp, Ticp, ER, t]   = icp(sparse_cloud, deformed_cloud, 15, 'Matching', 'kDtree');
        
        ER_temp = [ER_temp, ER(end)];
        t_temp  = [t_temp, t(end)];
        
%         [phi, theta, psi] = rotmat2euler(Ricp);
%         angles_temp = [angles_temp, [phi; theta; psi]-angles'];
%         
%         trans_temp = [trans_temp, Ticp-T];
    end
        
    ER_kdTree_1       = [ER_kdTree_1, mean(ER_temp)];
    t_kdTree_1        = [t_kdTree_1, mean(t_temp)];
    
%     R_error         = [R_error, mean(angles_temp, 2)];
%     T_error         = [T_error, mean(trans_temp, 2)];
end
toc;

figure;

subplot(211);
plot(ER_kdTree_1,'--x');
xlabel('One point taken out of #');
ylabel('d_{RMS}');
title('Error evolution with density decreasing on both clouds w/o noise');
legend('k-D Tree');

subplot(212);
plot(t_kdTree_1,'--x');
xlabel('One point taken out of #');
ylabel('t (s)');
title('Running time with density decreasing on both clouds w/o noise');
% legend('k-D Tree');
% 
% subplot(223); hold on;
% plot(sqrt(T_error(1, :).^2 + T_error(2, :).^2 + T_error(3, :).^2));
% xlabel('One point taken out of #');
% ylabel('Translation error');
% title('Translation error after 15 iteration with density decreasing on both clouds w/o noise');
% legend('Euclidian distance');
% 
% subplot(224); hold on;
% plot(sqrt(R_error(1, :).^2 + R_error(2, :).^2 + R_error(3, :).^2));
% xlabel('One point taken out of #');
% ylabel('Rotation error');
% title('Rotation error after 15 iteration with density decreasing on both clouds w/o noise');
% legend('Rot distance');

%% ICP degrading measured cloud

% Without noise

ER_kdTree_2   = [];

t_kdTree_2   = [];

X = unique(original_cloud(1, :));
Y = unique(original_cloud(2, :));

tic;
for i = 1:20
    x = X(1:i:length(Y));
    y = X(1:i:length(Y));
    
    idx = find(ismember(original_cloud(1, :), x) & ismember(original_cloud(2, :), y));

    sparse_cloud = original_cloud(:, idx);
    
    ER_temp = [];
    t_temp  = [];
    
    for j = 1:10
        deformed_cloud = generateDeformedCloud(sparse_cloud);
        
        [~, ~, ER, t]   = icp(original_cloud, deformed_cloud, 15, 'Matching', 'kDtree');
        
        ER_temp = [ER_temp, ER(end)];
        t_temp  = [t_temp, t(end)];
        
    end
        
    ER_kdTree_2       = [ER_kdTree_2, mean(ER_temp)];
    t_kdTree_2        = [t_kdTree_2, mean(t_temp)];
end
toc;

% With noise

ER_kdTree_3   = [];

t_kdTree_3    = [];

X = unique(original_cloud(1, :));
Y = unique(original_cloud(2, :));

tic;
for i = 1:20
    x = X(1:i:length(Y));
    y = X(1:i:length(Y));
    
    idx = find(ismember(original_cloud(1, :), x) & ismember(original_cloud(2, :), y));

    sparse_cloud = original_cloud(:, idx);
    
    ER_temp  = [];
    t_temp   = [];
    
    for j = 1:10
        deformed_cloud = generateDeformedCloud(sparse_cloud);
        
        deformed_cloud = deformed_cloud + rand(3, length(deformed_cloud)) - 0.5;
        
        [~, ~, ER, t]   = icp(original_cloud, deformed_cloud, 15, 'Matching', 'kDtree');
        
        ER_temp     = [ER_temp, ER(end)];
        t_temp      = [t_temp, t(end)];
    end
        
    ER_kdTree_3       = [ER_kdTree_3, mean(ER_temp)];
    t_kdTree_3        = [t_kdTree_3, mean(t_temp)];
end
toc;

figure;

subplot(211); hold on;
plot(ER_kdTree_2,'--x');
plot(ER_kdTree_3,'--x');
xlabel('One point taken out of #');
ylabel('d_{RMS}');
title('Error evolution with density decreasing on measured cloud');
legend('Perfect', 'Noisy');

subplot(212); hold on;
plot(t_kdTree_2,'--x');
plot(t_kdTree_3,'--x');
xlabel('One point taken out of #');
ylabel('t (s)');
title('Running time with density decreasing on measured cloud');
legend('Perfect', 'Noisy');

%% Plot surfaces
% restored_cloud = Ricp * deformed_cloud + Ticp;
% 
% figure; hold on;
% subplot(2, 2, 1); hold on;
% plot3(original_cloud(1, :), original_cloud(2, :), original_cloud(3, :), 'b.');
% plot3(deformed_cloud(1, :), deformed_cloud(2, :), deformed_cloud(3, :), 'r.');
% legend('Original cloud', 'Deformed cloud');
% subplot(2, 2, 2); hold on;
% plot3(original_cloud(1, :), original_cloud(2, :), original_cloud(3, :), 'b.');
% plot3(restored_cloud(1, :), restored_cloud(2, :), restored_cloud(3, :), 'r.');
% legend('Original cloud', 'Restored cloud');
% subplot(2, 2, [3 4]); hold on;
% plot(ER,'--x');
% xlabel('Iteration');
% ylabel('d_{RMS}');
% title(['Total elapsed time: ' num2str(t(end),2) ' s']);

%% Test

X = unique(original_cloud(1, :));
Y = unique(original_cloud(2, :));

x = X(1:50:length(Y));
y = X(1:50:length(Y));

idx = find(ismember(original_cloud(1, :), x) & ismember(original_cloud(2, :), y));

sparse_cloud = original_cloud(:, idx);

deformed_cloud = generateDeformedCloud(sparse_cloud);
        
deformed_cloud = deformed_cloud + 0.2*(rand(3, length(deformed_cloud)) - 0.5);

[Ricp, Ticp, ER, t]   = icp(original_cloud, deformed_cloud, 15, 'Matching', 'kDtree');

restored_cloud = Ricp * deformed_cloud + Ticp;

figure; hold on;
subplot(2, 2, 1); hold on;
plot3(original_cloud(1, :), original_cloud(2, :), original_cloud(3, :), 'b.');
plot3(deformed_cloud(1, :), deformed_cloud(2, :), deformed_cloud(3, :), 'r.');
legend('Original cloud', 'Deformed cloud');
subplot(2, 2, 2); hold on;
plot3(original_cloud(1, :), original_cloud(2, :), original_cloud(3, :), 'b.');
plot3(restored_cloud(1, :), restored_cloud(2, :), restored_cloud(3, :), 'r.');
legend('Original cloud', 'Restored cloud');
subplot(2, 2, [3 4]); hold on;
plot(ER,'--x');
xlabel('Iteration');
ylabel('d_{RMS}');
title(['Total elapsed time: ' num2str(t(end),2) ' s']);