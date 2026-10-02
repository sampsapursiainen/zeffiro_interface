function [m, P, K, D] = kf_sL_update(m, P, y, H, R, standardization_exponent)
%KF_SL_UPDATE  Kalman update plus sLORETA standardization matrix D.
%
%   Zeffiro Interface.
%   Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%   See: https://github.com/sampsapursiainen/zeffiro_interface
%   Licensed under the GNU General Public License v3.0 (see LICENSE).
%
%   [m, P, K, D] = kf_sL_update(m, P, y, H, R)
%   [m, P, K, D] = kf_sL_update(m, P, y, H, R, standardization_exponent)
%
%   Builds D = w .* inv(sqrtm(P)) with w_i = 1/(diag(G' B))^e from
%   B = H sqrtm(P) and G = B' / (B B' + R), then the same K/m/P update as
%   kf_update. KalmanInverter.invert returns z = D*x.
%
%   standardization_exponent (e) defaults to 1/2, textbook sLORETA and the
%   value this function previously hard-coded. The legacy plugin
%   plugins/Kalman/m/kf_sL_update.m takes the same argument but is driven from
%   zef.standardization_exponent, which defaults to 1; the two paths therefore
%   disagree unless the caller sets this explicitly. It is a parameter here so
%   that a legacy run can be reproduced through the class API.
%
%   See also inverse.kf.kf_sL_update_approx, inverse.kf.kf_update.

if nargin < 6
    standardization_exponent = 0.5;
end

% sqrtm is host-only (schur rejects gpuArray). On a device, the symmetric
% eigendecomposition is the principal square root of this covariance.
if isa(P, "gpuArray")
    [P_sqrtm, P_invsqrt] = inverse.kf.spd_sqrt_pair(P);
else
    P_sqrtm = sqrtm(P);
    P_invsqrt = inv(P_sqrtm);
end
B = H * P_sqrtm;
G = B' / (B * B' + R);
w_t = 1 ./ (sum(G.' .* B, 1)').^standardization_exponent;
D = w_t .* P_invsqrt;

% Standard Kalman update
v = y - H*m;
PHt = P * H';
S = H * PHt + R;
S = (S + S')/2; % Ensure S is symmetric positive definite for numerical stability
K = PHt / S;
m = m + K*v;
P = P - K * PHt';
P = (P + P')/2; % Ensure P is symmetric positive definite for numerical stability

end
