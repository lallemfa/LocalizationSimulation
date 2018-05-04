function [state_hat, G_hat, map] = clean_dead_reckoning(dt, initial_state, measurements, views, beacons, idx_TBN, flag_TBN, flag_scan_matching)
    N   = length(initial_state);
    Nm  = N-3;
    
    state_hat = initial_state;
    
    pos_hat = initial_state;
    
    Gx      = diag([0.1*ones(1, 3), 10*ones(1, Nm)]);
    Galpha  = diag([0.01*ones(1, 3), zeros(1, Nm)]);
    
    A       = eye(N, N);
    
    G_hat = Gx(1:3,1:3);
    
    map = [];
    
    for i=1:length(measurements)-1
        measure = measurements(:,i);
        
        % Measures
        phi     = measure(1); % Roll 
        theta   = measure(2); % Pitch
        psi     = measure(3); % Yaw
        
        Vx = measure(4);
        Vy = measure(5);
        Vz = measure(6);
        
        V = [Vx; Vy; Vz; zeros(Nm, 1)];
        
        % Observations
        [y, C, Gbeta] = observation(initial_state, psi, views(i), beacons, idx_TBN, [], flag_TBN, flag_scan_matching);
        
        % Kalman
        [pos_hat, Gx] = kalman(pos_hat, Gx, dt*V, y, Galpha, Gbeta, A, C);
    
        % Update map
        map = updateMap(pos_hat, map);
        
        state_hat   = [state_hat, pos_hat];
        G_hat       = [G_hat; Gx(1:3,1:3)];
    end
end

