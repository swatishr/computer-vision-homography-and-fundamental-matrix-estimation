function [maxH, maxinliers_img1, maxinliers_img2] = ransac(image1_points, image2_points)
%
h = size(image1_points, 1);
N = 5000;
inlier_dist_thresh = 10;
inlier_maxcount = -99;
random_pts = 4;

%for N interations
for iterations=1:N
    
    %find 4 random pixels in both image1 and image2
    n1 = numel(image1_points(:,1));
    idx = randperm(n1,random_pts);
    src = image1_points(idx,:);
    dest = image2_points(idx,:);
    
    H = computeHomography(src, dest);
    inliers_img1 = [];
    inliers_img2 = [];
    for i=1:h
        A = [image1_points(i,1); image1_points(i,2); 1];
        B = H * A;
        B = B/B(3,1); B=B';
        distx = pdist2(B(1:2), image2_points(i,:));
        if(distx < inlier_dist_thresh)
            A = A';
            inliers_img1 = [inliers_img1;A(1:2)];
            inliers_img2 = [inliers_img2;image2_points(i,:)];
        end
    end
    if(~isempty(inliers_img1)) 
        if(numel(inliers_img1(:,1)) > inlier_maxcount)
            maxH = H;
            maxinliers_img1 = inliers_img1;
            maxinliers_img2 = inliers_img2;
            inlier_maxcount = numel(inliers_img1(:,1));
        end
    end
end

%report number of inliers, average residual of inliers, 

end