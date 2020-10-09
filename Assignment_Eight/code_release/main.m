function [accuracies] = main()
    clc;
    clear;
    close all;

    k = linspace(1, 9, 5);

    accuracies = zeros(1, size(k, 2));
    samples_num = 3;

    for i=1:size(k,2)
        current_mean = 0;
        for j=1:samples_num
            current_mean = current_mean + shape_classification(k(i));
        end
       accuracies(i) = current_mean/samples_num;
       disp('CALCULATED AVERAGE');
       disp(k(i));
       disp(accuracies(i));
    end

    figure(size(k, 2)+1);
    plot(k,accuracies);
end