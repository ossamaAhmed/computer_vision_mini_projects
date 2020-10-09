function [descriptors,patches] = descriptors_hog(img,vPoints,cellWidth,cellHeight)

    nBins = 8;
    w = cellWidth; % set cell dimensions
    h = cellHeight;   
    edges = linspace(-pi, pi, nBins+1);
    descriptors = zeros(size(vPoints,1),nBins*4*4); % one histogram for each of the 16 cells
    patches = zeros(size(vPoints,1),4*w*4*h); % image patches stored in rows    
    [grad_x,grad_y]=gradient(img);
    
    for i = [1:size(vPoints,1)] % for all local feature points
        grid_point = vPoints(i, :);
        %go through all the cells now
        grad_y_window = generate_window_values(grad_y, grid_point, w, h);
        grad_x_window = generate_window_values(grad_x, grid_point, w, h);
%         img_window = generate_window_values(img, grid_point, w, h);
%         flattend_array = [];
%         for k = 1: size(img_window, 1)
%             temp_arr = img_window(k, :, :);
%             flattend_array = [flattend_array temp_arr(:)];
%         end
        patch = img(grid_point(1) - (2*cellHeight): (grid_point(1) + 2*cellHeight)-1, grid_point(2) - (2*cellWidth): (grid_point(2) + 2*cellWidth)-1);
        patches(i, :) = patch(:);
        for j = [1:size(grad_y_window,1)]
            orientations = atan2(grad_y_window(j, :, :), grad_x_window(j, :, :));
            pixel_histogram = histcounts(orientations,edges);
            descriptors(i, (j-1)*nBins+1:(j*nBins)) = pixel_histogram;
        end
    end % for all local feature points
end


function [cellPoints] = generate_window_values(values, vPoint, cellWidth,cellHeight)
    %fix this 
    result = zeros(4*4, cellHeight, cellWidth);
    
    grid_points_y = linspace(vPoint(1) - 2*cellHeight, vPoint(1) + 2*cellHeight, 5);
    grid_points_x = linspace(vPoint(2) - 2*cellWidth, vPoint(2) + 2*cellWidth, 5);
    cell_counter = 0;
    for i = [1:(size(grid_points_y,2)-1)]
        for j = [1:(size(grid_points_x,2)-1)]
            cell_counter = cell_counter + 1;
            result(cell_counter, :, :) = values(grid_points_y(i):grid_points_y(i+1)-1, grid_points_x(j):grid_points_x(j+1)-1);
        end
    end
    cellPoints = result;
end