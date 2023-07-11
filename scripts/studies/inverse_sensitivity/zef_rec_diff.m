function [dist_vec,angle_vec,mag_vec] = zef_rec_diff(zef, inverse_method, noise_db, diff_type)

    arguments

        zef (1,1) struct

        inverse_method (1,1) function_handle

        noise_db (1,1) double { mustBeNonpositive } = 0

        diff_type (1,1) string { mustBeMember(diff_type, ["L2", "minabs"]) } = "L2"

    end

    dist_vec = zeros(3*size(zef.source_positions,1),1);
    angle_vec = zeros(3*size(zef.source_positions,1),1);

    h_waitbar = zef_waitbar(0,1,'Creating synthetic measurements');

    cleanup_fn = @(wb) close(wb);

    cleanup_ob = onCleanup(@() cleanup_fn(h_waitbar));

    n_sources = size(zef.source_positions,1);

    zef.measurements = zeros(size(zef.L,1),3*n_sources);

    zef.inv_synth_source = [ 0 0 0 0 0 0 10 0 3 5];

    dir_mat = eye(3);

    for i = 1 : n_sources

        if mod(i,floor(n_sources/10))==0

            h_waitbar = zef_waitbar(i,n_sources,h_waitbar,'Creating synthetic measurements');

        end

        for j = 1 : 3

            zef.inv_synth_source(1:6) = [zef.source_positions(i,:) dir_mat(j,:) ];

            zef.measurements(:,3*(i-1)+j) = zef_find_source_legacy(zef);

            if not(noise_db == 0)

                zef.measurements(:,3*(i-1)+j) = 10^(noise_db/20)*randn(size(zef.measurements,1),1) + zef.measurements(:,3*(i-1)+j);

            end

        end % for

    end % for

    zef.inv_data_mode = 'raw';

    % The reconstruction components as a 3 × n_sources cell array.

    z = inverse_method(zef);

    % Go over the xyz-components of sources and reconstructions and compare
    % them.

    for i = 1 : n_sources

        for j = 1 : 3

            rec_component_ind = 3 * (i-1) + j;

            z_ij = z{rec_component_ind};

            reshaped_z_ij = reshape(z_ij, 3, size(zef.source_positions,1));

            z_norm = sqrt(sum(reshaped_z_ij.^2));

            [mag_val, I] = max(z_norm);

            dir_vec_rec = z_ij(3*(I-1)+1:3*(I-1)+3);
            dir_vec_rec = dir_vec_rec/norm(dir_vec_rec,2);

            dir_vec_source = dir_mat(:,j);
            dir_vec_source = dir_vec_source/norm(dir_vec_source,2);

            pos_diffs = zef.source_positions(i,:) - zef.source_positions(I,:);

            if diff_type == "L2"

                dist_vec(3*(i-1) + j) = (1/sqrt(3)) * sqrt(sum(pos_diffs.^2,2));

            elseif diff_type == "minabs"

                dist_vec(3*(i-1) + j) = (1/sqrt(3)) * min(abs(pos_diffs), [], 2);

            else

                error("Unknown comparison type in zef_rec_diff. Aborting...")

            end

            angle_vec(3*(i-1) + j) = acosd(dot(dir_vec_rec,dir_vec_source));

            mag_vec(3*(i-1) + j) = (1/sqrt(3))*mag_val;

        end % for

    end % for

end % function
