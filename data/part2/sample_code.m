%%
%% load images and match files for the first example
%%

I1 = imread('house1.jpg');
I2 = imread('house2.jpg');
matches = load('house_matches.txt'); 
% this is a N x 4 file where the first two numbers of each row
% are coordinates of corners in the first image and the last two
% are coordinates of corresponding corners in the second image: 
% matches(i,1:2) is a point in the first image
% matches(i,3:4) is a corresponding point in the second image

N = size(matches,1);

%%
%% display two images side-by-side with matches
%% this code is to help you visualize the matches, you don't need
%% to use it to produce the results for the assignment
%%
figure;
imshow([I1 I2]); hold on;
plot(matches(:,1), matches(:,2), '+r');
plot(matches(:,3)+size(I1,2), matches(:,4), '+r');
line([matches(:,1) matches(:,3) + size(I1,2)]', matches(:,[2 4])', 'Color', 'r');
pause;

%%
%% display second image with epipolar lines reprojected 
%% from the first image
%%

method = "normalized";

if(method == "normalized")
    F = compute_norm_fundamental(matches);
else
    % first, fit fundamental matrix to the matches
    F = fit_fundamental(matches);
end

%-------------------------------------------------------------------------

%To plot epipolar line on Image 1
L1 = (F' * [matches(:,3:4) ones(N,1)]')';
L1 = L1 ./ repmat(sqrt(L1(:,1).^2 + L1(:,2).^2), 1, 3); % rescale the line
pt_line_dist1 = sum(L1 .* [matches(:,1:2) ones(N,1)],2);
closest_pt1 = matches(:,1:2) - L1(:,1:2) .* repmat(pt_line_dist1, 1, 2);
pt11 = closest_pt1 - [L1(:,2) -L1(:,1)] * 10; % offset from the closest point is 10 pixels
pt12 = closest_pt1 + [L1(:,2) -L1(:,1)] * 10;
% display points and segments of corresponding epipolar lines
figure;
imshow(I1); hold on;
plot(matches(:,1), matches(:,2), '+r');
line([matches(:,1) closest_pt1(:,1)]', [matches(:,2) closest_pt1(:,2)]', 'Color', 'r');
line([pt11(:,1) pt12(:,1)]', [pt11(:,2) pt12(:,2)]', 'Color', 'g');

%-------------------------------------------------------------------------------------

%To plot epipolar lines on image 2:
L = (F * [matches(:,1:2) ones(N,1)]')'; % transform points from 
% the first image to get epipolar lines in the second image

% find points on epipolar lines L closest to matches(:,3:4)
L = L ./ repmat(sqrt(L(:,1).^2 + L(:,2).^2), 1, 3); % rescale the line
pt_line_dist = sum(L .* [matches(:,3:4) ones(N,1)],2);
closest_pt = matches(:,3:4) - L(:,1:2) .* repmat(pt_line_dist, 1, 2);

% find endpoints of segment on epipolar line (for display purposes)
pt1 = closest_pt - [L(:,2) -L(:,1)] * 10; % offset from the closest point is 10 pixels
pt2 = closest_pt + [L(:,2) -L(:,1)] * 10;

% display points and segments of corresponding epipolar lines
figure;
imshow(I2); hold on;
plot(matches(:,3), matches(:,4), '+r');
line([matches(:,3) closest_pt(:,1)]', [matches(:,4) closest_pt(:,2)]', 'Color', 'r');
line([pt1(:,1) pt2(:,1)]', [pt1(:,2) pt2(:,2)]', 'Color', 'g');

%Residual Error
residual_error1 = immse([matches(:,1:2), ones(size(matches,1),1)], L1) %sum((matches(:,1:2)-L1(:,1:2)).^2);
residual_error2 = immse([matches(:,3:4), ones(size(matches,1),1)], L) 
