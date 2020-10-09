function [ K, R, C ] = decompose(P)
%decompose P into K, R and t
M = P(:, 1:3);
negative_M_times_C = P(:, 4);
C = -M\negative_M_times_C;
[R_inverse, k_inverse] = qr(inv(M));
R = inv(R_inverse);
K = inv(k_inverse);
K = K/K(3,3);
end