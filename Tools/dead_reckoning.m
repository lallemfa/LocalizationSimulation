function [state_hat, G_hat] = dead_reckoning(initial_state, measurements, dt, views, beacons)
    N   = length(initial_state);
    Nm  = N-3;
    
    state_hat = initial_state;
    
    pos_hat = initial_state;
    
    Gx      = diag([0.1*ones(1, 3), 10*ones(1, Nm)]);
    Galpha  = diag([0.01*ones(1, 3), zeros(1, Nm)]);
    
    A       = eye(N, N);
    
    G_hat = Gx(1:3,1:3);
    
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
        
        %Beacons
        
        y = [];
        C = [];
        Gbeta = [];
        
        if ~isempty(views)
            idx = find(views(1,:) == i);

            if ~isempty(idx)

                R = [ cos(psi)  sin(psi);
                     -sin(psi)  cos(psi)];

                C = [];
                y = [];

                for k=1:length(idx)
                    view = views(:, idx(k));
                    y = [y; beacons(:, view(2)) + R*view(3:4)];
                    
                    Ctemp = zeros(2, length(initial_state));

                    Ctemp(1, 1) = 1;
                    Ctemp(2, 2) = 1;
%                     Ctemp(1, 4 + (view(2)-1)*2) = -1;
%                     Ctemp(2, 5 + (view(2)-1)*2) = -1;
                    C = [C; Ctemp];
                end

                Gbeta=diag(0.1*ones(1, 2*length(idx)));
            end
        end
        
        [pos_hat, Gx] = kalman(pos_hat, Gx, dt*V, y, Galpha, Gbeta, A, C);
    
        state_hat   = [state_hat, pos_hat];
        G_hat       = [G_hat; Gx(1:3,1:3)];
    end
end

