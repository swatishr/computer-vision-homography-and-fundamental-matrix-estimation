function [H] = commputeHomography(src, dest)
%Function to compute homography
    A = zeros(8, 9);
    A(1:2:8, 1) = src(:, 1);
    A(1:2:8, 2) = src(:, 2);
    A(1:2:8, 3) = 1;
    A(2:2:8, 4) = src(:, 1);
    A(2:2:8, 5) = src(:, 2);
    A(2:2:8, 6) = 1;
    A(1:2:8, 7) = -(src(:,1) .* dest(:, 1)); A(2:2:8, 7) = -(src(:,1) .* dest(:, 2));
    A(1:2:8, 8) = -(src(:,2) .* dest(:, 1)); A(2:2:8, 8) = -(src(:,2) .* dest(:, 2));
    A(1:2:8, 9) = -dest(:, 1); A(2:2:8, 9) = -dest(:, 2);

    [~,~, V] = svd(A);
    H = V(:, end);
    H = reshape(H, [3 3]);
    H=H/H(3,3);
    H = H';
end