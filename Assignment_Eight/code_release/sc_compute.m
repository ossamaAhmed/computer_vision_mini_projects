function [shapeDescriptors] = sc_compute(X,nbBins_theta,nbBins_r,smallest_r,biggest_r)

X = X';

nbSamples = size(X,1);
x = X(:, 1);
y = X(:, 2);
radial_ends = linspace(log(smallest_r), log(biggest_r), nbBins_r);
theta_ends = linspace(0, 2*pi, nbBins_theta);
first_point_x = repmat(x, 1, nbSamples);
first_point_y = repmat(y, 1, nbSamples);
second_point_x = repmat(x', nbSamples, 1);
second_point_y = repmat(y', nbSamples, 1);
euclidean_distances = sqrt((second_point_x - first_point_x).^2 + (second_point_y - first_point_y).^2);
euclidean_distances_normalized = euclidean_distances ./ mean(euclidean_distances(:));
directions = atan2(second_point_y - first_point_y, second_point_x - first_point_x);
descriptor_per_pixel = zeros(nbSamples, nbBins_r, nbBins_theta);
for i=1:size(euclidean_distances_normalized, 2)
    [descriptor_per_pixel(i,:,:), ~] = hist3([log(euclidean_distances_normalized(i,:))', directions(i, :)'], 'Edges', {radial_ends, theta_ends});
end
shapeDescriptors = descriptor_per_pixel;
end