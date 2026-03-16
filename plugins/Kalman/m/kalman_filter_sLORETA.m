function [P_store,D_store,z_inverse] = kalman_filter_sLORETA(m,P,A,Q,L,R, timeSteps ,number_of_frames, smoothing,standardization_exponent)
P_store = cell(0);
D_store = cell(0);
z_inverse = cell(1,number_of_frames);
h = zef_waitbar(0,1, 'Filtering');
for f_ind = 1: number_of_frames
    zef_waitbar(f_ind,number_of_frames,h,...
        ['Filtering ' int2str(f_ind) ' of ' int2str(number_of_frames) '.']);
    f = timeSteps{f_ind};
    % Prediction
    [m,P] = kf_predict(m, P, A, Q);
    % Update
    [m, P, ~, D] = kf_sL_update(m, P, f, L, R, standardization_exponent);
    z_inverse{f_ind} = gather(D*m);
    if (smoothing ~= 1)
        P_store{f_ind} = gather(P);
        D_store{f_ind} = gather(D);
    end
end
close(h);
end
