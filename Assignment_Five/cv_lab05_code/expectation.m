function P = expectation(mu,var,alpha,X)
    K = length(alpha);
    L = size(X,1);

    P = zeros(L, K);
    for l=1:L
        for k=1:K
            xl = X(l, :);
            exponent = -0.5 * (xl - mu(k, :)) * inv(var(:, :, k)) * (xl - mu(k, :))';
            P(l, k) = (1/((((2*pi)^(size(X,2)/2)))* sqrt(det(var(:, :, k))))) * exp(exponent) * alpha(k);
        end
        P(l, :) = P(l, :) ./ sum(P(l, :));
    end
end