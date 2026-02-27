function [dti_tensor, lnS0] = dti_tensor(data_dir, bvec_file, bval_file, scale_value)
%
%   [dti_tensor, lnS0] = zeffiro.dti.dti_tensor(data_dir, bvec_file, bval_file, scale_value)
%
% Computes a Diffusion Tensor Imaging (DTI) tensor from DWI MRI data.
%
% Inputs:
%   data_dir: Directory containing DWI data and bvec/bval files.
%   bvec_file: File containing gradient directions (b-vectors).
%   bval_file: File containing diffusion weighting factors (b-values).
%   scale_value: Optional scaling factor for the output tensor (default: 1).

    arguments
        data_dir (1,1) string { mustBeFolder }
        bvec_file (1,1) string { mustBeFile }
        bval_file (1,1) string { mustBeFile }
        scale_value (1,1) double {mustBePositive} = 1
    end

    % Load b-values (diffusion weighting factors)

    bvals = dlmread(bval_file);

    bvals = bvals(:); % Ensure bvals is a column vector

    % Load b-vectors (gradient directions)

    bvecs = dlmread(bvec_file);

    % Reshape bvecs if necessary (rows should correspond to gradient directions)

    if size(bvecs,1) == 3
        G = transpose(bvecs) ; % Transpose if bvecs is 3xN (rows are x,y,z components)
    else
        G = bvecs ; % Use as-is if bvecs is Nx3 (rows are gradient directions)
    end

    N = numel(bvals) ; % Number of DWI volumes

    % List and sort all NIfTI files (DWI volumes) in the directory

    nii_files = dir(fullfile(data_dir, '*.nii.gz'));

    nii_files = sort_nat({nii_files.name});

    use_idx = 1:N; % Indices of DWI volumes to use

    % Load the first DWI volume to get dimensions

    V1_nii = niftiread(fullfile(data_dir, nii_files{use_idx(1)}));

    V1_nii = single(V1_nii); % Convert to single precision

    [nx, ny, nz] = size(V1_nii); % Get volume dimensions

    % Initialize 4D data array (x,y,z,DWI volume)

    data = zeros(nx, ny, nz, N, 'single');

    data(:,:,:,1) = V1_nii;

    % Load remaining DWI volumes

    for i = 2:N
        V = niftiread(fullfile(data_dir, nii_files{use_idx(i)}));
        data(:,:,:,i) = single(V);
    end

    % The design matrix (A) encodes the relationship between the diffusion-weighted signal
    % and the diffusion tensor elements.
    %
    % For more info, see: "Diffusion Tensor Imaging: Theory, Data Acquisition, and Analysis" (Basser et al.)

    A = zeros(N, 7);

    for i = 1:N
        gx = G(i,1); gy = G(i,2); gz = G(i,3); % Gradient direction components
        bi = bvals(i); % b-value for this volume

        % Each row of A corresponds to the equation:
        % log(S) = log(S0) - b * (gx^2*Dxx + gy^2*Dyy + gz^2*Dzz + 2*gx*gy*Dxy + 2*gx*gz*Dxz + 2*gy*gz*Dyz)

        A(i,:) = [ ...
            -bi * gx^2, ...
            -bi * gy^2, ...
            -bi * gz^2, ...
            -2 * bi * gx * gy, ...
            -2 * bi * gx * gz, ...
            -2 * bi * gy * gz, ...
             1 ];

    end % for

    % Compute the pseudo-inverse of A to solve for the diffusion tensor components

    M = pinv(A) ;

    % Reshape data for linear regression

    S = transpose(reshape(data, [], N));

    % Mask: only consider voxels where all DWI signals are positive

    mask = all(S > 0, 1);

    % Log-transform the signal (linearizes the relationship with the diffusion tensor)

    Y = zeros(N, size(S,2), 'single');

    Y(:,mask) = log(S(:,mask));

    % Solve for diffusion tensor components and ln(S0)

    X = M * Y;

    % Reshape components into 3D volumes

    Dxx  = reshape(X(1,:), nx,ny,nz); % xx component of the diffusion tensor
    Dyy  = reshape(X(2,:), nx,ny,nz); % yy component
    Dzz  = reshape(X(3,:), nx,ny,nz); % zz component
    Dxy  = reshape(X(4,:), nx,ny,nz); % xy component
    Dxz  = reshape(X(5,:), nx,ny,nz); % xz component
    Dyz  = reshape(X(6,:), nx,ny,nz); % yz component

    lnS0 = reshape(X(7,:), nx,ny,nz); % Baseline signal (log(S0))

    % Concatenate tensor components into a 4D array

    dti_tensor = cat(4, Dxx, Dyy, Dzz, Dxy, Dxz, Dyz);

    % Apply scaling (e.g., for visualization or further analysis)

    dti_tensor = zeffiro.dti.dti_tensor_condition(dti_tensor, scale_value);

end % function

% --- Helper Function: Natural Sort ---

function s = sort_nat(c)
    % Sorts filenames in natural order (e.g., "img1", "img2", ..., "img10")
    [~, idx] = sort(lower(c));
    s = c(idx);
end
