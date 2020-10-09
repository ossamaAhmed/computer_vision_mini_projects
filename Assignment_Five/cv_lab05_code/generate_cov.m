% Generate initial values for the K
% covariance matrices

function cov = generate_cov(X, K)
    cov = zeros(3,3,K);
    for k=1:K
        cov(:,:,k) = diag(mean(X));
    end
end