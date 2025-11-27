function dti_tensor = dti_tensor_condition(dti_tensor, scale_value)
%
%   dti_tensor = zeffiro.dti_tensor_condition(dti_tensor, scale_value)
%
% Scale and condition a given DTI tensor.
%
% Inputs:
%   dti_tensor: 4D array of size (nx, ny, nz, 6) containing the diffusion tensor components.
%               The 4th dimension contains [Dxx, Dyy, Dzz, Dxy, Dxz, Dyz].
%   scale_value: Optional scaling factor for the tensor (default: 1).
%
% Output:
%   dti_tensor: Scaled and conditioned 4D diffusion tensor.
%

    arguments
        dti_tensor (:, :, :, 6) double
        scale_value (1,1) double {mustBePositive} = 1
    end

    % Get the dimensions of the tensor

    nx = size(dti_tensor, 1);
    ny = size(dti_tensor, 2);
    nz = size(dti_tensor, 3);

    % Loop over each voxel in the tensor

    for ix = 1:nx

        for iy = 1:ny

            for iz = 1:nz

                % Construct the 3x3 diffusion tensor matrix for the current voxel

                D = [dti_tensor(ix, iy, iz, 1), dti_tensor(ix, iy, iz, 4), dti_tensor(ix, iy, iz, 5); ...
                     dti_tensor(ix, iy, iz, 4), dti_tensor(ix, iy, iz, 2), dti_tensor(ix, iy, iz, 6); ...
                     dti_tensor(ix, iy, iz, 5), dti_tensor(ix, iy, iz, 6), dti_tensor(ix, iy, iz, 3)];

                % Skip if the tensor is empty

                if ~ any(D(:))
                    continue;
                end

                % Compute eigenvalues and eigenvectors

                [V, L] = eig(D);

                lam = diag(L);

                % Ensure eigenvalues are non-negative (conditioning)

                lam = max(lam, 0);

                % Handle the case where all eigenvalues are zero

                if all(lam == 0)
                    D_new = zeros(3,3);
                else
                    % Scale the eigenvalues by the maximum eigenvalue
                    lam_max = max(lam);
                    scale = scale_value / lam_max;
                    lam = lam * scale;

                    % Reconstruct the scaled tensor
                    D_new = V * diag(lam) * V.';
                end

                % Update the tensor components

                dti_tensor(ix, iy, iz, 1) = D_new(1,1);
                dti_tensor(ix, iy, iz, 2) = D_new(2,2);
                dti_tensor(ix, iy, iz, 3) = D_new(3,3);
                dti_tensor(ix, iy, iz, 4) = D_new(1,2);
                dti_tensor(ix, iy, iz, 5) = D_new(1,3);
                dti_tensor(ix, iy, iz, 6) = D_new(2,3);

            end % for

        end % for

    end % for

end % function
