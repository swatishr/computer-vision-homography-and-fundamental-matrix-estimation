function [dist] = nonlinear_residual(F, image1_points, image2_points)

N = size(image1_points,1);
L = (F * [image1_points(:) ones(N,1)]')'; % transform points from 
% the first image to get epipolar lines in the second image

% find points on epipolar lines L closest to image2_points
L = L ./ repmat(sqrt(L(:,1).^2 + L(:,2).^2), 1, 3); % rescale the line
pt_line_dist = sum(L .* [image2_points(:) ones(N,1)],2);
end