function [maxF, maxinliers_img1, maxinliers_img2, max_pt_line_dist, index] = ransac_part2(image1_points, image2_points)
%
h = size(image1_points, 1);
N = 2000;
inlier_dist_thresh = 3;
inlier_maxcount = -99;
random_pts = 8;
maxF = [];
dist = zeros(N, h);
%for N interations
for iterations=1:N
    
    %find 8 random pixels in both image1 and image2
    n1 = numel(image1_points(:,1));
    idx = randperm(n1,random_pts);
    src = image1_points(idx,:);
    dest = image2_points(idx,:);
    
    F = compute_norm_fundamental([src, dest]);
    inliers_img1 = [];
    inliers_img2 = [];
    L = (F * [image1_points ones(h,1)]')'; % transform points from 
    L = L ./ repmat(sqrt(L(:,1).^2 + L(:,2).^2), 1, 3); % rescale the line
    pt_line_dist = abs(sum(L .* [image2_points ones(h,1)],2));
    %closest_pt = image2_points(:) - L(:,1:2) .* repmat(pt_line_dist, 1, 2);
    index = find(pt_line_dist < inlier_dist_thresh);
    inliers_img1 = [inliers_img1;image1_points(index, :)];
    inliers_img2 = [inliers_img2;image2_points(index,:)];
%     for i=1:h
%         %A = [image1_points(i,1); image1_points(i,2); 1]; 
%         %B = [image2_points(i,1); image2_points(i,2); 1]; 
%         %B = B/B(3,1); 
%         %B=B';
%         %distx = (B' * F * A) ^2; %linear estimation of residual error
%         %disp(distx);
%         L = (F * [image1_points(i, :) 1]')';
%         L = L / (sqrt(L(:,1).^2 + L(:,2).^2));
%         pt_line_dist = L * [image2_points(i, :) 1]';
%         dist(iterations, i) = pt_line_dist ^ 2;
%         if(pt_line_dist < inlier_dist_thresh)
%             inliers_img1 = [inliers_img1;image1_points(i, :)];
%             inliers_img2 = [inliers_img2;image2_points(i,:)];
%         end
%     end
    if(~isempty(inliers_img1)) 
        if(numel(inliers_img1(:,1)) > inlier_maxcount)
            maxF = F;
            max_pt_line_dist = pt_line_dist;
            maxinliers_img1 = inliers_img1;
            maxinliers_img2 = inliers_img2;
            inlier_maxcount = numel(inliers_img1(:,1));
        end
    end
end

%report number of inliers, average residual of inliers, 

end