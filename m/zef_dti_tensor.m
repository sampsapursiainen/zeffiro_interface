function dti_tensor = zef_dti_tensor(data_dir, bvec_file, bval_file, conductivity_scale)

if nargin < 4
    conductivity_scale = 1;
end

bvec_file  = fullfile(data_dir, bvec_file);
bval_file  = fullfile(data_dir, bval_file);

bvals = dlmread(bval_file);
bvals = bvals(:);

bvecs = dlmread(bvec_file);

if size(bvecs,1)==3
    G = bvecs.';
else
    G = bvecs;
end

N = numel(bvals);

nii_files = dir(fullfile(data_dir, '*.nii.gz'));
nii_files = sort_nat({nii_files.name});

use_idx = 1:N;

V1_nii = niftiread(fullfile(data_dir, nii_files{use_idx(1)}));
V1_nii = single(V1_nii);
[nx, ny, nz] = size(V1_nii);

data = zeros(nx, ny, nz, N, 'single');
data(:,:,:,1) = V1_nii;

for i = 2:N
    V = niftiread(fullfile(data_dir, nii_files{use_idx(i)}));
    data(:,:,:,i) = single(V);
end

A = zeros(N, 7);
for i = 1:N
    gx = G(i,1); gy = G(i,2); gz = G(i,3);
    bi = bvals(i);
    
    A(i,:) = [ ...
        -bi * gx^2, ...
        -bi * gy^2, ...
        -bi * gz^2, ...
        -2 * bi * gx * gy, ...
        -2 * bi * gx * gz, ...
        -2 * bi * gy * gz, ...
         1 ];
end

M = pinv(A);

S = reshape(data, [], N)';
mask = all(S > 0, 1);

Y = zeros(N, size(S,2), 'single');
Y(:,mask) = log(S(:,mask));

X = M * Y;

Dxx  = reshape(X(1,:), nx,ny,nz);
Dyy  = reshape(X(2,:), nx,ny,nz);
Dzz  = reshape(X(3,:), nx,ny,nz);
Dxy  = reshape(X(4,:), nx,ny,nz);
Dxz  = reshape(X(5,:), nx,ny,nz);
Dyz  = reshape(X(6,:), nx,ny,nz);
lnS0 = reshape(X(7,:), nx,ny,nz); %#ok<NASGU>

dti_tensor = cat(4, Dxx, Dyy, Dzz, Dxy, Dxz, Dyz);

for ix = 1:nx
    for iy = 1:ny
        for iz = 1:nz
            D = [dti_tensor(ix, iy, iz, 1), dti_tensor(ix, iy, iz, 4), dti_tensor(ix, iy, iz, 5); ...
                 dti_tensor(ix, iy, iz, 4), dti_tensor(ix, iy, iz, 2), dti_tensor(ix, iy, iz, 6); ...
                 dti_tensor(ix, iy, iz, 5), dti_tensor(ix, iy, iz, 6), dti_tensor(ix, iy, iz, 3)];
            
            if ~any(D(:))
                continue;
            end
            
            D = (D + D.')/2;
            [V, L] = eig(D);
            lam = diag(L);
            lam = max(lam, 0);
            
            if all(lam == 0)
                D_new = zeros(3,3);
            else
                lam_max = max(lam);
                scale = conductivity_scale / lam_max;
                lam = lam * scale;
                D_new = V * diag(lam) * V.';
            end
            
            dti_tensor(ix, iy, iz, 1) = D_new(1,1);
            dti_tensor(ix, iy, iz, 2) = D_new(2,2);
            dti_tensor(ix, iy, iz, 3) = D_new(3,3);
            dti_tensor(ix, iy, iz, 4) = D_new(1,2);
            dti_tensor(ix, iy, iz, 5) = D_new(1,3);
            dti_tensor(ix, iy, iz, 6) = D_new(2,3);
        end
    end
end

end

function s = sort_nat(c)
    [~, idx] = sort(lower(c));
    s = c(idx);
end
