% Compute the fundamental matrix using the eight point algorithm
% Input
% 	x1s, x2s 	Point correspondences
%
% Output
% 	Fh 			Fundamental matrix with the det F = 0 constraint
% 	F 			Initial fundamental matrix obtained from the eight point algorithm
%
function [Fh, F] = fundamentalMatrix(x1s, x2s)
%Normalize
[x1n, T1] = normalizePoints2d(x1s);
[x2n, T2] = normalizePoints2d(x2s);

%following the slides
A = [x2n(1,:)'.*x1n(1,:)'   x2n(1,:)'.*x1n(2,:)'  x2n(1,:)' ...
     x2n(2,:)'.*x1n(1,:)'   x2n(2,:)'.*x1n(2,:)'  x2n(2,:)' ...
     x1n(1,:)'              x1n(2,:)'             ones(size(x1s,2),1) ]; 
 
[U,D,V] = svd(A,0);

F = reshape(V(:,end), 3, 3)';
%perform SVD again to enforce singularity constraint
[U,D,V] = svd(F,0);
%setting last singular value to zero
D(3,3) = 0;
new_F = U*D*V';

%denormalize at the end
Fh = T2'*F*T1;
end