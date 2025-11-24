function tensor_array = zef_dti_tensor_interpolate(reference_points, dti_tensor, scale_value, roi_radius, mode)
    [nx, ny, nz, ~] = size(dti_tensor);
    N = size(reference_points, 1);
    tensor_array = zeros(N, 6);

    for i = 1:N
        c = reference_points(i, :);

        ix = round(c(1));
        iy = round(c(2));
        iz = round(c(3));

        ix = min(max(ix,1), nx);
        iy = min(max(iy,1), ny);
        iz = min(max(iz,1), nz);

        if strcmp(mode, 'nearest')
            tensor_array(i, :) = squeeze(dti_tensor(ix, iy, iz, :)).';
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
                tensor_array(i, :) = acc / count;
            else
                tensor_array(i, :) = squeeze(dti_tensor(ix, iy, iz, :)).';
            end
        else
            error('Unknown mode: %s (use "nearest" or "radius_average")', mode);
        end
    end

    I = find(sum(abs(tensor_array),2)==0);
    tensor_array(I,1) = scale_value; 
    tensor_array(I,2) = scale_value; 
    tensor_array(I,3) = scale_value; 

end
