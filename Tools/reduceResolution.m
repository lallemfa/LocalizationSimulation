function [grid, x, y] = reduceResolution(grid, x, y, factor)
    Nrows       = size(grid, 1);
    Ncolumns    = size(grid, 2);
    
    factor = max(1, floor(factor));
    
    rows    = 1:factor:Nrows;
    columns = 1:factor:Ncolumns;
    
    x       = x(rows);
    y       = y(columns);
    grid    = grid(rows, columns);
end

