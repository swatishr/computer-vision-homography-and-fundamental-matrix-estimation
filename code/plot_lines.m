function plot_lines(image1, image2, image1_points, image2_points)

figure;
% imshow(image1);
hold on;
imshow([image1, image2]);
% img=[image1;image2];
% imshow(img)
width = size(image1, 2);

hold on;
plot(image1_points(:, 1),image1_points(:, 2),'oy');
hold on;
plot(image2_points(:, 1)+width,image2_points(:, 2),'+c');
truesize;

for i=1:size(image1_points, 1)
    plot([image1_points(i, 1) (image2_points(i, 1)+width)],[image1_points(i, 2) image2_points(i, 2)], 'r');
end
end