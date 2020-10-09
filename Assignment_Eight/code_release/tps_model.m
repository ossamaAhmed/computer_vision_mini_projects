function [w_x w_y E] = tps_model(X,Y,lambda)
%template
X_xcoord = X(:, 1);
X_ycoord = X(:, 2);
nb_samples_template = size(X, 1);
%target shape
Y_xcoord = Y(:, 1);
Y_ycoord = Y(:, 2);
%working on the first dimension

K = kernel_function(sqrt(dist2(X, X)));
K(isnan(K)) = 0;

P = zeros(nb_samples_template, 3);
P(:, 1) = 1;
P(:, 2) = X_xcoord;
P(:, 3) = X_ycoord;
tps_model = [K+lambda*eye(size(K,1)), P;
             P', zeros(3,3)];
result_fx = [Y_xcoord; zeros(3,1)];

fx = tps_model\result_fx;
w_fx = fx(1:end-3, :);
%working on the second dimension

result_fy = [Y_ycoord; zeros(3,1)];

fy = tps_model\result_fy;
w_fy = fy(1:end-3, :);

E = (w_fx' * K * w_fx) + (w_fy' * K * w_fy);
w_x = fx;
w_y = fy;

end