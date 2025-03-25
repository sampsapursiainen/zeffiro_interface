function [P_store,z_inverse] = kalman_filter(m,P,A,Q,L,R, timeSteps ,number_of_frames, smoothing, q_given)
P_store = cell(0);
z_inverse = cell(0);
if not(q_given)
    q_values = Q;
end
h = zef_waitbar(0, 'Filtering');
for f_ind = 1: number_of_frames
    zef_waitbar(f_ind/number_of_frames,h,...
        ['Filtering ' int2str(f_ind) ' of ' int2str(number_of_frames) '.']);
    f = timeSteps{f_ind};
    if not(q_given)
        Q = diag(q_values(:,f_ind));
    end
    % Prediction
    %[m,P] = zeffiro.plugins.Kalman.m.kf_predict(m, P, A, Q);
    [m,P] = kf_predict(m, P, A, Q);
    % Update
    %[m, P] = zeffiro.plugins.Kalman.m.kf_update(m, P, f, L, R);
    [m, P] = kf_update(m, P, f, L, R);
    if (smoothing == 2)
        P_store{f_ind} = gather(P);
    end
    z_inverse{f_ind} = gather(m);
end
close(h);
end