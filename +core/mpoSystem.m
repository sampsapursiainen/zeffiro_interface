function out_coeff_sys = mpoSystem ( ...
    arg_locs, ...
    arg_dirs, ...
    arg_interp_loc, ...
    arg_n_of_coeffs ...
    )
%
% out_coeff_sys = mpoSystem ( ...
%    arg_locs, ...
%    arg_dirs, ...
%    arg_interp_locs, ...
%    arg_n_of_coeffs ...
% )
%
% A function for generating a matrix of interpolation coefficients via mean
% position and orientation- or MPO-optimization.
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

% Distances between interpolation and dipole positions.

pos_diffs = arg_locs - arg_interp_loc;

dists = sqrt ( sum ( pos_diffs .^ 2, 2 ) ) ;

% Reference distance for scaling purposes: twice the length of longest
% edge, although here distances do not represent edges…

scaling_factor = 1 / max(dists) / 2;

% Moments whose components will be inserted into the P-matrices.

moments = scaling_factor * pos_diffs;

moment_x = moments(:,1);
moment_y = moments(:,2);
moment_z = moments(:,3);

% Generate position difference matrices.

Px = diag(moment_x);
Py = diag(moment_y);
Pz = diag(moment_z);

% Generate the MPO matrix M with with the position difference matrices and
% direction matrices.

M = [
    arg_dirs' ;
    arg_dirs' * Px ;
    arg_dirs' * Py ;
    arg_dirs' * Pz ;
    ];

% The vector b, against which M will be inverted, with a Cartesian basis
% assumption.

zero_block = zeros(9,3);

basis = eye(3);

b = [ basis ; zero_block ];

% Calculate interpolation coefficients (lsqminnorm is advertised as being
% more efficient than pinv).

out_coeff_sys = lsqminnorm(M, b);

end
