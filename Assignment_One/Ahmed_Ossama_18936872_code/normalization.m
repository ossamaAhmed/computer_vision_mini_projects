function [xyn, XYZn, T, U] = normalization(xy, XYZ)

%data normalization
xy(1, :) = xy(1, :) ./ xy(3, :);
xy(2, :) = xy(2, :) ./ xy(3, :);
XYZ(1, :) = XYZ(1, :) ./ XYZ(4, :);
XYZ(2, :) = XYZ(2, :) ./ XYZ(4, :);
XYZ(3, :) = XYZ(3, :) ./ XYZ(4, :);
xy(3, :) = 1;
XYZ(4, :) = 1;
%first compute centroid
xy_centroid = mean(xy(1:2, :)')';
XYZ_centroid = mean(XYZ(1:3, :)')';
%shift the centroid
xy_shifted = xy(1:2, :) - xy_centroid;
XYZ_shifted = XYZ(1:3, :) - XYZ_centroid;
%then, compute scale
xy_scale = sqrt(2) / mean(sqrt(xy_shifted(1, :).^2 + xy_shifted(2, :).^2));
XYZ_scale = sqrt(3) / mean(sqrt(XYZ_shifted(1, :).^2 + XYZ_shifted(2, :).^2 + XYZ_shifted(3, :).^2));
%create T and U transformation matrices
T = [xy_scale   0        -xy_scale*xy_centroid(1)
     0          xy_scale -xy_scale*xy_centroid(2)
     0          0                              1];
 
U = [XYZ_scale   0           0          -XYZ_scale*XYZ_centroid(1)
     0           XYZ_scale   0          -XYZ_scale*XYZ_centroid(2)
     0           0           XYZ_scale  -XYZ_scale*XYZ_centroid(3)           
     0           0           0                                 1];

%and normalize the points according to the transformations
xyn = T * xy;
XYZn = U * XYZ;

end