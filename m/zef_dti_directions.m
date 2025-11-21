function  [dti_directions, dti_anisotropy] = zef_dti_directions(dti_tensor)

nx = size(dti_tensor,1);
ny = size(dti_tensor,2);
nz = size(dti_tensor,3);

dti_anisotropy = zeros(nx,ny,nz, 'single');
dti_directions  = zeros(nx,ny,nz,3, 'single');

for ix = 1:nx
    for iy = 1:ny
        for iz = 1:nz
            D = [ ...
                dti_tensor(ix,iy,iz,1), dti_tensor(ix,iy,iz,4), dti_tensor(ix,iy,iz,5); ...
                dti_tensor(ix,iy,iz,4), dti_tensor(ix,iy,iz,2), dti_tensor(ix,iy,iz,6); ...
                dti_tensor(ix,iy,iz,5), dti_tensor(ix,iy,iz,6), dti_tensor(ix,iy,iz,3) ];
            
            if all(D(:) == 0)
                continue;
            end
            
            [V,E] = eig(D);
            evals = diag(E);
            [~, idx_max] = max(evals);
            v1 = V(:,idx_max);
            
            nrm = norm(v1);
            if nrm > 0
                v1 = v1 / nrm;
            else
                v1 = [0;0;0];
            end
            dti_directions(ix,iy,iz,:) = v1;
            
            l1 = evals(1); l2 = evals(2); l3 = evals(3);
            lmean = (l1 + l2 + l3) / 3;
            num   = (l1 - lmean)^2 + (l2 - lmean)^2 + (l3 - lmean)^2;
            den   = l1^2 + l2^2 + l3^2;
            if den > 0
                dti_anisotropy(ix,iy,iz) = sqrt(1.5 * num / den);
            else
                dti_anisotropy(ix,iy,iz) = 0;
            end
        end
    end
end

end