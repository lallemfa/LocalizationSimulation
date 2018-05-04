function [positions, velocities, angles] = integrateINS(initial_state, measures, dt)
    N = length(measures);
    
    %% Angles
    phi   = initial_state(4);
    theta = initial_state(5);
    psi   = initial_state(6);
    angles = [phi; theta; psi];
    
    for k = 2:N
        phi   = dt*(measures(1,k-1) + measures(1,k))/2 + phi;
        theta = dt*(measures(2,k-1) + measures(2,k))/2 + theta;
        psi   = dt*(measures(3,k-1) + measures(3,k))/2 + psi;
        
        angles = [angles, [phi; theta; psi]];
    end
    
    %% Frame correction
    
    for k = 1:N
        R = rotmat(angles(1, k), angles(2, k), angles(3, k));
        measures(4:6, k) = R*measures(4:6, k);
    end
    
    %% Velocities
    Vx = 1.0;
    Vy = 0.0;
    Vz = 0.0;
    velocities = [Vx; Vy; Vz];
    
    for k = 2:N
        Vx = dt*(measures(4, k-1) + measures(4, k))/2 + Vx;
        Vy = dt*(measures(5, k-1) + measures(5, k))/2 + Vy;
        Vz = dt*(9.81+(measures(6, k-1) + measures(6, k))/2) + Vz;
        
        velocities = [velocities, [Vx; Vy; Vz]];
    end
    
    %% Positions
    x = initial_state(1);
    y = initial_state(2);
    z = initial_state(3);
    positions = [x; y; z];
    
    for k = 2:length(velocities)
        x = dt*velocities(1, k-1) + x;
        y = dt*velocities(2, k-1) + y;
        z = dt*velocities(3, k-1) + z;
        
%         x = dt*(velocities(1, k-1) + velocities(1, k))/2 + x;
%         y = dt*(velocities(2, k-1) + velocities(2, k))/2 + y;
%         z = dt*(velocities(3, k-1) + velocities(3, k))/2 + z;
        
        positions = [positions, [x; y; z]];
    end
    
    
    
end

