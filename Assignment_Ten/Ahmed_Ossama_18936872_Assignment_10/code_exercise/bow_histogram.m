function histo = bow_histogram(vFeatures, vCenters)
  % input:
  %   vFeatures: MxD matrix containing M feature vectors of dim. D
  %   vCenters : NxD matrix containing N cluster centers of dim. D
  % output:
  %   histo    : N-dim. vector containing the resulting BoW
  %              activation histogram.
  
  
  % Match all features to the codebook and record the activated
  % codebook entries in the activation histogram "histo".
[assigned_clusters, ~] = findnn(vFeatures, vCenters);
[cluster_fequencies, ~]= hist(assigned_clusters,1:size(vCenters, 1));
histo = cluster_fequencies;
end
