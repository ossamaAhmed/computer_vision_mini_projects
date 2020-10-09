function label = bow_recognition_bayes( histogram, vBoWPos, vBoWNeg)


[muPos, sigmaPos] = computeMeanStd(vBoWPos);
[muNeg, sigmaNeg] = computeMeanStd(vBoWNeg);
num_of_words = size(histogram, 1);
%columns to be skipped
pos_skip = (sigmaPos == 0) | (muPos == 0);
neg_skip = (sigmaNeg == 0) | (muPos == 0);

% Calculating the probability of appearance each word in observed histogram
% according to normal distribution in each of the positive and negative bag of words
counts_positive = normpdf(histogram,muPos,sigmaPos);%BUG HERE
counts_negative = normpdf(histogram,muNeg,sigmaNeg);
prior = 0.5;
% prob_positive = counts_positive .* prior;
% prob_negative = counts_negative .* prior;
prob_positive = counts_positive;
prob_negative = counts_negative;
prob_positive(pos_skip) = 1;
prob_negative(neg_skip) = 1;
prob_positive = log(prob_positive);
prob_positive = sum(prob_positive);
prob_positive = prob_positive + log(prior);
prob_negative = log(prob_negative);
prob_negative = sum(prob_negative);
prob_negative = prob_negative + log(prior);
 if (prob_positive>prob_negative)
    label = 1;
  else
    label = 0;
  end
end