
function dti_tensor = zef_dti_tensor_condition(dti_tensor,scale_value)

nx = size(dti_tensor,1);
ny = size(dti_tensor,2);
nz = size(dti_tensor,3);

if nargin < 2
    scale_value = 1;
end

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
                scale = scale_value / lam_max;
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