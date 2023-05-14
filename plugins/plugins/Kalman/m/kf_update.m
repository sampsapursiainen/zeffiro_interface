function [m, P, K] = kf_update(m,P,y,H,R)
% kf_update is the update step of kalman filter
v = y-H*m;
% downsample? H, P, R before S
S = H*P*H'+R;
K = (P*H')/S;     % /S is  same as *inv(S) but faster and more accurate
% upsample? K, P
m = m+K*v;
P = P-K*S*K';
% upsample P
end
