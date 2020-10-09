function [best_k, best_b] = ransacLine(data, iter, threshold)
% data: a 2xn dataset with #n data points
% iter: the number of iterations
% threshold: the threshold of the distances between points and the fitting line

num_pts = size(data,2); % Total number of points
best_inliers = 0;       % Best fitting line with largest number of inliers
best_k=0; best_b=0;                % parameters for best fitting line

for i=1:iter
    % Randomly select 2 points and fit line to these
    % Tip: Matlab command randperm is useful here 
    random_indicies = randperm(num_pts,2);
    point_one = data(:, random_indicies(1));
    point_two = data(:, random_indicies(2));
    % Model is y = k*x + b
    coefficients = polyfit([point_one(1), point_two(1)], [point_one(2), point_two(2)], 1);
    k = coefficients(1);
    b = coefficients(2);
    % Compute the distances between all points with the fitting line 
    indicies_to_compare = [1:num_pts];
    indicies_to_compare(random_indicies) = [];
    distance = (-data(2,indicies_to_compare)+k*data(1,indicies_to_compare)+b) / (sqrt(1+k*k));
    % Compute the inliers with distances smaller than the threshold
    inlier_idx = find(abs(distance) <= threshold);    
    % Update the number of inliers and fitting model if better model is found
    if size(inlier_idx, 2) > best_inliers
        best_inliers = size(inlier_idx, 2);
        best_k = k;
        best_b = b;
    end
end
end
