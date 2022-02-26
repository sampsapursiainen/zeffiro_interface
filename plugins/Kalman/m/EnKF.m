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

    % Update
    K = C * L' / (L * C * L' + R);

    v = mvnrnd(zeros(size(R,1),1), R, n_ensembles);
    x_ensemble = x_f + K *(f + v' - L*x_f);
    % x_ensemble = x_ensemble';
    z_inverse{f_ind} = mean(x_ensemble,2);
end
close(h);
end

