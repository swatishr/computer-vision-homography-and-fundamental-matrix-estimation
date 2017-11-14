% To stitch multiple images

addpath(genpath('../code/')); %To use the functions written in part1
%Read images
input_dir = '../data/part1/tree/';
a = dir(strcat(input_dir, '*.jpg'));
n = numel(a);

image = {};
for i=1:n
    fname = strcat(input_dir, num2str(i), '.jpg');
    image{i} = im2double(imread(fname));
end

panaroma = {};
panaroma{1} = image{1};
j = 2;
for i=1:n-1
%    disp(i);
   H = getHomography(panaroma{i}, image{i+1}); 
%    fprintf("\nSize of image1: %d", size(panaroma{i}));
%    fprintf("\nSize of image2: %d", size(image{i+1}));
   panaroma{j} = stitchImages(panaroma{i}, image{i+1}, H);
   j = j+1;
end

imshow(panaroma{n});

% img1 = imread('../data/part1/hill/1.jpg');
% img2 = imread('../data/part1/hill/2.jpg');
% img3 = imread('../data/part1/hill/3.jpg');
% 
% img1 = im2double(img1); image1 = img1;
% img2 = im2double(img2); image2 = img2;
% img3 = im2double(img3); image2 = img3;
% 
% [H1] = getHomography(img1, img2);
% %Image stitching
% [panaroma1] = stitchImages(img1, img2, H1);
% 
% [H2] = getHomography(panaroma1, img3);
% [panaroma2] = stitchImages(panaroma1, img3, H2);
% figure('NumberTitle', 'off', 'Name', 'Stitched image');
% imshow(panaroma2);