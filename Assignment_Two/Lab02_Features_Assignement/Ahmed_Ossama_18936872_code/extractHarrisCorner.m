% extract harris corner
%
% Input:
%   img           - n x m gray scale image
%   thresh        - scalar value to threshold corner strength
%   
% Output:
%   corners       - 2 x k matrix storing the keypoint coordinates
%   H             - n x m gray scale image storing the corner strength
function [corners, H] = extractHarrisCorner(img, thresh)
%Compute intensity gradients in x and y direction
[Ix, Iy] = gradient(img);
%Blur images to get rid of noise
sigma = 5;
Ix_blurred_sqaured = imgaussfilt(Ix.^2, sigma);
Iy_blurred_sqaured = imgaussfilt(Iy.^2, sigma);
Ix_Iy_blurred = imgaussfilt(Ix.*Iy, sigma);
%Compute Harris response
H=[Ix_blurred_sqaured, Ix_Iy_blurred; 
    Ix_Iy_blurred    , Iy_blurred_sqaured];
%harris response measure is then
K = ((Ix_blurred_sqaured .* Iy_blurred_sqaured) - (Ix_Iy_blurred .*Ix_Iy_blurred)) ./ (Ix_blurred_sqaured + Iy_blurred_sqaured + eps);
hist(K (:),20);
%Threshold the response image
threshold_mask = K > thresh;
%Apply non-maximum suppression
% perform non-maximal suppression using ordfilt2
radius = 3;
non_max = ordfilt2(K, radius^2, ones([radius, radius]));
non_max_mask =  (non_max == K);
keypoints = non_max_mask & threshold_mask;
[rows,cols] = find(keypoints);
%transpose the corners
corners = [rows';
           cols'];
end