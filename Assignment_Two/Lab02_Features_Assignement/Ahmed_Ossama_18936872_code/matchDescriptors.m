% match descriptors
%
% Input:
%   descr1        - k x n descriptor of first image
%   descr2        - k x m descriptor of second image
%   thresh        - scalar value to threshold the matches
%   
% Output:
%   matches       - 2 x w matrix storing the indices of the matching
%                   descriptors
function matches = matchDescriptors(descr1, descr2, thresh)
matches=[];
for i=1:size(descr1, 2)
    current_descriptor = descr1(:, i);
    %B = repmat(A,[m n])
    current_descriptor = repmat(current_descriptor,[1, size(descr2, 2)]);
    ssd = sum((current_descriptor - descr2) .^ 2);
    %corresponding key point
    [corresponding_key_point_candidate_v, corresponding_key_point_candidate_ind] = min(ssd);
    if size (corresponding_key_point_candidate_v, 1) == 1 & corresponding_key_point_candidate_v > thresh
        %add it as a match
        matches = [matches, [i corresponding_key_point_candidate_ind]'];
    end
end
end