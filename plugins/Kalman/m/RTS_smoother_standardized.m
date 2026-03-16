function [P_s_store, m_s_store, G_store] = RTS_smoother_standardized(P_store, D_store, z_inverse, A, Q, number_of_frames)
P_s_store = cell(0);
m_s_store = cell(0);
G_store = cell(0);
h = zef_waitbar(0,'Smoothing');
for f_ind = number_of_frames:-1:1
    zef_waitbar(1 - f_ind/number_of_frames,h, ['Smoothing (standardized)' int2str(number_of_frames -f_ind) ' of ' int2str(number_of_frames) '.']);

    P = P_store{f_ind};
    m = z_inverse{f_ind};
    % if A is Identity
    if (isdiag(A) && all(diag(A) - 1) < eps)
        P_ = P + Q;
        m_ = m;
        if f_ind == number_of_frames
            m_s = m;
            P_s = D_store{f_ind}*P*D_store{f_ind}';
        else
            G =  (D_store{f_ind}*(P / P_))/D_store{f_ind+1};
            m_s = m + G * (m_s - m_);
            P_s = D_store{f_ind}*P*D_store{f_ind}' + G * (P_s - P_) * G';
        end
    else
        P_ = A * P * A' + Q;
        if f_ind == number_of_frames
            m_s = D_store{f_ind} * A * (D_store{f_ind}\m);
            P_s = D_store{f_ind}*P*D_store{f_ind}';
        else
            m_ = (D_store{f_ind+1}* A) * (D_store{f_ind}\m);
            G =  (D_store{f_ind}*(P*(P * A') / P_))/D_store{f_ind+1};
            m_s = m + G * (m_s - m_);
            P_s = D_store{f_ind}*P*D_store{f_ind}' + G * (P_s - P_) * G';
        end
    end
    
    %P_s_store{f_ind} = P_s;
    %G_store{f_ind} = G;
    m_s_store{f_ind} = m_s;
end

close(h);
end
