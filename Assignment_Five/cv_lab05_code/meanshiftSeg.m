function [map peak] = meanshiftSeg(img)
    r = 35;
    [row col rest] = size(img);
    X = double(reshape(img,[row*col rest]));
    [map, peak] = mean_shift(X, r);
    map = reshape(map,row,col);
end



