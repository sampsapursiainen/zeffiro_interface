function [z_inverse] = EnKF(m, A, P, Q, L, R, timeSteps, number_of_frames)
%ENKF Summary of this function goes here
n_ensembles = 10000;
%x_ensemble = mvnrnd(zeros(size(m)), 100* ones(size(m,1)), n_ensembles)';
x_ensemble = mvnrnd(zeros(size(m)), P, n_ensembles)';
z_inverse = cell(0);
for f_ind = 1:number_of_frames
    f = timeSteps{f_ind};
    w = mvnrnd(zeros(size(m)), Q, n_ensembles)';
    % Forecasts
    x_f = A * x_ensemble + w;
    C = cov(x_f');
    
    % Update
    K = C * L' / (L * C * L' + R);
    
    v = mvnrnd(zeros(size(R,1),1), R, n_ensembles);
    x_ensemble = x_f + K *(f + v' - L*x_f);
    % x_ensemble = x_ensemble';
    z_inverse{f_ind} = mean(x_ensemble,2);
end

end

