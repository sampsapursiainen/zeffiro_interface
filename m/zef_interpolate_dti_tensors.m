function interpolated_tensors = zef_interpolate_dti_tensors(tetrahedron_centers, dti_tensor, roi_radius, mode)
    [nx, ny, nz, ~] = size(dti_tensor);
    N = size(tetrahedron_centers, 1);
    interpolated_tensors = zeros(N, 6);

    for i = 1:N
        c = tetrahedron_centers(i, :);

        ix = round(c(1));
        iy = round(c(2));
        iz = round(c(3));

        ix = min(max(ix,1), nx);
        iy = min(max(iy,1), ny);
        iz = min(max(iz,1), nz);

        if strcmp(mode, 'nearest')
            interpolated_tensors(i, :) = squeeze(dti_tensor(ix, iy, iz, :)).';
        elseif strcmp(mode, 'radius_average')
            ix_min = max(1, floor(c(1) - roi_radius));
            ix_max = min(nx, ceil(c(1) + roi_radius));
            iy_min = max(1, floor(c(2) - roi_radius));
            iy_max = min(ny, ceil(c(2) + roi_radius));
            iz_min = max(1, floor(c(3) - roi_radius));
            iz_max = min(nz, ceil(c(3) + roi_radius));

            acc = zeros(1,6);
            count = 0;

            for xi = ix_min:ix_max
                dx = xi - c(1);
                for yi = iy_min:iy_max
                    dy = yi - c(2);
                    for zi = iz_min:iz_max
                        dz = zi - c(3);
                        if dx*dx + dy*dy + dz*dz <= roi_radius^2
                            acc = acc + squeeze(dti_tensor(xi, yi, zi, :)).';
                            count = count + 1;
                        end
                    end
                end
            end

            if count > 0
                interpolated_tensors(i, :) = acc / count;
            else
                interpolated_tensors(i, :) = squeeze(dti_tensor(ix, iy, iz, :)).';
            end
        else
            error('Unknown mode: %s (use "nearest" or "radius_average")', mode);
        end
    end
end
