classdef environment
    
    properties
        cloud
        centered_cloud
        x
        y
        X
        Y
        Z
    end
    
    methods
        function obj = environment(path)
            load(path, 'depth', 'UTM_SN', 'UTM_WE');
            
            % Cloud
            
            obj.x = UTM_WE;
            obj.y = UTM_SN;
            
            [obj.X, obj.Y] = meshgrid(obj.x, obj.y);
            
            obj.Z = depth;
            
            obj.cloud = [reshape(obj.X, [1, length(obj.X)^2]);
                          reshape(obj.Y, [1, length(obj.Y)^2]);
                          reshape(depth, [1, length(depth)^2])];
            
            % Centered cloud
            
            x = -(size(depth, 1)-1)/2:size(depth, 1)/2;
            y = -(size(depth, 2)-1)/2:size(depth, 2)/2;

            [X, Y] = meshgrid(x, y);

            obj.centered_cloud = [reshape(X, [1, length(X)^2]);
                                  reshape(Y, [1, length(Y)^2]);
                                  reshape(depth, [1, length(depth)^2])];
        end
        
        function [obj] = reduceResolution(obj, factor)

            obj.x = obj.x(1:factor:length(obj.x));
            obj.y = obj.y(1:factor:length(obj.y));

            [obj.X, obj.Y] = meshgrid(obj.x, obj.y);
            
            idx = find(ismember(obj.cloud(1, :), obj.x) & ismember(obj.cloud(2, :), obj.y));

            obj.cloud = obj.cloud(:, idx);
            obj.centered_cloud = obj.centered_cloud(:, idx);
            
            obj.Z = reshape(obj.cloud(3,:), length(obj.x), length(obj.y));
        end
        
        function plot(obj)
            s = surf(obj.X, obj.Y, obj.Z);
            s.EdgeColor = 'none';
        end

    end
end

