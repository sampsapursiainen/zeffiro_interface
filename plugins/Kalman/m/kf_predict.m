function [m, P] = kf_predict(m,P,A,Q)
% kf_predict is the prediction step of kalman filter
    % Skip multiplications if A is Indentity
    if (isdiag(A) && all(diag(A) - 1) < eps)
        P = P + Q;
    else
        % Basic kalman prediction steps
        m = A * m;
        P = A * P * A' + Q;
    end
end
