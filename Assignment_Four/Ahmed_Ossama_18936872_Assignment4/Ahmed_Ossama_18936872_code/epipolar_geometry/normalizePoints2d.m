% Normalization of 2d-pts
% Inputs: 
%           xs = 2d points
% Outputs:
%           nxs = normalized points
%           T = 3x3 normalization matrix
%               (s.t. nx=T*x when x is in homogenous coords)
function [nxs, T] = normalizePoints2d(xs)

%shift center
xy = xs;
xy_center = mean(xy(1:2, :)')';
xy_shifted(1, :) = xy(1, :) - xy_center(1);
xy_shifted(2, :) = xy(1, :) - xy_center(1);

%get scale
xy_scale = sqrt(2) / mean(sqrt(xy_shifted(1, :).^2 + xy_shifted(2, :).^2));

%Create T
T = [xy_scale   0        -xy_scale*xy_center(1)
     0          xy_scale -xy_scale*xy_center(2)
     0          0                            1];
 
nxs = T * xy;
end