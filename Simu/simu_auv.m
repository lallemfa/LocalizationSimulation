function [ground_truth] = simu_auv(init_state_vector, waypoints, dt)

    function [u] = control(state_vector, curr_wp)
        gis = atan2(curr_wp(2) - state_vector(2), curr_wp(1) - state_vector(1));
        e = sawtooth(state_vector(6) - gis);
        if abs(e) > 2.5
            u = 1.0;
        else
            u = -0.1*e;
        end
    end

    function [state_dot] = evolve(state_vector, u, V)
        state_dot = [V*cos(state_vector(6)); V*sin(state_vector(6)); 0.0; 0.0; 0.0; u];
    end

    function [bool] = validate_wp(state_vector, curr_wp)
        dist = sqrt((state_vector(2)-curr_wp(2))^2 + (state_vector(1)-curr_wp(1))^2);
        bool = dist < 1;
    end

%     function [window] = sensor_data(state_vector, window, depth)
%         psi     = state_vector(6);
%         
%         R = [cos(psi) -sin(psi);
%             sin(psi) cos(psi)];
% 
%         window = [R*window(1:2, :); window(3, :)] + [state_vector(1); state_vector(2); 0];
%     end

    V = 1; % m/s
   
    % State vector -> x y z roll pitch yaw
    state_vector = init_state_vector;
    
    % Measurements -> roll pitch yaw vx vy vz
%     measurements = [0; 0; init_state_vector(6); V; 0; 0];
    
    idx_max = size(waypoints, 2);
    idx_wp = 1;
    curr_wp = waypoints(:, idx_wp);
    
%     % Window
%     i = -25:25;
%     j = -50:50;
% 
%     [I, J] = meshgrid(i, j);
%     window = [reshape(I,[1,5151]); reshape(J,[1,5151]); zeros(1, 5151)];
    
    
    % Loop
    ground_truth = state_vector;
    
    iter = 0;
    while true && iter < 50000
        u               = control(state_vector, curr_wp);
        state_dot       = evolve(state_vector, u, V);
        state_vector    = state_vector + dt*state_dot;
        
        if validate_wp(state_vector, curr_wp)
            idx_wp = idx_wp + 1;
            if idx_wp > idx_max
               break 
            end
            curr_wp = waypoints(:, idx_wp);
        end
        
        ground_truth    = [ground_truth, state_vector];
        
%         noise               = sqrt(0.01)*randn();
%         new_measurements    = [0; 0; state_vector(6); V; 0; 0] + noise;
%         measurements        = [measurements, new_measurements];
        
        iter = iter + 1;
    end
end

