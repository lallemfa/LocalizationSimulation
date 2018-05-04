function [views] = generateViewsICP(trajectory, X_cloud, Y_cloud, cloud)

    %% Window characteristics
    forward = 25;
    side    = 50;
    
    x = -forward:forward;
    y = -side:side;
    [X, Y] = meshgrid(x, y);
    
    dim = length(x)*length(y);
    
    window = [reshape(X, 1, dim); reshape(Y, 1, dim); ones(1, dim)];
    
    %% Computing views
    
    views = [];
    
    for i = 1:length(trajectory)
        if (mod(i,40) == 0)
            psi = trajectory(6, i);
            R = [cos(psi) -sin(psi) 0;
                 sin(psi)  cos(psi) 0;
                 0        0         1];
            curr_window = R*window + [trajectory(1, i); trajectory(2, i); 0];
            for k = 1:length(window)
                curr_window(3, k) = interpolateData(curr_window(1, k), curr_window(2, k), X_cloud, Y_cloud, cloud);
            end
        end
    end
    
end

