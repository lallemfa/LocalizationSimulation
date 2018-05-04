classdef robot_state
    
    properties
        state_vector
        speed_vector
        order_vector
    end
    
    methods
        function obj = robot_state(positions, velocities, order)
            obj.state_vector = positions;
            obj.speed_vector = velocities;
            obj.order_vector = order;
        end
    end
end

