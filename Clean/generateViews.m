function [views] = generateViews(trajectory, Beacons, X_cloud, Y_cloud, cloud)

    %% Noise characteristics
    
    dist_beacon = [0.1; 0.1];
    
    %% Window characteristics
    
    forward = 25;
    side    = 50;
    
    x = -forward:5:forward;
    y = -side:5:side;
    [X, Y] = meshgrid(x, y);
    
    dim = length(x)*length(y);
    
    window = [reshape(X, 1, dim); reshape(Y, 1, dim); ones(1, dim)];

    %% Computing views
    
    views = [];
    
    for i = 1:length(trajectory)
        view.beacon   = [];
        view.cloud     = [];
        
        if (mod(i,40) == 0)
            disp(['Iteration -> ', num2str(i)]);
            psi = trajectory(6, i);
            
            % Function view beacon
            R = [cos(psi) -sin(psi);
                 sin(psi)  cos(psi)];
            
            tic;
            view_beacons = [];
            for j = 1:length(Beacons)
                beacon = Beacons(:, j);
                dist_glo = [trajectory(1, i) - beacon(1); trajectory(2, i) - beacon(2)];
                dist_loc = R*dist_glo;
                if abs(dist_loc(1)) <= forward && abs(dist_loc(2)) <= side
                    view_beacons = [view_beacons, [i; j; dist_loc + dist_beacon; trajectory(1:2, i); beacon]];
                end
            end
            
            view.beacon = view_beacons;
            
            disp(['Time elapsed for beacons views -> ', num2str(toc)]);
             
            % Function view cloud
            R = [cos(psi) -sin(psi) 0;
                 sin(psi)  cos(psi) 0;
                 0        0         1];
            
            tic;
            
            curr_window = R*window + [trajectory(1, i); trajectory(2, i); 0];
            for k = 1:length(window)
                curr_window(3, k) = interpolateData(curr_window(1, k), curr_window(2, k), X_cloud, Y_cloud, cloud);
            end
            
            good_values_idx = find( curr_window(3, :) ~= -100 );
            curr_window = curr_window(:, good_values_idx);
            
            view.cloud = [window(1:2, :); curr_window];
            
            disp(['Time elapsed for cloud views -> ', num2str(toc)]);
        end
        
        views = [views, view];
    end
end

