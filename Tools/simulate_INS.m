function [measures] = simulate_INS(state_vector, dt)
    
    %% Linear measurements errors (m/s)

    % x axis
    x_constant_bias             = 0.0;
    x_white_noise_std           = 0.0;
    x_bias_instability_std      = 0.0;
    
    % y axis
    y_constant_bias             = 0.0;
    y_white_noise_std           = 0.0;
    y_bias_instability_std      = 0.0;
    
    % z axis
    z_constant_bias             = 0.0;
    z_white_noise_std           = 0.0;
    z_bias_instability_std      = 0.0;
    
    %% Angular measurements errors (rad/s)
    
    % Roll axis
    roll_constant_bias          = 0.0;
    roll_white_noise_std        = 0.0;
    roll_bias_instability_std   = 0.0;
    
    % Pitch axis
    pitch_constant_bias         = 0.0;
    pitch_white_noise_std       = 0.0;
    pitch_bias_instability_std  = 0.0;
    
    % Yaw axis
    yaw_constant_bias           = 0.0;
    yaw_white_noise_std         = 0.0;
    yaw_bias_instability_std    = 0.0;
    
    %% Noise computing function
    
    function [noise] = computeNoise(N, constant_bias, white_noise_std, bias_instability_std)
        noise = zeros(1, N);
        prev_random_walk = 0.0;
        
        for k = 1:N
            k_noise = [constant_bias;
                        white_noise_std*randn();
                        prev_random_walk + bias_instability_std*randn()];
            prev_random_walk = k_noise(3);
            
            noise(k) = sum(k_noise);
        end
    end   
    
    %% Computing
    
    N = length(state_vector);
    
    % Angular velocities (Roll Pitch Yaw axis) | Linear acceleration (x y z axis)
    measures = [0.0; 0.0; 0.0; 0.0; 0.0; -9.81];
    
    % Compute noises
    linear_noise   = [computeNoise(N, x_constant_bias, x_white_noise_std, x_bias_instability_std);
                        computeNoise(N, y_constant_bias, y_white_noise_std, y_bias_instability_std);
                        computeNoise(N, z_constant_bias, z_white_noise_std, z_bias_instability_std)];
    
    angular_noise   = [computeNoise(N, roll_constant_bias, roll_white_noise_std, roll_bias_instability_std);
                        computeNoise(N, pitch_constant_bias, pitch_white_noise_std, pitch_bias_instability_std);
                        computeNoise(N, yaw_constant_bias, yaw_white_noise_std, yaw_bias_instability_std)];
    
    angular_vel = [0;0;0];
                    
    for k = 2:N-1
        cur_linear_noise = linear_noise(:, k);
        cur_angular_noise = angular_noise(:, k);
        
        fut_state = state_vector(:, k+1);
        cur_state = state_vector(:, k);
        old_state = state_vector(:, k-1);
              
        % Linear accelerations computation
        old_x = old_state(1);
        cur_x = cur_state(1);
        fut_x = fut_state(1);
        old_y = old_state(2);
        cur_y = cur_state(2);
        fut_y = fut_state(2);
        old_z = old_state(3);
        cur_z = cur_state(3);
        fut_z = fut_state(3);
        
        linear_accel = [(fut_x - 2*cur_x + old_x)/(dt^2);
                        (fut_y - 2*cur_y + old_y)/(dt^2);
                        (fut_z - 2*cur_z + old_z)/(dt^2) - 9.81];           

        linear_accel = linear_accel + cur_linear_noise;
        
        % Angular velocities computation
        old_phi = old_state(4);
        new_phi = cur_state(4);
        old_theta = old_state(5);
        new_theta = cur_state(5);
        old_psi = old_state(6);
        new_psi = cur_state(6);
        
%         angular_vel = [ (new_phi - old_phi)/dt;
%                         (new_theta - old_theta)/dt;
%                         (new_psi - old_psi)/dt];
                    
        angular_vel = [ 2*(new_phi - old_phi)/dt - angular_vel(1);
                        2*(new_theta - old_theta)/dt - angular_vel(2);
                        2*(new_psi - old_psi)/dt - angular_vel(3)];
                    
        angular_vel = angular_vel + cur_angular_noise;
        
        % Filling data
        measures = [measures, [angular_vel; linear_accel]];
        
    end
    
    measures = [measures, [angular_vel; linear_accel]];
    
    for k = 1:N
        R = rotmat(state_vector(4, k), state_vector(5, k), state_vector(6, k));
        
        measures(4:6, k) = R\measures(4:6, k);
    end
    
end

