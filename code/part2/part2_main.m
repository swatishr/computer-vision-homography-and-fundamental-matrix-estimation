%This file needs to be run for Part 2 and section 3.
%It generates putative matches, calls RANSAC and get inliers

addpath(genpath('../')); %To use the functions written in part1

%Initialization of parameters
sigma = 2;
thresh = 0.01; 
radius = 2;
window_size = 9;
distance_threshold = 7;

%Read image 1 and image 2
I1 = imread('../../data/part2/house1.jpg');
I2 = imread('../../data/part2/house1.jpg');
%matches = load('../../data/part2/house_matches.txt'); 

%convert into grayscale and double
img1 = im2double(I1);
img2 = im2double(I2);
img1 = rgb2gray(img1);
img2 = rgb2gray(img2);

%apply harris detector on both images and get the keypoints
[cim1, r1, c1] = harris(img1, sigma, thresh, radius, 0);
[cim2, r2, c2] = harris(img2, sigma, thresh, radius, 0);

%For image 1, extract neighborhood for each keypoint
[neighbor1, corr1] = extractNeighborhood2(img1, r1, c1, window_size);
for i=1:size(corr1,1)
    neighbor1(i,:) = (neighbor1(i,:) - mean(neighbor1(i,:)))/std(neighbor1(i,:));
end

%For image 2, extract neighborhood for each keypoint
[neighbor2, corr2] = extractNeighborhood2(img2, r2, c2, window_size);
for i=1:size(corr2,1)
    neighbor2(i,:) = (neighbor2(i,:) - mean(neighbor2(i,:)))/std(neighbor2(i,:));
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
plot_lines(img1, img2, image1_points, image2_points, "Putative Matches");

%RANSAC
%matches = load('house_matches.txt'); 
[F, inliers_img1, inliers_img2, max_pt_line_dist] = ransac_part2(image1_points, image2_points);
%[F, inliers_img1, inliers_img2, max_pt_line_dist] = ransac_part2(matches(:,1:2), matches(:,3:4));
plot_lines(img1, img2, inliers_img1, inliers_img2, "After RANSAC");

%report number of inliers, average residual of inliers
N = size(image1_points, 1);
residual1 = sum(max_pt_line_dist .^ 2)/N;
fprintf("\nResidual for Image 2: %.4f", residual1);
fprintf("\nNumber of inliers: %d", size(inliers_img1, 1));