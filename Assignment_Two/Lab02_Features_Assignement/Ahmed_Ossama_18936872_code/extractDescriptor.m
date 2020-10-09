% extract descriptor
%
% Input:
%   keyPoints     - detected keypoints in a 2 x n matrix holding the key
%                   point coordinates
%   img           - the gray scale image
%   
% Output:
%   descr         - w x n matrix, stores for each keypoint a
%                   descriptor. m is the size of the image patch,
%                   represented as vector
function descr = extractDescriptor(corners, img)  
descr = zeros(9^2, size(corners, 2));
radius = 4;
for i=1:size(descr, 2) % loop over every corner
    corner_x = corners(1, i);
    corner_y = corners(2, i);
    % check if I can create a patch centered around it or just leave the
    % patch in 0s
    if (corner_x - radius >=1) && (corner_y - radius >=1) && (corner_x + radius <=size(img, 1)) && (corner_y + radius <=size(img, 2))
        patch = img(corner_x - radius:corner_x + radius,corner_y - radius:corner_y + radius);
        descr(:, i) = patch(:);
    end
end
end