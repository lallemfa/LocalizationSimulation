function [state_hat, G_hat] = dead_reckoning(initial_state, measurements, dt)
    state_hat = initial_state;
    
    pos_hat = initial_state(1:3);
    
    Gx      = 0.0*eye(3,3);
    Galpha  = 0.01*eye(3,3);
    A       = eye(3,3);
    
    G_hat = Gx;
    
    for i=1:length(measurements)-1
        measure = measurements(:,i);
        
        % Measures
        phi     = measure(1); % Roll 
        theta   = measure(2); % Pitch
        psi     = measure(3); % Yaw
        
        Vx = measure(4);
        Vy = measure(5);
        Vz = measure(6);
        
        V = [Vx; Vy; Vz];
        
        % Momentum
        
        [pos_hat, Gx] = kalman(pos_hat, Gx, dt*V, [], Galpha, [], A, []);
        
        estimated = [pos_hat; phi; theta; psi];
    
        state_hat   = [state_hat, estimated];
        G_hat       = [G_hat; Gx];
    end
end

