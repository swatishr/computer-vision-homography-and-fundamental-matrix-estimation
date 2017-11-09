function [H] = ransac(image1_points, image2_points)
%
h = size(image1_points, 1);
N = 1000;
%for N interations
for iterations=1:N
    
    %find 4 random pixels in both image1 and image2
    n1 = numel(image1_points(:,1));
    idx = randperm(n);
    src = image1_points(idx,:);
    dest = image2_points(idx,:);
    
    H = computeHomography(src, dest);
    
    for i=1:h
        
    end
end

src = [141, 131;480, 159 ;493, 630;64, 601];
dest = [318, 256;534, 372;316, 670;73, 473];



end