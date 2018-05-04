function [cloud, angles, T] = generateDeformedCloud(cloud)
    %% Generate deformation
    angle_max = deg2rad(5);
    trans_max = 10;

    % Generate rotation matrix
    angles  = rand(1, 3)*2*angle_max - angle_max;
    R       = rotmat(angles(1), angles(2), angles(3));

    % Generation translation vector
    T       = rand(3, 1)*2*trans_max - trans_max;

    cloud = R*cloud + T;
end