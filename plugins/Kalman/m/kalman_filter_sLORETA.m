function [P_store,z_inverse] = kalman_filter_sLORETA(m,P,A,Q,L,R, timeSteps ,number_of_frames, smoothing, q_given)
P_store = cell(0);
z_inverse = cell(0);
h = zef_waitbar(0, 'Filtering');
if not(q_given)
    q_values = Q;
end

for f_ind = 1: number_of_frames
    zef_waitbar(f_ind/number_of_frames,h,...
        ['Filtering ' int2str(f_ind) ' of ' int2str(number_of_frames) '.']);
    f = timeSteps{f_ind};
    if not(q_given)
        Q = diag(q_values(:,f_ind));
    end
    % Prediction
    [m,P] = kf_predict(m, P, A, Q);
    % Update
    [m, P, ~, D] = kf_sL_update(m, P, f, L, R);
    z_inverse{f_ind} = gather(D*m);
    if (smoothing == 2)
        P_store{f_ind} = gather(P);
    end
end
close(h);
end