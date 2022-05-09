function [z_inverse] = EnKF(m, A, P, Q, L, R, timeSteps, number_of_frames, n_ensembles)
%ENKF Summary of this function goes here
%x_ensemble = mvnrnd(zeros(size(m)), 100* ones(size(m,1)), n_ensembles)';
x_ensemble = mvnrnd(zeros(size(m)), P, n_ensembles)';
z_inverse = cell(0);
h = waitbar(0, 'EnKF Filtering');
for f_ind = 1:number_of_frames
    waitbar(f_ind/number_of_frames,h,...
        ['EnKF Filtering ' int2str(f_ind) ' of ' int2str(number_of_frames) '.']);
    f = timeSteps{f_ind};
    w = mvnrnd(zeros(size(m)), Q, n_ensembles)';
    % Forecasts

    x_f = A * x_ensemble + w;
    C = cov(x_f');
    correlationLocalization = true;
    if correlationLocalization
    T = corrcoef(x_f');
    % explain How to find 0.05
    T(abs(T) < 0.05) = 0;
    C = C .* T;
    end
    v = mvnrnd(zeros(size(R,1),1), R, n_ensembles);
    
    % method to calculate resolution D
    method = '1';
    if(method == '1')
        P_sqrtm = sqrtm(C);
        B = L * P_sqrtm;
        G = B' / (B * B' + R);
        w_t = 1 ./ sum(G.' .* B, 1)';
        D = w_t .* inv(P_sqrtm);
    elseif(method == '2')
        % complexity O(n^3)
        [Ur,Sr,Vr] = svd(C);
        Sr = diag(Sr);
        RNK = sum(Sr > (length(Sr) * eps(single(Sr(1)))));
        SIR = Vr(:,1:RNK) * diag(1./sqrt(Sr(1:RNK))) * Ur(:,1:RNK)'; % square root
        P_sqrtm = Vr(:,1:RNK) * diag(sqrt(Sr(1:RNK))) * Ur(:,1:RNK)';
        B = L * P_sqrtm;
        G = B' / (B * B' + R);
        w_t = 1 ./ sum(G.' .* B, 1)';
        D = w_t .* SIR;
    else
        D = speye(size(C));
    end
    % Update
    K = C * L' / (L * C * L' + R);
    x_ensemble = x_f + K *(f + v' - L*x_f);
    % x_ensemble = x_ensemble';
    mean_x = mean(x_ensemble,2);
    z_inverse{f_ind} = D*mean_x;
end
close(h);
end
