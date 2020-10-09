% Decompose the essential matrix
% Return P = [R|t] which relates the two views
% You will need the point correspondences to find the correct solution for P
function P = decomposeE(E, x1, x2)

[U,S,V] = svd(E);
W = [0 -1 0; 
     1  0 0; 
     0  0 -1];

 det(U)
 det(V)
R1 = U*W*V';
R2 = U*W'*V';
T1 = U(:,3);
T2 = -U(:,3);
%possibilities
P1 = [eye(3) [0;0;0]];
P2 = zeros(3,4, 4);
P2(:,:,1) = [R1, T1];
P2(:,:,2) = [R1, T2];
P2(:,:,3) = [R2, T1];
P2(:,:,4) = [R2, T2];
for i=1:4
    [XS, err] = linearTriangulation(P1, x1(:,1), P2(:,:,i), x2(:,1));
    %corresponding point for the origin of the first camera
    pt_origin_1 = P1(:,:)*XS;
    %second camera
    pt_origin_2 = P2(:,:,i)*XS;
    % are they both visible?
    if(pt_origin_1(3)>0 && pt_origin_2(3)>0)
        P = P2(:,:,i); %found it! the chosen P
        break;
    end
end
end