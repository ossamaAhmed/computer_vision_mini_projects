function [K, R, t, error] = runGoldStandard(xy, XYZ)

%normalize data points
[xyn, XYZn, T, U] = normalization(xy, XYZ);
%compute DLT
[P_normalized] = dlt(xyn, XYZn);

%minimize geometric error
P_normalized = [P_normalized(1,:) P_normalized(2,:) P_normalized(3,:)];
for i=1:20
    [P_normalized] = fminsearch(@fminGoldStandard, P_normalized, [], xyn, XYZn, i/5);
end

%denormalize camera matrix
P_normalized = reshape(P_normalized,[4, 3])';
P_denormalized = T\P_normalized * U;
%factorize camera matrix in to K, R and t
[ K, R, C ] = decompose(P_denormalized);
%caclulate t from the slides equation
t = -R * C;
%compute reprojection error
%compute reprojection error
reprojected_points = P_denormalized * XYZ;
reprojected_points = reprojected_points ./ repmat(reprojected_points(3, :), 3, 1);
%calculating the error
errors = sqrt(sum((reprojected_points(1:2, :) - xy(1:2, :) ) .^ 2));
average_error = sum(errors) / size(errors, 2);
error = average_error;
%plot the points now
filename = 'images/image001.jpg';
img = imread(filename);
image(img);
axis image
for i=1:size(xy, 2)
   hold on;
   plot(reprojected_points(1, i), reprojected_points(2, i), 'yo', 'MarkerSize', 10);
   hold off;
end
for i=1:size(xy, 2)
   hold on;
   plot(xy(1, i), xy(2, i), 'ro', 'MarkerSize', 10);
   hold off;
end
end