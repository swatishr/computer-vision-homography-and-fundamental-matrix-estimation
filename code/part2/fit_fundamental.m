function [F] = fit_fundamental(matches)
%Estimate fundamental matrix using unnormalized algorithm

    X(:,1) = matches(:,3) .* matches(:,1);
    X(:,2) = matches(:,3) .* matches(:,2);
    X(:,3) = matches(:,3);
    X(:,4) = matches(:,4) .* matches(:,1);
    X(:,5) = matches(:,4) .* matches(:,2);
    X(:,6) = matches(:,4);
    X(:,7) = matches(:,1);
    X(:,8) = matches(:,2);
    X(:,9) = 1;
    
    [U, S, V] = svd(X);
    F = V(:, end);
    F = reshape(F, [3 3]);
    F = F';
    
    %SVD of F
    [Uf, Sf, Vf] = svd(F);
    Sf(3,3) = 0;
    F = Uf * Sf * Vf';
end