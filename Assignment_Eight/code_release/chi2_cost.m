function [C] = chi2_cost(s1,s2)
size_descr_1 = size(s1,1);
size_descr_2 = size(s2,1);
%not sure by adding zeros
cost = zeros(size_descr_1, size_descr_2);
for i=1:size_descr_1
    for j=1:size_descr_2
        first_descr = s1(i, :, :);
        second_descr = s2(j, :, :);
        squared_difference = (first_descr - second_descr).^2;
        summed_descriptor = (first_descr + second_descr);
        test_stochastic_sum = squared_difference ./ summed_descriptor;
        test_stochastic_sum(isnan(test_stochastic_sum))=0;
        test_stochastic_sum = sum(test_stochastic_sum(:));
        cost(i,j) = test_stochastic_sum * 0.5;
    end
end
C = cost;
end