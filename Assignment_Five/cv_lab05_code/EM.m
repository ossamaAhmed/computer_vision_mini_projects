function [map cluster] = EM(img)
    [row col ch] = size(img);
    K = 3;
    N = row*col;
    X = double(reshape(img,[N ch]));
    % use function generate_mu to initialize mus
    mu = generate_mu(X, K);
    % use function generate_cov to initialize covariances
    cov = generate_cov(X, K);
    alpha=ones(K,1)/K;
    % iterate between maximization and expectation
    old_alpha = alpha;
    while 1
        % use function maximization
        P = expectation(mu,cov,alpha,X);
        % use function expectation
        [mu, cov, alpha] = maximization(P, X);
        if norm(alpha-old_alpha) < 0.001
            break
        end
        old_alpha = alpha;
    end
    [~,map] = max(P,[],2);  
    map = reshape(map,row,col);
    cluster = mu;
end