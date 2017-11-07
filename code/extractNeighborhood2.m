function [neighbor_arr, corr] = extractNeighborhood2(image,x_coordinate, y_coordinate, window_size)
%
% Usage:  fneighbor_arr = extractNeighborhood(image, x_coordinate, y_coordinate, window_size)
% Extract local neighborhoods around every keypoint in both images, and form descriptors by
% flattening the pixel values in each neighborhood to one-dimensional vectors
% Arguments:   
%       image - image from which we have to extract neighborhood pixel values.
%       x_coordinate - keypoint's x coordinate in image
%       y_coordinate - keypoint's x coordinate in image
%       window_size - Neighborhood size
% Returns:   
%       fneighbor_arr - flattened neighborhood descriptor for the given keypoint
  [h,w] = size(image);
  offset = (window_size - 1)/2;
  % disp(x_coordinate);
  % disp(y_coordinate);
  % if(x_coordinate <= offset)
  %     img = padarray(image, [offset 0], 'replicate', 'pre');
  %     x_coordinate = x_coordinate + offset;
  % elseif(x_coordinate >= (size(image, 1)-offset+1))
  %     img = padarray(image, [offset 0], 'replicate', 'post');
  %     %x_coordinate = x_coordinate - offset;
  % end
  % if(y_coordinate <= offset)
  %     img = padarray(img, [0 offset], 'replicate', 'pre');
  %     y_coordinate = y_coordinate + offset;
  % elseif(y_coordinate >= (size(image, 2)-offset+1))
  %     img = padarray(img, [0 offset], 'replicate', 'post');
  %     %y_coordinate = y_coordinate - offset;
  % end
  K=0;
  neighbor_arr = zeros(size(x_coordinate,1),window_size,window_size);
  corr = zeros(size(x_coordinate,1),2);

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
      corr(K,1) = X;
      corr(K,2) = Y;
    end
  end
  corr = corr(1:K,:);
  neighbor_arr = neighbor_arr(1:K,:,:);
  neighbor_arr = reshape(neighbor_arr, [], window_size^2);
  %  if(x_coordinate <= offset)
  %     img = padarray(image, [offset 0], 'replicate', 'pre');
  % elseif(x_coordinate >= (size(image, 1)-offset+1))
  %     img = padarray(image, [offset 0], 'replicate', 'post');
  %     %x_coordinate = x_coordinate - offset;
  % end
  % if(y_coordinate <= offset)
  %     img = padarray(img, [0 offset], 'replicate', 'pre');
  %     y_coordinate = y_coordinate + offset;
  % elseif(y_coordinate >= (size(image, 2)-offset+1))
  %     img = padarray(img, [0 offset], 'replicate', 'post');
  %     %y_coordinate = y_coordinate - offset;
  % end

  % disp(x_coordinate);
  % disp(y_coordinate);
  % start_x = x_coordinate - offset;
  % end_x = x_coordinate + offset;
  % start_y = y_coordinate - offset;
  % end_y = y_coordinate + offset;
  
  % neighbor_arr = img(start_x:end_x, start_y:end_y);
  % fneighbor_arr = reshape(neighbor_arr, [1, window_size^2]);
  % if(x_coordinate< 20 || y_coordinate< 20)
  %   fneighbor_arr
  % end
end