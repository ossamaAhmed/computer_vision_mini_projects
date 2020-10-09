function X_nsamp = get_samples(X, nsamp)
 X_nsamp = datasample(X, nsamp, 1, 'Replace',false);
end