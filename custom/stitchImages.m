function [panorama] = stitchImages(image1, image2, H)
 img11 = [];
 img12 = [];
%Transform image 1 by computed Homographic matrix
T = maketform('projective',H');

%XData and YData provides the coordinates of the upper and lower bounds
[~, XData, YData] = imtransform(image1, T,'XYScale',1);

%Get the min and max limits in both the images together
x_bound = [min(1, XData(1)) max(size(image2, 2), XData(2))];
y_bound = [min(1, YData(1)) max(size(image2, 1), YData(2))];

%Transform both the images accoding to those bounds
Ta = maketform('affine', [1 0 0; 0 1 0; 0 0 1]);
img11 = imtransform(image1, T, 'XData', x_bound, 'YData', y_bound,'XYScale',1);
img22 = imtransform(image2, Ta, 'XData', x_bound, 'YData', y_bound,'XYScale',1);
% fprintf("\nSize of transform image1: %d", size(img11));
%     fprintf("\nSize of transform image2: %d", size(img22));
panorama = img11 + img22;
overlappedArea = img11 & img22;
average = (img11 + img22)/2;
panorama(overlappedArea) = average(overlappedArea);

end