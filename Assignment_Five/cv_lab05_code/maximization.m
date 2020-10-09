function [mu, var, alpha] = maximization(P, X)

    K = size(P,2);
    L = size(X,1);
    dim = size(X,2);
    %mu calculation
    mu = zeros(K, dim);
    alpha = 1/L * sum(P);
    for k=1:K
        mu(k,:) = sum(X(:,:) .* repmat(P(:,k),1,dim)) ./ sum(P(:,k));
    end
    %calculation of covariances
    cov = zeros(dim, dim, K);
    for k=1:K
        %d = X - ones(L,1) * mu(k, :);
        for l=1:L
            cov(:,:,k) = cov(:,:,k) + P(l,k) * (X(l, :) - mu(k, :))' * (X(l, :) - mu(k, :));
        end
        cov(:,:,k) = cov(:,:,k) ./ sum(P(:,k));
    end
    var = cov;
    
end
