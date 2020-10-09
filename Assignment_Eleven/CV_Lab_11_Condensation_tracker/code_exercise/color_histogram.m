function hist = color_histogram(x1,y1,x2,y2,img,nBins)
hist_results = zeros(3, nBins); %RGB
x1 = floor(x1);
x2 = floor(x2);
y1 = floor(y1);
y2 = floor(y2);
max_height = size(img, 1);
max_width = size(img, 2);
if x1 <= 0
    x1 = 1;
end
if y1 <= 0
    y1 = 1;
end
if x2 > max_width
    x2 = max_width;
end
if y2 > max_height
    y2 = max_height;
end
edges = linspace(0, 256, nBins+1);
bb_r = img(y1:y2, x1:x2, 1); %maybe switch x and y
bb_g = img(y1:y2, x1:x2, 2);
bb_b = img(y1:y2, x1:x2, 3);
hist_results(1, :) = histcounts(bb_r,edges);
hist_results(2, :) = histcounts(bb_g,edges);
hist_results(3, :) = histcounts(bb_b,edges);
hist = hist_results;
end