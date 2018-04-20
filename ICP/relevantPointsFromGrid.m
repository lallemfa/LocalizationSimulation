function [grid] = relevantPointsFromGrid(grid, percent)
    mean_depth = mean(mean(grid));
    gap = abs(max(max(grid))) + abs(min(min(grid)));
    
    grid(abs(grid - mean_depth) <= percent*gap ) = 0;
end

