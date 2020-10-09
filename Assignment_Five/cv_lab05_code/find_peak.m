function [peak, cluster_pts]  = find_peak(X, xl , r)

peak = xl;
num_of_pixels = size(X,1);
while 1 %until convergence
    %calculate distance of pixels to the current peak
    distance = sum((repmat(peak,num_of_pixels, 1) - X).^2, 2); %euclidean distance
    %find points in the cluster
    cluster_pts = find(distance < r^2);
    new_mean = mean(X(cluster_pts,:),1);
    if norm(new_mean - peak) < .01*r
        break; 
    end
    peak = new_mean;
end
end


