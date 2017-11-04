
%Constants
sigma = 2;
thresh = 0.01;
radius = 2;
window_size = 3;
distance_threshold = 0.005;

%Read image 1 and image 2
img1 = imread('../data/part1/uttower/left.jpg');
img2 = imread('../data/part1/uttower/right.jpg');

%convert into grayscale and double
img1 = rgb2gray(img1);
img1 = im2double(img1);
img2 = rgb2gray(img2);
img2 = im2double(img2);

%apply harris detector on both images and get the keypoints
[cim1, r1, c1] = harris(img1, sigma, thresh, radius);
[cim2, r2, c2] = harris(img2, sigma, thresh, radius);
% figure;
% imshow(cim1);
% figure;
% imshow(cim2);

%total number of keypoints in both images
keypoints1_count = size(r1, 1);
keypoints2_count = size(r2, 1);

%For image 1, extract neighborhood for each keypoint
neighbor1 = zeros(keypoints1_count, window_size^2);
for i=1:keypoints1_count
    fneighbor_arr = extractNeighborhood(img1, r1(i), c1(i), window_size);
    neighbor1(i, :) = fneighbor_arr;
end

%For image 2, extract neighborhood for each keypoint
neighbor2 = zeros(keypoints2_count, window_size^2);
for i=1:keypoints2_count
    fneighbor_arr = extractNeighborhood(img2, r2(i), c1(i), window_size);
    neighbor2(i, :) = fneighbor_arr;
end

%Compute distances between every descriptor in image 1 with that in image 2
distance_matrix = dist2(neighbor1, neighbor2);

%Only consider those descriptors above certain threshold
distance_matrix2 = distance_matrix < distance_threshold;