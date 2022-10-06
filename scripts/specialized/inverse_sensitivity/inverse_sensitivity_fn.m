function sensitivities_with_statistics = inverse_sensitivity_fn( ...
    project_path, ...
    inverse_method, ...
    mesh_resolution, ...
    n_of_sources, ...
    n_of_runs, ...
    noise_level_db, ...
    diff_type, ...
    args ...
)

    %
    % inverse_sensitivity_fn
    %
    % Computes normed distance, direction and magnitude differences between
    % given project dipoles and their reconstructions, determined by a given
    % inverse method name.
    %
    % Inputs:
    %
    % - project_path
    %
    %   The project for which a FE mesh, alead field and source locations are
    %   to be constructed.
    %
    % - inverse_method
    %
    %   The name of an inverse method as a string. Valid names are "sLORETA",
    %   "dSPM", "MNE" and "Dipole Scan".
    %
    % - mesh_resolution
    %
    %   The resolution of the mesh that will be constructed based on the
    %   project_path.
    %
    % - n_of_sources
    %
    %   The number of sources that are to be injected into the active brain
    %   compartments, and according to which the lead field will be computed.
    %
    % - n_of_runs
    %
    %   The number of reconstructions that will be constructed for statistical
    %   purposes. Multiple are needed, if noise is added to the model via...
    %
    % - noise_level_db
    %
    %   The assumed noise level that is to be used when inverting the computed
    %   lead field.
    %
    % - diff_type
    %
    %   One of "L2" or "minabs". Determines how the position difference
    %   metrics between reconstructions and the original dipoles are computed.
    %
    % - args.use_gpu
    %
    %   A name–value argument which determines whether a GPU will be used to
    %   perform the relevant computations (if available).
    %
    % Output:
    %
    % - sensitivities_with_statistics
    %
    %   The computed sensitivities or differences between positions,
    %   orientations and magnitudes of the source and inverted dipoles.
    %

    arguments

        project_path (1,:) char

        inverse_method (1,:) char { mustBeMember(inverse_method, ["sLORETA", "dSPM", "MNE", "Dipole Scan"]) }

        mesh_resolution (1,1) double { mustBeReal, mustBePositive }

        n_of_sources (1,1) double { mustBeInteger, mustBePositive }

        n_of_runs (1,1) double { mustBeInteger, mustBePositive }

        noise_level_db (1,1) double { mustBeNonpositive } = -30

        diff_type (1,1) string { mustBeMember(diff_type, ["L2", "minabs"]) } = "L2"

        args.use_gpu (1,1) logical = false;

    end

    % Load an initial project struct from the given path.

    project_struct = zeffiro_interface( ...
        'start_mode','nodisplay', ...
        'use_github', false, ...
        'use_gpu', args.use_gpu, ...
        'open_project', project_path ...
    );

    % Set mesh resolution and generate a finite element mesh.

    project_struct.mesh_resolution = mesh_resolution;

    % This is disabled for now, so that the pre-existing mesh stored on Puhti
    % is used as-is.
    %
    % project_struct = zef_create_finite_element_mesh(project_struct);

    % Set the number of (dipolar) sources to be reconstructed.

    project_struct.n_sources = n_of_sources;

    project_struct = zef_eeg_lead_field(project_struct);

    % Start the MNE tool and calculate reconstruction sensitivities for the
    % given MNE type.

    project_struct = zef_minimum_norm_estimation(project_struct);

    if inverse_method == "sLORETA" ...
    || inverse_method == "dSPM" ...
    || inverse_method == "MNE" ...

        sensitivities = zef_sensitivity_map_mne(project_struct, inverse_method, n_of_runs, noise_level_db, diff_type);

    elseif inverse_method == "Dipole Scan"

        sensitivities = zef_sensitivity_map_dipoleScan(project_struct, n_of_runs, noise_level_db, diff_type);

    else

        error("Unknown inverse method.")

    end

    sensitivities_with_statistics = add_statistics_to_struct(sensitivities, n_of_runs);

end % function

%% Local helper functions.

function output_struct = add_statistics_to_struct(input_struct, n_reconstructions)

    %
    % add_statistics_to_struct
    %
    % Adds means and standard sample deviations to a given struct. Requires
    % that the fields dist_vec, angle_vec and mag_vec are contained within
    % the input struct.
    %

    arguments

        input_struct (1,1) struct

        n_reconstructions (1,1) double { mustBeInteger, mustBePositive }

    end

    % Preallocate space for the statistics.

    input_struct.dist_vec_avg = zeros(size(input_struct.dist_vec{1}));
    input_struct.angle_vec_avg = zeros(size(input_struct.angle_vec{1}));
    input_struct.mag_vec_avg = zeros(size(input_struct.mag_vec{1}));

    input_struct.dist_vec_std = zeros(size(input_struct.dist_vec{1}));
    input_struct.angle_vec_std = zeros(size(input_struct.angle_vec{1}));
    input_struct.mag_vec_std = zeros(size(input_struct.mag_vec{1}));

    % Compute means.

    for i = 1 : n_reconstructions

        input_struct.dist_vec_avg = input_struct.dist_vec_avg + input_struct.dist_vec{i};
        input_struct.angle_vec_avg = input_struct.angle_vec_avg + input_struct.angle_vec{i};
        input_struct.mag_vec_avg = input_struct.mag_vec_avg + input_struct.mag_vec{i};

    end

    input_struct.dist_vec_avg = input_struct.dist_vec_avg/n_reconstructions;
    input_struct.angle_vec_avg = input_struct.angle_vec_avg/n_reconstructions;
    input_struct.mag_vec_avg = input_struct.mag_vec_avg/n_reconstructions;

    % Compute standard deviations.

    for i = 1 : n_reconstructions
        input_struct.dist_vec_std = input_struct.dist_vec_std + (input_struct.dist_vec{i} - input_struct.dist_vec_avg).^2;
        input_struct.angle_vec_std = input_struct.angle_vec_std + (input_struct.angle_vec{i} - input_struct.angle_vec_avg).^2;
        input_struct.mag_vec_std = input_struct.mag_vec_std + (input_struct.mag_vec{i} - input_struct.mag_vec_avg).^2;
    end

    input_struct.dist_vec_std = sqrt(input_struct.dist_vec_std/(n_reconstructions-1));
    input_struct.angle_vec_std = sqrt(input_struct.angle_vec_std/(n_reconstructions-1));
    input_struct.mag_vec_std = sqrt(input_struct.mag_vec_std/(n_reconstructions-1));

    % Everything succeeded, so set output value.

    output_struct = input_struct;

end
