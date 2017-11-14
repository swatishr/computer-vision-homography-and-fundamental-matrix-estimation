% This file is the starting point of execution for Part 1 i.e. Image Stitching
% Please run this file

%Initializing all the parameters
sigma = 2;              %sigma value for harris detector
thresh = 0.05;          %Threshold for harris detector
radius = 2;             %Radius for the keypoints to be displayed
window_size = 9;        %Neighborhood window size
distance_threshold = 7; %Threshold for point pair distance

%Read image 1 and image 2
img1 = imread('../data/part1/uttower/left.jpg');
img2 = imread('../data/part1/uttower/right.jpg');

%convert into grayscale and double
img1 = im2double(img1); image1 = img1;
img2 = im2double(img2); image2 = img2;
img1 = rgb2gray(img1);
img2 = rgb2gray(img2);

%apply harris detector on both images and get the keypoints
[cim1, r1, c1] = harris(img1, sigma, thresh, radius, 0);
[cim2, r2, c2] = harris(img2, sigma, thresh, radius, 0);

%total number of keypoints in both images
keypoints1_count = size(r1, 1);
keypoints2_count = size(r2, 1);

%For image 1, extract neighborhood for each keypoint
[neighbor1, corr1] = extractNeighborhood2(img1, r1, c1, window_size);
for i=1:size(corr1,1)
    neighbor1(i,:) = (neighbor1(i,:) - mean(neighbor1(i,:)))/std(neighbor1(i,:)); %Normalize
end

%For image 2, extract neighborhood for each keypoint
[neighbor2, corr2] = extractNeighborhood2(img2, r2, c2, window_size);
for i=1:size(corr2,1)
    neighbor2(i,:) = (neighbor2(i,:) - mean(neighbor2(i,:)))/std(neighbor2(i,:)); %Normalize
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

%plot point pairs on images
%plot_lines(img1, img2, image1_points, image2_points, "Putative matches");

%RANSAC
[H, inliers_img1,inliers_img2] = ransac(image1_points, image2_points);
plot_lines(img1, img2, inliers_img1, inliers_img2, "After RANSAC");

%Image stitching

%Transform image 1 by computed Homographic matrix
T = maketform('projective',H');

%XData and YData provides the coordinates of the upper and lower bounds
[img11, XData, YData] = imtransform(image1, T);

%Get the min and max limits in both the images together
x_bound = [min(1, XData(1)) max(size(image2, 2), XData(2))];
y_bound = [min(1, YData(1)) max(size(image2, 1), YData(2))];

%Transform both the images accoding to those bounds
Ta = maketform('affine', [1 0 0; 0 1 0; 0 0 1]);
img11 = imtransform(image1, T, 'XData', x_bound, 'YData', y_bound);
img22 = imtransform(image2, Ta, 'XData', x_bound, 'YData', y_bound);

panorama = img11 + img22;
overlappedArea = img11 & img22;
panorama(overlappedArea) = panorama(overlappedArea)/2;
figure('NumberTitle', 'off', 'Name', 'Stitched image');
imshow(panorama);