function [neighbor_arr, coor] = extractNeighborhood2(image,x_coordinate, y_coordinate, window_size)
%
% Usage:  [fneighbor_arr, corr] = extractNeighborhood(image, x_coordinate, y_coordinate, window_size)
% Extract local neighborhoods around every keypoint in both images, and form descriptors by
% flattening the pixel values in each neighborhood to one-dimensional vectors
% Arguments:   
%       image - image from which we have to extract neighborhood pixel values.
%       x_coordinate - x coordinate of all keypoints in image
%       y_coordinate - y coordinate of all keypoints in image
%       window_size - Neighborhood size
% Returns:   
%       neighbor_arr - flattened neighborhood descriptor for the given keypoint
%       corr - coordinates of keypoints
  [h,w] = size(image);
  offset = (window_size - 1)/2;
  
  K=0;
  neighbor_arr = zeros(size(x_coordinate,1),window_size,window_size);
  coor = zeros(size(x_coordinate,1),2);

  for i=1:size(x_coordinate,1)
    X=x_coordinate(i,1);%feature point coordinates returned by the harris detector
    Y=y_coordinate(i,1);
    if(X-offset>0 && Y-offset>0 && X+offset<h && Y+offset<w)
      K=K+1;
      start_x = X - offset;
      end_x = X + offset;
      start_y = Y - offset;
      end_y = Y + offset;
      neighbor_arr(K,:,:) = image(start_x:end_x, start_y:end_y);
      coor(K,1) = Y;
      coor(K,2) = X;
    end
  end
  coor = coor(1:K,:);
  neighbor_arr = neighbor_arr(1:K,:,:);
  neighbor_arr = reshape(neighbor_arr, [], window_size^2);
end