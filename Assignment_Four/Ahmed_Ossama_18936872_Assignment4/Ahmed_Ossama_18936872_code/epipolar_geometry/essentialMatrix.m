% Compute the essential matrix using the eight point algorithm
% Input
% 	x1s, x2s 	Point correspondences 3xn matrices
%
% Output
% 	Eh 			Essential matrix with the det F = 0 constraint and the constraint that the first two singular values are equal
% 	E 			Initial essential matrix obtained from the eight point algorithm
%

function [Eh, E] = essentialMatrix(x1s, x2s)
%same first steps as the fundamental matrix
%should we normalize here? double check
[x1n, T1] = normalizePoints2d(x1s);
[x2n, T2] = normalizePoints2d(x2s);
%following the slides
A = [x2n(1,:)'.*x1n(1,:)'   x2n(1,:)'.*x1n(2,:)'  x2n(1,:)' ...
     x2n(2,:)'.*x1n(1,:)'   x2n(2,:)'.*x1n(2,:)'  x2n(2,:)' ...
     x1n(1,:)'              x1n(2,:)'             ones(size(x1n,2),1) ]; 
 
[U,D,V] = svd(A, 0);
E = reshape(V(:,end), 3, 3)';
%perform SVD again to enforce singularity constraint
[U,D,V] = svd(E, 0);
%setting last singular value to zero
D = diag([(D(1,1)+D(2,2))/2, (D(1,1)+D(2,2))/2, 0]);
Eh = U*D*V';
%denormalize at the end
Eh = T2'*Eh*T1;
end