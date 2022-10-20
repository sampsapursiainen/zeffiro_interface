function sensitivity_map = zef_sensitivity_map_mne(project_struct, weighting_type, n_reconstructions, noise_level, diff_type)

    arguments

        project_struct (1,1) struct

        weighting_type  (1,:) char { mustBeMember(weighting_type, ['sLORETA', 'dSPM', 'MNE']) } = 'sLORETA'

        n_reconstructions (1,1) double { mustBeInteger, mustBePositive } = 10

        noise_level (1,1) double { mustBeNonpositive } = -30

        diff_type (1,1) string { mustBeMember(diff_type, ["L2", "minabs"]) } = "L2"

    end

    weighting_type_cell = {'MNE','dSPM','sLORETA'};

    weighting_type_as_num = find(ismember(weighting_type_cell, weighting_type));

    % Set up the beginnings of a return value.

    sensitivity_map = struct;

    sensitivity_map.weighting_type = weighting_type;

    project_struct = zef_minimum_norm_estimation(project_struct);

    project_struct.mne_number_of_frames = 3*size(project_struct.source_positions,1);

    project_struct.mne_type = weighting_type_as_num;

    project_struct.mne_prior = 2;

    % Call inverse method for a given number of times for averaging.

    for i = 1 : n_reconstructions

        [sensitivity_map.dist_vec{i},sensitivity_map.angle_vec{i}, sensitivity_map.mag_vec{i}] = zef_rec_diff( ...
            project_struct, ...
            @zef_find_mne_reconstruction, ...
            noise_level, ...
            diff_type ...
        );

    end

end % function
