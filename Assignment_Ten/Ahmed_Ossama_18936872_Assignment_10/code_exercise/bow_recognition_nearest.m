function sLabel = bow_recognition_nearest(histogram,vBoWPos,vBoWNeg)
  
 % Find the nearest neighbor in the positive and negative sets
  % and decide based on this neighbor
  %hist size [1, 200]
  %vBowPos size [50 200]
  %VBow NEG size [50 200]
  ...
  distances_pos = (repmat(histogram,size(vBoWPos, 1), 1) - vBoWPos).^2;
  distances_neg = (repmat(histogram, size(vBoWNeg, 1), 1) - vBoWNeg).^2;
  distances_pos = distances_pos';
  distances_neg = distances_neg';
  distances_pos = sum(distances_pos);
  distances_neg = sum(distances_neg);
  distances_pos = sqrt(distances_pos);
  distances_neg = sqrt(distances_neg);
  DistPos = min(distances_pos);
  DistNeg = min(distances_neg);
  if (DistPos<DistNeg)
    sLabel = 1;
  else
    sLabel = 0;
  end
end