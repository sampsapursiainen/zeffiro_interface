function [P, L, Q] = zef_kf_sLORETA_OLD(L, Q, std_lhood, theta0)
    % Sparse 
    D2 = inv(sparse(diag(diag(L' / (L * L' +  std_lhood^2 / theta0 * eye(size(L,1))) * L))));
    P = theta0 * D2;
    L = L / chol(D2);
    Q = D2*Q;
end

