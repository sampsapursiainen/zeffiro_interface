function hauk_map = zef_sensitivity_map_dipoleScan(project_struct, n_reconstructions, noise_level, diff_type)

    arguments

        project_struct (1,1) struct

        n_reconstructions (1,1) double { mustBeInteger, mustBePositive } = 10

        noise_level (1,1) double { mustBeNonpositive } = -30

        diff_type (1,1) string { mustBeMember(diff_type, ["L2", "minabs"]) } = "L2"

    end


    hauk_map = struct;

    project_struct = zef_dipole_start(project_struct);

    project_struct.number_of_frames = 3*size(project_struct.source_positions,1);

    for i = 1 : n_reconstructions

        [hauk_map.dist_vec{i},hauk_map.angle_vec{i}, hauk_map.mag_vec{i}] = zef_rec_diff( ...
            project_struct, ...
            @zef_dipoleScan, ...
            noise_level, ...
            diff_type ...
        );

    end

end % function
