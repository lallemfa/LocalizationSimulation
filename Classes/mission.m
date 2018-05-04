classdef mission
    %UNTITLED4 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        waypoints
        threshold
        idx
        curr_wp
    end
    
    methods
        function obj = mission(waypoints, threshold)
            obj.waypoints   = waypoints;
            obj.threshold   = threshold;
            
            obj.idx         = 1;
            obj.curr_wp     = waypoints(:, obj.idx);
        end
        
        function bool = checkWP(obj, robot_state)
            dist = sqrt( (robot_state.state_vector(1) - obj.curr_wp(1))^2 + (robot_state.state_vector(2) - obj.curr_wp(2))^2 );
            bool = dist <= obj.threshold;
            
            if bool
                obj.idx = obj.idx + 1;
                obj.curr_wp = obj.waypoints(:, obj.idx);
            end
        end
    end
end

