function vPoints = grid_points(img,nPointsX,nPointsY,border)
    
    [size_x, size_y] = size(img);
    grid_points_x = round(linspace(border + 1,size_x-border,nPointsX+2));
    grid_points_y = round(linspace(border + 1,size_y-border,nPointsY+2));
    [X, Y] = meshgrid(grid_points_x(2:end-1), grid_points_y(2:end-1));
    vPoints = [X(:), Y(:)]; %not sure about the rounding part
end
