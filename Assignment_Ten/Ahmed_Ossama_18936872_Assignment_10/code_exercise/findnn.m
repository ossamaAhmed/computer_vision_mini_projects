function [Idx Dist] = findnn( D1, D2 )
  % input:
  %   D1  : NxD matrix containing N feature vectors of dim. D
  %   D2  : MxD matrix containing M feature vectors of dim. D
  % output:
  %   Idx : N-dim. vector containing for each feature vector in D1
  %         the index of the closest feature vector in D2.
  %   Dist: N-dim. vector containing for each feature vector in D1
  %         the distance to the closest feature vector in D2.

  N = size(D1,1);
  M = size(D2,1);
  Idx  = zeros(N,1);
  Dist = zeros(N,1);
  
  % Find for each feature vector in D1 the nearest neighbor in D2
  for i = 1:N
      Idx(i) = -1;
      Dist(i) = inf;
      for j = 1:M
          distance_between_vectors = euclidean_distance(D1(i,:), D2(j,:));
          if Dist(i) > distance_between_vectors
              Idx(i) = j;
              Dist(i) = distance_between_vectors;
          end
      end 
  end
end


function [diff_dist] = euclidean_distance(feature_vector_1, feature_vector_2)
 ssd = (feature_vector_1 - feature_vector_2) .^2;
 ssd = sum(ssd);
 diff_dist = sqrt(ssd);
end