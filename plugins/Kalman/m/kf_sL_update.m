function [m, P, K, D] = kf_sL_update(m,P,y,H,R)
    % Resolution matrix
    P_sqrtm = sqrtm(P);
    B = H * P_sqrtm;
    G = B' / (B * B' + R);
    w_t = 1 ./ sum(G.' .* B, 1)';
    D = w_t .* inv(P_sqrtm);

    % kf_update is the update step of kalman filter
    v = y-H*m;

    S = H*P*H'+R;
    K = (P*H')/S;     % /S is  same as *inv(S) but faster and more accurate

    m = m+K*v;
    P = P-K*S*K';


end

