% =========================================================================
% Exercise 8
% =========================================================================

% Initialize VLFeat (http://www.vlfeat.org/)

%K Matrix for house images (approx.)
K = [  670.0000     0     393.000
         0       670.0000 275.000
         0          0        1];

%Load images
imgName1 = '../data/house.000.pgm';
imgName2 = '../data/house.004.pgm';

img1 = single(imread(imgName1));
img2 = single(imread(imgName2));

%extract SIFT features and match
[fa, da] = vl_sift(img1);
[fb, db] = vl_sift(img2);
fprintf('Image Size\n');
disp(size(img1))
fprintf('Extracted Features\n');
disp(size(fa))
disp(size(da))

%don't take features at the top of the image - only background
filter = fa(2,:) > 100;
fa = fa(:,find(filter));
da = da(:,find(filter));

[matches_1_5, scores_1_5] = vl_ubcmatch(da, db);
fprintf('Matches between image 1 and image 5\n');
disp(size(matches_1_5))

matched_features_1 = fa(1:2, matches_1_5(1,:));
matched_features_5 = fb(1:2, matches_1_5(2,:));

showFeatureMatches(img1, matched_features_1, img2, matched_features_5, 15);

%% Compute essential matrix and projection matrices and triangulate matched points

%use 8-point ransac or 5-point ransac - compute (you can also optimize it to get best possible results)
%and decompose the essential matrix and create the projection matrices

ransac_threshold = 0.004;
[F_1_5, inliers_1_5] = ransacfitfundmatrix(matched_features_1, matched_features_5, ransac_threshold);

fprintf('inliers size between image 1 and image 2\n');
disp(size(inliers_1_5))
E_1_5 = K' * F_1_5 * K;
fprintf('Matched feature in image 1 size \n');
disp(size(matched_features_1))

matched_features_1_inliers = matched_features_1(:, inliers_1_5(1,:));
matched_features_5_inliers = matched_features_5(:, inliers_1_5(1,:));
matched_features_1_descriptors_inliers = da(:, matches_1_5(1,inliers_1_5(1,:)));

fprintf('Inlier matched feature in image 1 size \n');
disp(size(matched_features_1_inliers))
showFeatureMatches(img1, matched_features_1_inliers, img2, matched_features_5_inliers, 16);

outliers1 = setdiff(matches_1_5(1,:),inliers_1_5(1,:));
showFeatureMatches(img1, fa(1:2, outliers1), img2, fb(1:2, outliers1), 91);

drawnow();
matched_features_1_calibrated = K \ [matched_features_1_inliers; ...
                                     ones(1,size(inliers_1_5,2))];
matched_features_5_calibrated = K \ [matched_features_5_inliers; ...
                                     ones(1,size(inliers_1_5,2))];
Ps{1} = eye(4);
Ps{2} = decomposeE(E_1_5, matched_features_1_calibrated, matched_features_5_calibrated);
[XS_1_5, ~] = linearTriangulation(Ps{1}, matched_features_1_calibrated, Ps{2}, matched_features_5_calibrated);

figure(1), imshow(img1, []); 
hold on;
plot(matched_features_1_inliers(1, :), matched_features_1_inliers(2, :), '*r');
for k = 1:size(inliers_1_5,2)
    drawEpipolarLines(F_1_5'*[matched_features_5_inliers(:,k);1], img1);
end

figure(2), imshow(img2, []); 
hold on;
plot(matched_features_5_inliers(1, :), matched_features_5_inliers(2, :), '*b');
for k = 1:size(inliers_1_5,2)
    drawEpipolarLines(F_1_5*[matched_features_1_inliers(:,k);1], img2);
end

%% Add more views...
% 
%Adding the second view
imgName3 = '../data/house.001.pgm';
img3 = single(imread(imgName3));
[fc, dc] = vl_sift(img3);
%match against the features from image 1 that where triangulated
[matches1_2, ~] = vl_ubcmatch(matched_features_1_descriptors_inliers, dc);
showFeatureMatches(img1, matched_features_1_inliers(1:2, matches1_2(1,:)), img3, fc(1:2, matches1_2(2,:)), 12);
%run 6-point ransac
matched_features_2_calibrated = K\[fc(1:2, matches1_2(2,:));ones(1,size(matches1_2,2)) ];
[Ps{3}, inliers1_2] = ransacfitprojmatrix(matched_features_2_calibrated(1:2,:), XS_1_5(1:3,matches1_2(1,:)), ransac_threshold);

outliers2 = setdiff(matches1_2(1,:),inliers1_2(1,:));
showFeatureMatches(img1, fa(1:2, outliers2), img3, fc(1:2, outliers2), 92);
if (det(Ps{3}(1:3,1:3)) < 0 )
    Ps{3}(1:3, 4) = -Ps{3}(1:3, 4);
    Ps{3}(1:3,1:3) = -Ps{3}(1:3,1:3);
end
XS_1_5_filtered = XS_1_5(1:3,matches1_2(1,inliers1_2(1,:)));
%triangulate the inlier matches with the computed projection matrix
[XS_1_2, ~] = linearTriangulation(Ps{1}, matched_features_1_calibrated(:,matches1_2(1,inliers1_2(1,:))), Ps{3}, matched_features_2_calibrated(:,inliers1_2(1,:)));




%Adding the third view
imgName4 = '../data/house.002.pgm';
img4 = single(imread(imgName4));
[fd, dd] = vl_sift(img4);
[matches1_3, ~] = vl_ubcmatch(matched_features_1_descriptors_inliers, dd);
showFeatureMatches(img1, matched_features_1_inliers(1:2, matches1_3(1,:)), img4, fd(1:2, matches1_3(2,:)), 13);
%run 6-point ransac
matched_features_4_calibrated = K\[fd(1:2, matches1_3(2,:));ones(1,size(matches1_3,2)) ];
[Ps{4}, inliers1_3] = ransacfitprojmatrix(matched_features_4_calibrated(1:2,:), XS_1_5(1:3,matches1_3(1,:)), ransac_threshold);
outliers3 = setdiff(matches1_3(1,:),inliers1_3(1,:));
showFeatureMatches(img1, fa(1:2, outliers3), img4, fd(1:2, outliers3), 93);
if (det(Ps{4}(1:3,1:3)) < 0 )
    Ps{4}(1:3, 4) = -Ps{4}(1:3, 4);
    Ps{4}(1:3,1:3) = -Ps{4}(1:3,1:3);
end
%triangulate the inlier matches with the computed projection matrix
[XS_1_3, ~] = linearTriangulation(Ps{1}, matched_features_1_calibrated(:,matches1_3(1,inliers1_3(1,:))), Ps{4}, matched_features_4_calibrated(:,inliers1_3(1,:)));



%Adding fourth view
imgName5 = '../data/house.003.pgm';
img5 = single(imread(imgName5));
[fe, de] = vl_sift(img5);
[matches1_4, ~] = vl_ubcmatch(matched_features_1_descriptors_inliers, de);
showFeatureMatches(img1, matched_features_1_inliers(1:2, matches1_4(1,:)), img5, fe(1:2, matches1_4(2,:)), 14);
%run 6-point ransac
matched_features_5_calibrated = K\[fe(1:2, matches1_4(2,:));ones(1,size(matches1_4,2)) ];
[Ps{5}, inliers1_4] = ransacfitprojmatrix(matched_features_5_calibrated(1:2,:), XS_1_5(1:3,matches1_4(1,:)), ransac_threshold);
outliers4 = setdiff(matches1_4(1,:),inliers1_4(1,:));
showFeatureMatches(img1, fa(1:2, outliers4), img5, fe(1:2, outliers4), 94);

if (det(Ps{5}(1:3,1:3)) < 0 )
    Ps{5}(1:3, 4) = -Ps{5}(1:3, 4);
    Ps{5}(1:3,1:3) = -Ps{5}(1:3,1:3);
end
[XS_1_4, ~] = linearTriangulation(Ps{1}, matched_features_1_calibrated(:,matches1_4(1,inliers1_4(1,:))), Ps{5}, matched_features_5_calibrated(:,inliers1_4(1,:)));

%% Plot stuff

fig = 10;
figure(fig);
% 
% %use plot3 to plot the triangulated 3D points
drawCameras(Ps, fig);
drawnow();
hold on;
pl1 = plot3(XS_1_5_filtered(1,:),XS_1_5_filtered(2,:),XS_1_5_filtered(3,:),'r*');
pl2 = plot3(XS_1_2(1,:),XS_1_2(2,:),XS_1_2(3,:),'b*');
pl3 = plot3(XS_1_3(1,:),XS_1_3(2,:),XS_1_3(3,:),'g*');
pl4 = plot3(XS_1_4(1,:),XS_1_4(2,:),XS_1_4(3,:),'y*');
set(pl1, 'MarkerSize', 4);
set(pl2, 'MarkerSize', 4);
set(pl3, 'MarkerSize', 4);
set(pl4, 'MarkerSize', 4);
xlabel('x)')
ylabel('y)')
zlabel('z')
grid on
%draw cameras