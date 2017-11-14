
%Load camera1, camera2 matrices and ground-truth matches
p1 = load('house1_camera.txt');
p2 = load('house2_camera.txt');
matches = load('house_matches.txt'); 

%Calculate camera 1 and camera 2 centres
[~, ~, V1] = svd(p1);
temp = V1(:, end);
temp = temp/temp(4,1);
camera1_center = temp(1:3)';

[~, ~, V2] = svd(p2);
temp = V2(:, end);
temp = temp/temp(4,1);
camera2_center = temp(1:3)';

%Reconstruct world coordinates

A = zeros(4,4);
world_coordinate = zeros(size(matches,1), 3);

for i=1:size(matches,1)
   x1 = matches(i,1); y1 = matches(i,2);
   x2 = matches(i,3); y2 = matches(i,4);
   
   A(1,:) = y1 * p1(3,:) - p1(2, :);
   A(2,:) = p1(1,:) - x1 * p1(3, :);
   A(3,:) = y2 * p2(3,:) - p2(2, :);
   A(4,:) = p2(1,:) - x2 * p2(3, :);
   
   [~, ~, Va] = svd(A);
   wc = Va(:,end);
   temp = (wc/wc(4,1))';
   world_coordinate(i,:) = temp(1:3);
end

figure;
axis equal;
plot3(world_coordinate(:,1),world_coordinate(:,2),world_coordinate(:,3), '.g'); hold on;
plot3(camera1_center(:,1),camera1_center(:,2),camera1_center(:,3), '*r'); hold on;
plot3(camera2_center(:,1),camera2_center(:,2),camera2_center(:,3), '*r');