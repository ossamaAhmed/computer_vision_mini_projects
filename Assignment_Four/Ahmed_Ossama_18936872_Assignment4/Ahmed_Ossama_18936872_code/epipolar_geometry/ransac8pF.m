function [in1, in2, out1, out2, m, F] = ransac8pF(x1, x2, threshold)

% TODO: implement
num_pts = size(x1,2); % Total number of points
best_inliers = 0;       % Best fitting line with largest number of inliers
best_F = [] ;               % parameters for best fitting model
best_point_indicies = [];
x1_t = x1';
x2_t = x2';
iter=1000;
m=iter;
i = 0;
for i=1:iter
    % Randomly select 2 points and fit line to these
    % Tip: Matlab command randperm is useful here 
    random_indicies = randperm(num_pts,8);
    image1_selected_pts = x1_t(random_indicies, :)';
    image2_selected_pts = x2_t(random_indicies, :)';
    %Compute the fundamental matrix with these point pairs
    [Fh, F] = fundamentalMatrix(image1_selected_pts, image2_selected_pts);
    % Compute the error to all points pairs, keeping those that lie within a threshold
    %as inliers and declare the others as outliers. Count the number of inliers.
    indicies_to_compare = [1:num_pts];
    indicies_to_compare(random_indicies) = [];
    distances = zeros(1, size(indicies_to_compare, 2));
    for j=1:size(indicies_to_compare, 2)
        curr_distance = distPointLine(x2_t(indicies_to_compare(j), :)', Fh*x1_t(indicies_to_compare(j), :)') ...
            + distPointLine(x1_t(indicies_to_compare(j), :)', Fh'*x2_t(indicies_to_compare(j), :)');
        distances(j) = curr_distance;
    end
    % Compute the inliers with distances smaller than the threshold
    inlier_idx = find(abs(distances) <= threshold);
    % Update the number of inliers and fitting model if better model is found
    if size(inlier_idx, 2) > best_inliers
        best_point_indicies = indicies_to_compare(inlier_idx);
        best_inliers = size(inlier_idx, 2);
        best_F = Fh;
    end
    %compute P
    in_lier_ratio = best_inliers/num_pts;
    in_lier_ratio
    p = 1 - ((1 - in_lier_ratio^8)^i);
    if p >= 0.99
        m = i;
        break
    end
end
%calculate error
% [x_predicter,S] = polyfit(x1_t(best_point_indicies,1:2), x2_t(best_point_indicies,1), 2); % doublecheck
% [x_predicter,S] = polyfit(x1_t(best_point_indicies,1:2), x2_t(best_point_indicies,2), 2); % doublecheck

in1 = x1_t(best_point_indicies,:)';
in2 = x2_t(best_point_indicies,:)';
out_indicies = [1:num_pts];
out_indicies(best_point_indicies) = [];
out1 = x1_t(out_indicies,:)';
out2 = x2_t(out_indicies,:)';
m
F = best_F;
end


