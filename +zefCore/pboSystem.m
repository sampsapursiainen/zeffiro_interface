function out_coeff_sys = pboSystem( ...
    arg_locs, ...
    arg_dirs, ...
    arg_interp_loc, ...
    arg_n_of_coeffs ...
)
%
% out_coeff_sys = pboSystem( ...
%    arg_locs, ...
%    arg_dirs, ...
%    arg_interp_locs, ...
%    arg_n_of_coeffs ...
% )
%
% A function for generating a matrix of interpolation coefficients via
% position-based optimization or PBO.
%
% Input:
%
% - arg_locs
%
%   An N × 3 dipole location matrix needed in interpolation.
%
% - arg_dirs
%
%   An N × 3 dipole direction matrix needed in interpolation.
%
% - arg_interp_locs
%
%   The M × 3 interpolation positions needed in interpolation.
%
% - arg_n_of_coeffs
%
%   The number if interpolation / optimization coefficients or the size of the
%   output system one wishes to obtain.
%
% Output:
%
% - out_coeff_sys
%
%   The interpolation system matrix, from which interpolation / optimization
%   coefficients can be extracted.


arguments
    arg_locs (:,3) double
    arg_dirs (:,3) double
    arg_interp_loc (1,3) double
    arg_n_of_coeffs (1,1) double { mustBePositive, mustBeInteger }
end

% PBO weigth coefficients from differences between barycentra
% (interpolation positions) and dipole positions.

pos_diffs = arg_locs - arg_interp_loc;

weight_coefs = sqrt ( sum ( pos_diffs .^ 2, 2 ) ) ;

% Position-based optimization matrix.

PBO_mat = [ diag(weight_coefs) arg_dirs; arg_dirs' zeros(3,3) ];

% Solve for Lagrangian multipliers to generate coefficient matrix.

out_coeff_sys = PBO_mat \ [zeros(arg_n_of_coeffs,3); eye(3)];

end % function
