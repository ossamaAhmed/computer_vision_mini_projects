function vCenters = kmeans(vFeatures,k,numiter)

  nPoints  = size(vFeatures,1);
  nDims    = size(vFeatures,2);
  %vCenters = rand(k,nDims);
  
  assigned_clusters = zeros(nPoints, 1);

  % Initialize each cluster center to a different random point.
vCenters = datasample(vFeatures,k, 1, 'Replace',false);
  % Repeat for numiter iterations
  for i=1:numiter
    % Assign each point to the closest cluster
    [assigned_clusters, Dist] = findnn(vFeatures, vCenters);
    % Shift each cluster center to the mean of its assigned points
    for cluster_idx=1:k
        %get the mean of it all the assigned_pts
        cluster_vectors_mask = (assigned_clusters == cluster_idx);
        cluster_vectors = vFeatures(cluster_vectors_mask, :);
        if size(cluster_vectors, 1) > 0
            vCenters(cluster_idx, :) = mean(cluster_vectors);
        end
    end
    disp(strcat(num2str(i),'/',num2str(numiter),' iterations completed.'));
  end
end