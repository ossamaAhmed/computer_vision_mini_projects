function f = fminGoldStandard(p, xy, XYZ, w)

%reassemble P
P = [p(1:4);p(5:8);p(9:12)];
%compute squared geometric error
reprojected_points = P * XYZ;
reprojected_points = reprojected_points ./ repmat(reprojected_points(3, :), 3, 1);
errors = sqrt(sum((reprojected_points(1:2, :) - xy(1:2, :) ) .^ 2));
%compute cost function value
f = sum(errors) / size(errors, 2);
end