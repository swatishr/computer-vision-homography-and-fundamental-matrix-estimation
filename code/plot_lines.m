function plot_lines(image1, image2, image1_points, image2_points)

figure;
imagesc([image1, image2]);
width = size(image1, 2);

hold on;

for i=1:size(image1_points, 1)
    plot([image1_points(i, 2) (image2_points(i, 2)+width)], [image1_points(i, 1) (image2_points(i, 1))],'r', 'LineWidth', 1);
end

end