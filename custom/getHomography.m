function [H] = getHomography(img1, img2)

%Initializing all the parameters
sigma = 2;              %sigma value for harris detector
thresh = 0.01;          %Threshold for harris detector
radius = 2;             %Radius for the keypoints to be displayed
window_size = 9;        %Neighborhood window size
distance_threshold = 10; %Threshold for point pair distance

%convert into grayscale and double
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
%plot_lines(img1, img2, inliers_img1, inliers_img2, "After RANSAC");

end