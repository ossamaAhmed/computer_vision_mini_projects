function disp = stereoDisparity(img1, img2, dispRange)

% dispRange: range of possible disparity values
% --> not all values need to be checked
window_size = 7;
[rows_num, cols_num]=size(img1);
best_disparity_correspondence = Inf(rows_num, cols_num);
disparities = zeros(rows_num, cols_num);

% For each disparity d
for i=1:length(dispRange)   
% ? Shift entire image by d (code provided (shiftImage))
    img1_shifted = shiftImage(img1, dispRange(i));
% ? Compute image difference (SSD, SAD)
    ssd = (img2 - img1_shifted).^2;
% ? Convolve with box filter
% ? Use conv2(..., ?same?) and fspecial(?average?,?)
    filter = fspecial('average', window_size);
    convolved_output = conv2(ssd, filter, 'same');
% ? Remember disparity and ssd differences for each pixel
    mask = best_disparity_correspondence(:,:) > convolved_output(:,:);
    best_disparity_correspondence(mask) = convolved_output(mask);
    disparities(mask) = dispRange(i);
end
disp = disparities;
end