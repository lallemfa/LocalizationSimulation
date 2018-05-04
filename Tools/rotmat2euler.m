function [phi, theta, psi] = rotmat2euler(R)
    phi = atan2(R(3, 2), R(3, 3));
    
    ctheta  = sqrt( R(1, 1)^2 + R(2, 1)^2 );
    theta = atan2(-R(3, 1), ctheta);
    
    psi = atan2(R(2, 1), R(1, 1));
end

