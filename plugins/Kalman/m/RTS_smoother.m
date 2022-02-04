function [P_s_store, m_s_store, G_store] = RTS_smoother(P_store, z_inverse, A, Q, number_of_frames)
P_s_store = cell(0);
m_s_store = cell(0);
G_store = cell(0);
h = waitbar(0,'Smoothing');
for f_ind = number_of_frames:-1:1
    waitbar(1 - f_ind/number_of_frames,h, ['Smoothing ' int2str(number_of_frames -f_ind) ' of ' int2str(number_of_frames) '.']);

    P = P_store{f_ind};
    m = z_inverse{f_ind};
    % if A is Identity
    if (isdiag(A) && all(diag(A) - 1) < eps)
        P_ = P + Q;
        m_ = m;
        G =  P / P_;
    else
        P_ = A * P * A' + Q;
        m_ = A * m;
        G =  (P * A') / P_;
    end
    if f_ind == number_of_frames
        m_s = m;
        P_s = P;
    else
        m_s = m + G * (m_s - m_);
        P_s = P + G * (P_s - P_) * G';
    end
    P_s_store{f_ind} = P_s;
    G_store{f_ind} = G;
    m_s_store{f_ind} = m_s;
end

close(h);
end

