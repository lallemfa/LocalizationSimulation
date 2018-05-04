function [y, C, Gbeta, map] = observation(initial_state, psi, view, beacons, idx_TBN, idx_SLAM, map, flag_TBN, flag_scan_matching)
    y = [];
    C = [];
    Gbeta = [];
    
    if flag_TBN
        if ~isempty(view.beacon)
            R = [ cos(psi)  sin(psi);
                 -sin(psi)  cos(psi)];

            number_obs = 0;

            for k=1:size(view.beacon, 2)
                curr_view = view.beacon(:, k);
                idx = find(idx_TBN == curr_view(2));
                if ~isempty(idx)
                    y = [y; beacons(:, idx) + R*curr_view(3:4)];

                    Ctemp = zeros(2, length(initial_state));

                    Ctemp(1, 1) = 1;
                    Ctemp(2, 2) = 1;

                    C = [C; Ctemp];
                    
                    number_obs = number_obs + 1;
                end
            end

            Gbeta = 0.1*ones(1, 2*number_obs);
        end
    end
    
    if flag_scan_matching
        
    end
    
    Gbeta = diag(Gbeta);
end