% Generate initial values for mu
% K is the number of segments

function mu = generate_mu(X, K)
    num_pixels = size(X,1);
    mu = X(randi(num_pixels,K,1),:);
end