function diffs = diffsGC(img1, img2, dispRange)
    % get data costs for graph cut
    window_size = 7;
    [rows_num, cols_num]=size(img1);
    diffs = zeros(rows_num, cols_num, length(dispRange));
    for i=1:length(dispRange) 
    % ?Compute for each pixel the SSD at each disparity
        img1_shifted = shiftImage(img1, dispRange(i));
        ssd = (img2 - img1_shifted).^2;
        filter = fspecial('average', window_size); 
        convolved_output = conv2(ssd, filter, 'same'); %mighht not include this one?   
    % ? Store SSD values in a m x n x r matrix, where m x n is the
    % image size and r is the number of disparities (labels)
        diffs(:, :, i) = convolved_output;
    end
end