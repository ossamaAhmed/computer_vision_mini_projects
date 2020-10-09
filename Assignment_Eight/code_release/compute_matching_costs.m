function [matchingCostMatrix] = compute_matching_costs(objects,nsamp)

num_of_samples = size(objects, 2);
display_flag = false;
result = zeros(num_of_samples, num_of_samples);
for i=1:num_of_samples
    for j=1:num_of_samples
        if i == j
            result(i,j) = inf;
        else
            result(i,j) = shape_matching(get_samples_1(objects(i).X, nsamp), get_samples_1(objects(j).X, nsamp), display_flag);
        end
    end
end

matchingCostMatrix = result;
end