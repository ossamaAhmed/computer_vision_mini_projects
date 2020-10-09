function main()
    clc;
    clear;
    close all;
    

    sizeCodebookRange = linspace(100, 200, 2);
    iterations_range = linspace(5, 50, 10);
    samples_num = 2;
    nn_accuracies = zeros(size(sizeCodebookRange, 2), samples_num);
    bc_accuracies = zeros(size(sizeCodebookRange, 2), samples_num);

    for i=1:size(sizeCodebookRange,2)
        for j=1:samples_num
            disp('creating codebook');
            sizeCodebook = sizeCodebookRange(i);
            numIterations = 10;
            vCenters = create_codebook('../new_dataset/pos',sizeCodebook,numIterations);
            %keyboard;
            disp('processing positve training images');
            vBoWPos = create_bow_histograms('../new_dataset/pos',vCenters);
            disp('processing negative training images');
            vBoWNeg = create_bow_histograms('../new_dataset/neg',vCenters);
            %vBoWPos_test = vBoWPos;
            %vBoWNeg_test = vBoWNeg;
            %keyboard;
            disp('processing positve testing images');
            vBoWPos_test = create_bow_histograms('../new_dataset/pos_test',vCenters);
            disp('processing negative testing images');
            vBoWNeg_test = create_bow_histograms('../new_dataset/neg_test',vCenters);

            nrPos = size(vBoWPos_test,1);
            nrNeg = size(vBoWNeg_test,1);

            test_histograms = [vBoWPos_test;vBoWNeg_test];
            labels = [ones(nrPos,1);zeros(nrNeg,1)];

            disp('______________________________________')
            disp('Nearest Neighbor classifier')
            nn_accuracies(i,j) = bow_recognition_multi(test_histograms, labels, vBoWPos, vBoWNeg, @bow_recognition_nearest);
            disp('______________________________________')
            disp('Bayesian classifier')
            bc_accuracies(i,j) = bow_recognition_multi(test_histograms, labels, vBoWPos, vBoWNeg, @bow_recognition_bayes);
            disp('______________________________________')
        end
    end
    
    figure(13);
    hold on
    for i=1:size(bc_accuracies,2)
        scatter(sizeCodebookRange, nn_accuracies(:, i), [], 'r');
    end
    hold on
    for i=1:size(bc_accuracies,2)
        scatter(sizeCodebookRange, bc_accuracies(:, i), [], 'b');
    end
    hold on
    plot(sizeCodebookRange, mean(nn_accuracies, 2), 'DisplayName','Nearest Neighbor mean');
    hold on
    plot(sizeCodebookRange, mean(bc_accuracies, 2), 'DisplayName','Bayesian Classification');
    legend('Location','southeast');
    title('Categorization');
    xlabel('CodeBook size');
    ylabel('Accuracy');
end