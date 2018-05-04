function [val] = interpolateData(x, y, X, Y, cloud)
    X = sort([X, x]);
    Y = sort([Y, y]);

    idx_x = find(X == x);
    idx_y = find(Y == y);
    
%     disp(['Time elapsed for sort & find -> ', num2str(toc)]);
    
    if idx_x == 1 | idx_x == length(X) | idx_y == 1 | idx_y == length(Y)
        val = -100;
    else
        previous_x  = X(idx_x - 1);
        next_x      = X(idx_x + 1);

        previous_y  = Y(idx_y - 1);
        next_y      = Y(idx_y + 1);

%         disp(['Time elapsed for values -> ', num2str(toc)]);
        
        cloud_value_idx = [find(cloud(1,:) ==  previous_x & cloud(2,:) ==  previous_y), find(cloud(1,:) ==  previous_x & cloud(2,:) ==  next_y);
                           find(cloud(1,:) ==  next_x & cloud(2,:) ==  previous_y),     find(cloud(1,:) ==  next_x & cloud(2,:) ==  next_y)];
%         disp(['Time elapsed for index -> ', num2str(toc)]);
        
        % Same notations as Wiki article Bilinear interpolation
        fQ11 = cloud(3, cloud_value_idx(1, 1));
        fQ21 = cloud(3, cloud_value_idx(2, 1));
        fQ12 = cloud(3, cloud_value_idx(1, 2));
        fQ22 = cloud(3, cloud_value_idx(2, 2));
        
        val = [next_x - x, x - previous_x]*[fQ11, fQ12; fQ21, fQ22]*[next_y - y; y - previous_y]/((next_x - previous_x)*(next_y - previous_y));
    end
        
    
    
end