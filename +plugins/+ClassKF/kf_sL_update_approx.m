function [m, P, K, D] = kf_sL_update_approx(m,P,y,H,R)
    % Approximating the inverse of square root matrix
    N = 5; M = 1;
    Z = eye(length(m));
    Y = P;
    invY = Z;
    invZ = Z;
    for n = 1:N
        for k = 1:M
            invY = 2*invY-invY*Y*invY;
            invZ = 2*invZ-invZ*Z*invZ;
        end
        Y = 0.5*(Y+invZ);
        Z = 0.5*(Z+invY);
    end
    P_sqrtm_right = Z;
    B = H * P;
    K = B*P_sqrtm_right;
    G = K' / (B * H' + R);
    w_t = 1 ./ sqrt(sum(G.' .* K, 1))';
    D = w_t .* P_sqrtm_right;
    % kf_update is the update step of kalman filter
    v = y-H*m;

    S = H*P*H'+R;
    K = (P*H')/S;     % /S is  same as *inv(S) but faster and more accurate

    m = m+K*v;
    P = P-K*S*K';


end

