function [m, P] = kf_predict(m,P,A,Q)
% kf_predict is the prediction step of kalman filter
    m = A * m;
    P = A * P * A' + Q;
end