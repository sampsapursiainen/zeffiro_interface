function [dti_directions, dti_anisotropy] = dti_directions(dti_tensor)
%
%   [dti_directions, dti_anisotropy] = dti_directions(dti_tensor)
%
% Compute principal diffusion directions and anisotropy from a DTI tensor.
%
% Inputs:
%   dti_tensor: 4D array of size (nx, ny, nz, 6) containing the diffusion tensor components.
%               The 4th dimension contains [Dxx, Dyy, Dzz, Dxy, Dxz, Dyz].
% Outputs:
%   dti_directions: 4D array of size (nx, ny, nz, 3) containing the principal diffusion directions.
%   dti_anisotropy: 3D array of size (nx, ny, nz) containing the fractional anisotropy values.

    arguments
        dti_tensor (:, :, :, 6) {mustBeNumeric, mustBeReal, mustBeFinite}
    end

    % Get the dimensions of the tensor

    nx = size(dti_tensor, 1);
    ny = size(dti_tensor, 2);
    nz = size(dti_tensor, 3);

    % Initialize output arrays

    dti_anisotropy = zeros(nx, ny, nz, 'single');

    dti_directions = zeros(nx, ny, nz, 3, 'single');

    % Loop over each voxel in the tensor

    for ix = 1:nx

        for iy = 1:ny

            for iz = 1:nz

                % Construct the 3x3 diffusion tensor matrix for the current voxel

                D = [ ...
                    dti_tensor(ix, iy, iz, 1), dti_tensor(ix, iy, iz, 4), dti_tensor(ix, iy, iz, 5); ...
                    dti_tensor(ix, iy, iz, 4), dti_tensor(ix, iy, iz, 2), dti_tensor(ix, iy, iz, 6); ...
                    dti_tensor(ix, iy, iz, 5), dti_tensor(ix, iy, iz, 6), dti_tensor(ix, iy, iz, 3) ];

                % Skip if the tensor is empty
                if all(D(:) == 0)
                    continue;
                end

                % Compute eigenvalues and eigenvectors

                [V, E] = eig(D);

                evals = diag(E);

                % Find the eigenvector corresponding to the largest eigenvalue (principal direction)

                [~, idx_max] = max(evals);

                v1 = V(:, idx_max);

                % Normalize the principal direction vector

                nrm = norm(v1);

                if nrm > 0
                    v1 = v1 / nrm;
                else
                    v1 = [0; 0; 0];
                end

                % Store the principal direction
                dti_directions(ix, iy, iz, :) = v1;

                % Compute fractional anisotropy
                l1 = evals(1);
                l2 = evals(2);
                l3 = evals(3);

                lmean = (l1 + l2 + l3) / 3;

                num = (l1 - lmean)^2 + (l2 - lmean)^2 + (l3 - lmean)^2;

                den = l1^2 + l2^2 + l3^2;

                if den > 0
                    dti_anisotropy(ix, iy, iz) = sqrt(1.5 * num / den);
                else
                    dti_anisotropy(ix, iy, iz) = 0;
                end

            end % for

        end % for

    end % for

end % function
