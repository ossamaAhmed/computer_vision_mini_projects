function [P] = dlt(xy, XYZ)
%computes DLT, xy and XYZ should be normalized before calling this function

A = zeros(2*size(xy, 2), 12);
for i=1:size(xy, 2)
    A(i*2 - 1, :) = [xy(3, i) * XYZ(:, i)', 0, 0, 0, 0, -xy(1, i) * XYZ(:, i)'];
    A(i*2, :) = [0, 0, 0, 0, -xy(3, i) * XYZ(:, i)',     xy(2, i) * XYZ(:, i)'];
end

[U, S, V] = svd(A);
P = V(:, end);
P = reshape(P,[4, 3])';
