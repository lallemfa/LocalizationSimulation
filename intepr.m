clc; clear all; close all;

values =   [0 1  0 1;
            0 0  1 1;
            2 7 -2 4];
        

inter_values = [];
for x = 0:0.1:1
    for y = 0:0.1:1
        inter = [1-x, x]*[2,-2;7,4]*[1-y;y]/(1)*(1);
        value = [x; y; inter];
        inter_values = [inter_values, value];
    end
end

figure; hold on;
plot3(values(1,:), values(2,:), values(3,:), 'ro');
plot3(inter_values(1,:), inter_values(2,:), inter_values(3,:), 'b.');