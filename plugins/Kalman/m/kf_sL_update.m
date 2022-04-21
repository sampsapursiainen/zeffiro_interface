function [m, P, K, D] = kf_sL_update(m,P,y,H,R)
    % Resolution matrix
    method = '2';
    if(method == '1')
    P_sqrtm = sqrtm(P);
    B = H * P_sqrtm;
    G = B' / (B * B' + R);
    w_t = 1 ./ sum(G.' .* B, 1)';
    D = w_t .* inv(P_sqrtm);
    elseif(method == '2')
    [Ur,Sr,Vr] = svd(P);
    Sr = diag(Sr);
    RNK = sum(Sr > (length(Sr) * eps(single(Sr(1)))));
    SIR = Vr(:,1:RNK) * diag(1./sqrt(Sr(1:RNK))) * Ur(:,1:RNK)'; % square root
    P_sqrtm = Vr(:,1:RNK) * diag(sqrt(Sr(1:RNK))) * Ur(:,1:RNK)';
    B = H * P_sqrtm;
    G = B' / (B * B' + R);
    w_t = 1 ./ sum(G.' .* B, 1)';
    D = w_t .* SIR;
    end
    % kf_update is the update step of kalman filter
    v = y-H*m;

    S = H*P*H'+R;
    K = (P*H')/S;     % /S is  same as *inv(S) but faster and more accurate

    m = m+K*v;
    P = P-K*S*K';


end

