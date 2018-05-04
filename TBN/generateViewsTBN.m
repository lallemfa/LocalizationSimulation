function [Beacons, views] = generateViewsTBN(number, X, Y, trajectory)

    %% Window characteristics
    
    forward = 25;
    side    = 50;
    
    %% Beacons generation
    
    Beacons = [randi([ceil(X(50)), floor(X(450))], 1, number); randi([ceil(Y(50)), floor(Y(450))], 1, number)];

    %% Computing views
    
    views = [];
    
    for i = 1:length(trajectory)
        if (mod(i,40) == 0)
            psi = trajectory(6, i);
            R = [cos(psi) -sin(psi);
                 sin(psi)  cos(psi)];
            for j = 1:length(Beacons)
                beacon = Beacons(:, j);
                dist_glo = [trajectory(1, i) - beacon(1); trajectory(2, i) - beacon(2)];
                dist_loc = R*dist_glo;
                if abs(dist_loc(1)) <= forward && abs(dist_loc(2)) <= side
                    views = [views, [i; j; dist_loc; trajectory(1:2, i); beacon]];
                end
            end
        end
    end
end

