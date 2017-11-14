addpath(genpath('../../code'));
%Constants
sigma = 2;
thresh = 0.01;
radius = 2;
window_size = 9;
distance_threshold = 20;

%Read image 1 and image 2
I1 = imread('house1.jpg');
I2 = imread('house2.jpg');
matches = load('house_matches.txt'); 

%convert into grayscale and double
img1 = im2double(I1);
img2 = im2double(I2);
img1 = rgb2gray(img1);
img2 = rgb2gray(img2);

%apply harris detector on both images and get the keypoints
[cim1, r1, c1] = harris(img1, sigma, thresh, radius, 1);
[cim2, r2, c2] = harris(img2, sigma, thresh, radius, 1);

%total number of keypoints in both images
keypoints1_count = size(r1, 1);
keypoints2_count = size(r2, 1);

%For image 1, extract neighborhood for each keypoint
% neighbor1 = zeros(keypoints1_count, window_size^2);
% fneighbor_arr = zeros(1, window_size^2);
[neighbor1, corr1] = extractNeighborhood2(img1, r1, c1, window_size);
size(corr1,1)
for i=1:size(corr1,1)
    neighbor1(i,:) = (neighbor1(i,:) - mean(neighbor1(i,:)))/std(neighbor1(i,:));
    % neighbor1(i, :) = fneighbor_arr;
end
    % pause

%For image 2, extract neighborhood for each keypoint
[neighbor2, corr2] = extractNeighborhood2(img2, r2, c2, window_size);
size(corr2,1)
for i=1:size(corr2,1)
    neighbor2(i,:) = (neighbor2(i,:) - mean(neighbor2(i,:)))/std(neighbor2(i,:));
    % neighbor1(i, :) = fneighbor_arr;
    % pause
end

%Compute distances between every descriptor in image 1 with that in image 2
distance_matrix = dist2(neighbor1, neighbor2);

%find indices of those descriptors above certain threshold
[row, col] = find(distance_matrix < distance_threshold);

%store the putative matches in a list of point pairs
image1_points = zeros(size(row, 1),2);
image2_points = zeros(size(col, 1),2);
image1_points(:, 1) = corr1(row,1);
image1_points(:, 2) = corr1(row,2);
image2_points(:, 1) =  corr2(col,1);
image2_points(:, 2)= corr2(col,2);
plot_lines(img1, img2, image1_points, image2_points);

%RANSAC
[F, inliers_img1, inliers_img2, dist, index] = ransac_part2(image1_points, image2_points);
plot_lines(img1, img2, inliers_img1, inliers_img2);