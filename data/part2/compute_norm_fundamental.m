function [F] = compute_norm_fundamental(matches)
    x_mean1 = mean(matches(:,1));
    y_mean1 = mean(matches(:,2));
    sigmax1 = var(matches(:,1));
    sigmay1 = var(matches(:,2));
    x_mean2 = mean(matches(:,3));
    y_mean2 = mean(matches(:,4));
    sigmax2 = var(matches(:,3));
    sigmay2 = var(matches(:,4));
%     x_mean1 = mean(matches(:,1));
%     y_mean1 = mean(matches(:,2));
%     sigmax1 = max(matches(:,1));
%     sigmay1 = max(matches(:,2));
%     x_mean2 = mean(matches(:,3));
%     y_mean2 = mean(matches(:,4));
%     sigmax2 = max(matches(:,3));
%     sigmay2 = max(matches(:,4));
    T1 = zeros(3, 3);
    T1 = [1/sigmax1 0 -x_mean1/sigmax1; 0 1/sigmay1 -y_mean1/sigmay1;0 0 1];
    A1 = [matches(:,1:2), ones(size(matches,1),1)];
    B1 = T1 * A1';
    B1 = B1';
    
    T2 = [1/sigmax2 0 -x_mean2/sigmax1; 0 1/sigmay2 -y_mean2/sigmay2;0 0 1];
    A2 = [matches(:,3:4), ones(size(matches,1),1)];
    B2 = T2 * A2';
    B2 = B2';
    
    norm_coor = [B1(:,1:2), B2(:,1:2)];
    F = fit_fundamental(norm_coor);
    F = T2' * F * T1;
    F = F/F(3,3);
end