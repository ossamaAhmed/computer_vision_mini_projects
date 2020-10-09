function [map, peaks] = mean_shift(X, r)
    num_pixels = size(X, 1);
    pixel_peaks = zeros(num_pixels, 3);
    map = zeros(num_pixels, 1);
    %calculate for each pixel the peak value
    for i=1:num_pixels
        [peak, cluster_pts] = find_peak(X, X(i,:), r);
        pixel_peaks(i, :) = peak;
    end
    %merge peaks now
    peaks = [];
    segment_iter = 0;
    peaks_indicies = [1:num_pixels];
    while size(peaks_indicies, 2) > 0
        current_peak = pixel_peaks(peaks_indicies(1), :); % pick first peak unclustered
        peaks = [peaks; current_peak];
        distance = sum((repmat(current_peak,size(peaks_indicies, 2), 1) - pixel_peaks(peaks_indicies, :)).^2, 2);
        peaks_to_merge = find(distance < (r/2)^2);
        map(peaks_indicies(peaks_to_merge), :) = segment_iter;
        segment_iter = segment_iter + 1;
        peaks_indicies(peaks_to_merge) = [];
    end
    segment_iter
end