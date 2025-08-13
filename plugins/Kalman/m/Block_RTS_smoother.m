function [P_s_store, m_s_store, G_store] = Block_RTS_smoother(P_store, z_inverse, A, Q, number_of_frames, dim,sL)
P_s_store = cell(0);
m_s_store = cell(0);
G_store = cell(0);
h = zef_waitbar(0,1,'Smoothing');

if sL>=dim
    I1=eye(size(A,1),size(A,1)*dim);
else
    I1=eye(size(A,1)*sL,size(A,1)*dim);
end
zero_m=zeros(size(A,1));

if dim==2
    Q=cell2mat({zero_m,zero_m;zero_m,number_of_frames*Q});
    A=cell2mat({A,(1/number_of_frames)*A;zero_m,A});
elseif dim==3
    Q=cell2mat({zero_m,zero_m,zero_m;zero_m,zero_m,zero_m;zero_m,zero_m,(1/((1/2)*((1/number_of_frames)^2)))*Q});
    A=cell2mat({A,(1/number_of_frames)*A,(1/2)*((1/number_of_frames)^2)*A;zero_m,A,(1/number_of_frames)*A;zero_m,zero_m,A});
end

for f_ind = number_of_frames:-1:1
    zef_waitbar(1 - f_ind,number_of_frames,h, ['Smoothing ' int2str(number_of_frames -f_ind) ' of ' int2str(number_of_frames) '.']);

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
    m_s_store{f_ind} = I1*m_s;
end

close(h);
end
