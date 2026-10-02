function [P_sqrtm, P_invsqrt] = spd_sqrt_pair(P)
%SPD_SQRT_PAIR  Principal square root and inverse square root on a gpuArray.
%
%   Zeffiro Interface.
%   Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%   See: https://github.com/sampsapursiainen/zeffiro_interface
%   Licensed under the GNU General Public License v3.0 (see LICENSE).
%
%   MATLAB sqrtm calls schur, which rejects gpuArray. For a symmetric
%   positive semidefinite covariance the principal square root is the
%   symmetric eigendecomposition V diag(sqrt(lambda)) V', the same matrix
%   sqrtm returns on the host. One decomposition also supplies the inverse
%   square root, so the standardized update does not factor the matrix twice.
%
%   [P_sqrtm, P_invsqrt] = inverse.kf.spd_sqrt_pair(P)
%
%   See also inverse.kf.kf_sL_update, sqrtm, eig.

P = (P + P') / 2;
[V, d] = eig(P, "vector");
d = real(d);
V = real(V);
s = sqrt(max(d, 0));
P_sqrtm = (V .* s.') * V';
P_invsqrt = (V .* (1 ./ max(s, realmin("double"))).') * V';
P_sqrtm = (P_sqrtm + P_sqrtm') / 2;
P_invsqrt = (P_invsqrt + P_invsqrt') / 2;
end
