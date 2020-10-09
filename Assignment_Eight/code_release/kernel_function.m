function  [r] = kernel_function(t)
    r = (t .^ 2) .* log(t .^ 2);
end