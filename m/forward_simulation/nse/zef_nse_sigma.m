function sigma_out = zef_nse_sigma(nse_field, nodes, tetra, domain_labels, sigma_in, s_interp_ind, singular_threshold)
%
% zef_nse_sigma
%
% Computes conductivities for the different brain compartments or tetrahedra
% in the finite element mesh, based on the capillary blood flow in those
% compartments.
%
% NOTE: this requires that the correct settings have been applied in the NSE
% tool, and the system has been solved with those settings. If capillaries are
% not computed, then of course this function will not work.
%
% Inputs:
%
% - nse_field (1,1) struct
%
%   The central struct of the NSE tool. Contains the settings specified in the
%   NSE tool window.
%
% - nodes (:,3) double
%
%   The nodes in the finite element mesh.
%
% - tetra (:,4) uint64 { mustBePositive }
%
%   The tetrahedral elements in the finite element mesh.
%
% - domain_labels (:,1) int64
%
%   Numerical labels of each tetrahedra. Tells which brain compartment each
%   tetrahedron belongs to.
%
% - sigma_in (:,1) double
%
%   The conductivities of the tetra in the mesh, before blood flow has been
%   taken into account.
%
% - s_interp_ind (:,4) uint64 { mustBePositive }
%
%   Some interpolation matrix.
%
% - singular_threshold (1,1) double { mustBePositive, mustBeLessThan ( singular_threshold, 1e-2 ) } = eps(1)
%
%   This is used in pruning problematic relative concentrations out of the
%   interpolated relative concentrations of blood in the tissues.
%
% Outputs:
%
% - sigma_out
%
%   An M-by-N matrix of conductivities, where M is the number of tetrahedra in
%   the mesh and N is the number of time frames in the simulation.
%

    arguments

        nse_field (1,1) struct

        nodes (:,3) double

        tetra (:,4) uint64 { mustBePositive }

        domain_labels (:,1) int64

        sigma_in (:,2) double

        s_interp_ind (:,4) uint64 { mustBePositive }

        singular_threshold (1,1) double { mustBePositive, mustBeLessThan ( singular_threshold, 1e-2 ) } = eps(1)

    end

    assert( numel(domain_labels) == size(tetra, 1), "The numbers of domain labels and tetrahedra do not match. Aborting..." );

    assert( size(sigma_in,1) == size(tetra, 1), "The numbers of conductivities and tetrahedra do not match. Aborting..." );

    mm_conversion = 0.001;

    % Preallocate the conductivity matrix. Each column corresponds to a time
    % frame.

    n_of_time_frames = size(nse_field.bf_capillaries, 2);

    cm = nse_field.conductivity_statistic ;

    if cm == 1 % All

        sigma_out = zeros ( size ( sigma_in(:,1), 1), n_of_time_frames ) ;

    elseif ismember(cm, [2, 3, 4, 5] ) % mean, std, max, min

        sigma_out = zeros ( size ( sigma_in (:,1), 1 ), 1 ) ;

    else

        error("Unknown conductivity mode. Aborting...")

    end

    % Set a title for the waitbar.

    if cm == 1

        wbtitle = "Conductivities for all time frames" ;

    elseif ismember ( cm , [2 ; 3])

        wbtitle = "Conductivity means" ;

    elseif cm == 4


        wbtitle = "Conductivity maxima" ;

    elseif cm == 5


        wbtitle = "Conductivity minima" ;

    else

        error("Unknown conductivity mode. Aborting...")

    end

    % Don't allocate sigma_std yet, in case it is not needed.

    sigma_std = [] ;

    [ sigma_out, ~ ] = conductivity_loop( ...
        nse_field, ...
        nodes, ...
        tetra, ...
        domain_labels, ...
        sigma_in, ...
        s_interp_ind, ...
        singular_threshold, ...
        n_of_time_frames, ...
        sigma_out, ...
        mm_conversion, ...
        @conductivity_fn, ...
        sigma_std, ...
        1, ...
        wbtitle ...
    );

    % If standard deviations of conductivities were to be computed, do
    % it here, now that we know the mean of the distribution.

    if nse_field.conductivity_statistic == 3

        sigma_std = zeros ( size ( tetra, 1 ), 1 );

        wbtitle = "Conductivity standard deviations" ;

        [ ~, sigma_std ] = conductivity_loop( ...
            nse_field, ...
            nodes, ...
            tetra, ...
            domain_labels, ...
            sigma_in, ...
            s_interp_ind, ...
            singular_threshold, ...
            n_of_time_frames, ...
            sigma_out, ...
            mm_conversion, ...
            @standard_deviation_fn, ...
            sigma_std, ...
            2, ...
            wbtitle ...
        );

        sigma_out = sqrt ( sigma_std ) ;

    end

end % function

%% Helper functions.

function sigma_out = conductivity_fn( ...
    nse_field, ...
    sigma_out, ...
    sigma_out_builder_vec, ...
    tfi, ...
    n_of_columns, ...
    ~ ...
)

%
% conductivity_fn
%
% Updates a given conductivity array based on the chosen conductivity mode.
%
% TODO: check if passing in a single column of sigma_out would be better.
%

    arguments

        nse_field (1,1) struct

        sigma_out (:,:) double

        sigma_out_builder_vec (:,1) double

        tfi (1,1) uint64 { mustBePositive }

        n_of_columns (1,1) uint64 { mustBePositive }

        ~

    end

    cm = nse_field.conductivity_statistic;

    if cm == 1 % all

        sigma_out(:,tfi) = sigma_out_builder_vec;

    elseif ismember(cm, [2 3]) % mean and std

        sigma_out = sigma_out + sigma_out_builder_vec ./ double(n_of_columns);

    elseif cm == 4 % maximum

        sigma_out = max(sigma_out_builder_vec, sigma_out);

    elseif cm == 5 % minimum

        sigma_out = min(sigma_out_builder_vec, sigma_out);

    else

        error("Unknown conductivity mode. Aborting...")

    end % if

end % function

function sigma_std = standard_deviation_fn( ...
    nse_field, ...
    sigma_out, ...
    sigma_out_builder_vec, ...
    ~, ...
    n_of_time_frames, ...
    sigma_std ...
)

%
% standard_deviation_fn
%
% Updates a given conductivity array based on the chosen conductivity mode.
%
% TODO: check if passing in a single column of sigma_out would be better.
%

    arguments

        nse_field (1,1) struct

        sigma_out (:,:) double

        sigma_out_builder_vec (:,1) double

        ~

        n_of_time_frames (1,1) uint64 { mustBePositive }

        sigma_std (:,1) double

    end

    cm = nse_field.conductivity_statistic;

    if cm == 3 % squared differences for standard deviation.

        squared_diffs = ( sigma_out - sigma_out_builder_vec ) .^ 2 ;

        % mean ( sigma_out )

        % mean ( sigma_out_builder_vec )

        % mean ( squared_diffs )

        sigma_std = sigma_std + squared_diffs ./ double ( n_of_time_frames ) ;

        % mean ( sigma_std )

    elseif ismember( cm, [1, 2, 4, 5] )

        % Do nothing.

    else

        error("Unknown conductivity mode. Aborting...")

    end % if

end % function

function [I1, I2] = filtering_inds_fn( ...
    active_domain_labels, ...
    capillary_domain_inds, ...
    interpolated_relative_blood_concentrations, ...
    singular_threshold ...
)

%
% filtering_inds_fn
%
% Constructs interpolation index sets needed in the case of Archie's
% conductivity model.
%
% Inputs:
%
% - active_domain_labels
%
%   The (integer) brain compartment labels of each tetrahedron.
%
% - capillary_domain_inds
%
%   The indices of the finite element tetra that form the capillary domain.
%
% - interpolated_relative_blood_concentrations
%
%   Interpolated relative concentrations in the capillary domain.
%
% - singular_threshold
%
%   Used to filter the returned index sets.
%
% Outputs:
%
% - I1
%
%   The wanted indices in the relative concentration container, that are in
%   the open interval (0,1) = [0 + threshold, 1 - threshold]. This final index
%   set is used with all of the containers related to sigma_out itself, such
%   as the volume container.
%
% - I2
%
%   Used to set too large values in interpolated_relative_blood_concentrations
%   to contain the value 1 - singular threshold, and
%   sigma_out(active_compartment_ind(I2),...) to contain the background blood
%   conductivity.
%

    arguments

        active_domain_labels (:,1) uint64 { mustBePositive }

        capillary_domain_inds (:,1) uint64 { mustBePositive }

        interpolated_relative_blood_concentrations

        singular_threshold (1,1) double { mustBePositive, mustBeLessThan ( singular_threshold, 1e-2 ) } = eps(1)

    end

    I5 = find(active_domain_labels == capillary_domain_inds);

    I_aux = find(abs(interpolated_relative_blood_concentrations(I5)) > singular_threshold);

    I4 = I5(I_aux);

    I3 = find(abs(interpolated_relative_blood_concentrations(I4)) > 1 - singular_threshold);

    I2 = I4(I3);

    I1 = setdiff(I4, I2);

end % function

function [ sigma_out, sigma_std ] = conductivity_loop( ...
    nse_field, ...
    nodes, ...
    tetra, ...
    domain_labels, ...
    sigma_in, ...
    s_interp_ind, ...
    singular_threshold, ...
    n_of_time_frames, ...
    sigma_out, ...
    mm_conversion, ...
    input_operation, ...
    sigma_std, ...
    iteration, ...
    waitbar_title ...
)

%
% conductivity_loop
%
% The main loop of the main function of this file.
%
% Inputs:
%
% - nse_field (1,1) struct
%
%   The same as for zef_nse_sigma.
%
% - nodes (:,3) double
%
%   The same as for zef_nse_sigma.
%
% - tetra (:,4) uint64 { mustBePositive }
%
%   The same as for zef_nse_sigma.
%
% - domain_labels (:,1) int64
%
%   The same as for zef_nse_sigma.
%
% - sigma_in (:,1) double
%
%   The same as for zef_nse_sigma.
%
% - s_interp_ind (:,4) uint64 { mustBePositive }
%
%   The same as for zef_nse_sigma.
%
% - singular_threshold (1,1) double { mustBePositive, mustBeLessThan ( singular_threshold, 1e-2 ) } = eps(1)
%
%   The same as for zef_nse_sigma.
%
% - n_of_time_frames
%
%   The number of time frames in the simulation, determined by the number of
%   relative concentrations in nse_field.
%
% - sigma_out
%
%   The pre-allocated conductivities or the statistics related to them.
%
% - mm_conversion
%
%   A conversion coefficient from millimeters to meters.
%
% - input_operation
%
%   A 8-argument function, where the arguments are as follows:
%
%   - nse_field
%
%   - sigma_out
%
%   - sigma_out_builder_vec
%
%   - active_compartment_ind
%
%   - I
%
%   - col_ind
%
%   - n_of_time_frames
%
%   - sigma_std
%
% - iteration
%
%   Is this the first or the second run.
%
% - waitbar_title
%
%   The title displayed by the waitbar.
%
% Outputs:
%
% - sigma_out
%
%   An M-by-N matrix of conductivities or their statistics, where M is the
%   number of tetrahedra in the mesh and N is either the number of time frames
%   in the simulation.
%
    arguments

        nse_field (1,1) struct

        nodes (:,3) double

        tetra (:,4) uint64 { mustBePositive }

        domain_labels (:,1) int64

        sigma_in (:,2) double

        s_interp_ind (:,4) uint64 { mustBePositive }

        singular_threshold (1,1) double { mustBePositive }

        n_of_time_frames (1,1) uint64 { mustBePositive }

        sigma_out (:,:) double

        mm_conversion (1,1) double { mustBePositive }

        input_operation (1,1) function_handle

        sigma_std (:,1) double

        iteration (1,1) uint8 { mustBeMember(iteration, [1,2]) }

        waitbar_title (1,1) string

    end % arguments

    % Initialize waitbar and its cleanup operations.

    wb = zef_waitbar ( 0, waitbar_title ) ;

    cleanup_fn = @(hh) close ( hh ) ;

    cleanup_obj = onCleanup ( @() cleanup_fn(wb) ) ;

    % Start iterating over time frames.

    computing_something_other_than_std = iteration == 1 ;

    computing_std = iteration == 2 && nse_field.conductivity_statistic == 3;

    for tfi = 1 : n_of_time_frames

        updated_waitbar_title = waitbar_title + ": time frame " + tfi + " / " + n_of_time_frames + "..." ;

        wb = zef_waitbar ( tfi / n_of_time_frames, wb, updated_waitbar_title ) ;

        interpolated_relative_blood_concentrations = mean ( min ( 1, max ( 0, abs ( nse_field.bf_capillaries{tfi}( s_interp_ind ) ) ) ), 2 );

        active_compartment_ind = find(ismember(domain_labels,nse_field.capillary_domain_ind));

        active_domain_labels = domain_labels(active_compartment_ind);

        [v_nodes, v_tetra, nse_field.bf_capillary_node_ind] = zef_get_submesh(nodes, tetra, active_compartment_ind);

        v_nodes = mm_conversion*v_nodes;

        [~, determinant] = zef_volume_barycentric(v_nodes,v_tetra);

        volume = abs(determinant)/6;

        active_sigma_in = sigma_in(active_compartment_ind,1);

        % Set up a vector for iteratively building sigma_out.

        if nse_field.conductivity_statistic == 5 % minimum

            sigma_out_builder_vec = Inf(size(sigma_out, 1), 1);

        else

            sigma_out_builder_vec = sigma_in (:,1) ; % zeros(size(sigma_out, 1), 1);

        end

        % Choose sigma_out column based on conductivity mode.

        if nse_field.conductivity_statistic == 1 % store conductivities for all time frames

            col_ind = tfi ;

        else % compute some statistic

            col_ind = 1 ;

        end

        if isequal(nse_field.conductivity_model,1) % Archie's law

            for cdi = 1 : length(nse_field.capillary_domain_ind)

                capillary_domain_inds = nse_field.capillary_domain_ind ( cdi ) ;

                [ I1, I2 ] = filtering_inds_fn( ...
                    active_domain_labels, ...
                    capillary_domain_inds, ...
                    interpolated_relative_blood_concentrations, ...
                    singular_threshold ...
                );

                sigma_out_builder_vec(active_compartment_ind(I2), col_ind) = nse_field.blood_conductivity;

                interpolated_relative_blood_concentrations(I2) = 1 - singular_threshold;

                volume_aux = sum(volume(I1));

                background_conductivity = sum(active_sigma_in(I1).*volume(I1))./volume_aux;

                m = nse_field.conductivity_exponent;

                s = log(1-interpolated_relative_blood_concentrations(I1).^m)./log(1-interpolated_relative_blood_concentrations(I1));

                sigma_out_builder_vec(active_compartment_ind(I1)) = (1-interpolated_relative_blood_concentrations(I1)).^s.*background_conductivity + nse_field.blood_conductivity .* interpolated_relative_blood_concentrations(I1).^m;

            end % for

            % If we are computing the standard deviation, modify sigma_std
            % instead of sigma_out during the second iteration.

            result = input_operation ( ...
                nse_field, ...
                sigma_out, ...
                sigma_out_builder_vec, ...
                col_ind, ...
                n_of_time_frames, ...
                sigma_std ...
            ) ;

            if computing_something_other_than_std

                sigma_out = result ;

            elseif computing_std

                sigma_std = result ;

            else

                error("Either this was not the first iteration of conductivity_loop, or something other than STD was to be computed during the second iteration. Aborting...")

            end

        elseif isequal(nse_field.conductivity_model,2) % Hashin--Shtrikman upper bound

            for cdi = 1 : length(nse_field.capillary_domain_ind)

                capillary_domain_inds = nse_field.capillary_domain_ind ( cdi ) ;

                [ I1, I2 ] = filtering_inds_fn( ...
                    active_domain_labels, ...
                    capillary_domain_inds, ...
                    interpolated_relative_blood_concentrations, ...
                    singular_threshold ...
                );

                sigma_out_builder_vec(active_compartment_ind(I2), col_ind) = nse_field.blood_conductivity;

                interpolated_relative_blood_concentrations(I2) = 1 - singular_threshold;

                volume_aux = sum(volume(I1));

                background_conductivity = sum(active_sigma_in(I1).*volume(I1))./volume_aux;

                sigma_out_builder_vec(active_compartment_ind(I1)) = background_conductivity.*(1-interpolated_relative_blood_concentrations(I1)) + nse_field.blood_conductivity.*(interpolated_relative_blood_concentrations(I1));

            end % for

            % If we are computing the standard deviation, modify sigma_std
            % instead of sigma_out during the second iteration.

            result = input_operation ( ...
                nse_field, ...
                sigma_out, ...
                sigma_out_builder_vec, ...
                col_ind, ...
                n_of_time_frames, ...
                sigma_std ...
            ) ;

            if computing_something_other_than_std

                sigma_out = result ;

            elseif computing_std

                sigma_std = result ;

            else

                error("Either this was not the first iteration of conductivity_loop, or something other than STD was to be computed during the second iteration. Aborting...")

            end

        elseif isequal(nse_field.conductivity_model,3) % Hashin--Shtrikman lower bound

            for cdi = 1 : length(nse_field.capillary_domain_ind)

                capillary_domain_inds = nse_field.capillary_domain_ind ( cdi ) ;

                [ I1, I2 ] = filtering_inds_fn( ...
                    active_domain_labels, ...
                    capillary_domain_inds, ...
                    interpolated_relative_blood_concentrations, ...
                    singular_threshold ...
                );

                sigma_out_builder_vec(active_compartment_ind(I2), col_ind) = nse_field.blood_conductivity;

                interpolated_relative_blood_concentrations(I2) = 1 - singular_threshold;

                volume_aux = sum(volume(I1));

                background_conductivity = sum(active_sigma_in(I1).*volume(I1))./volume_aux;
                
                sigma_out_builder_vec(active_compartment_ind(I1)) = background_conductivity.*(1 + (3.*interpolated_relative_blood_concentrations(I1).*(nse_field.blood_conductivity-background_conductivity))./(3.*background_conductivity + (1 - interpolated_relative_blood_concentrations(I1)).*(nse_field.blood_conductivity-background_conductivity)));

            end % for

            % If we are computing the standard deviation, modify sigma_std
            % instead of sigma_out during the second iteration.

            result = input_operation ( ...
                nse_field, ...
                sigma_out, ...
                sigma_out_builder_vec, ...
                col_ind, ...
                n_of_time_frames, ...
                sigma_std ...
            ) ;

            if computing_something_other_than_std

                sigma_out = result ;

            elseif computing_std

                sigma_std = result ;

            else

                error("Either this was not the first iteration of conductivity_loop, or something other than STD was to be computed during the second iteration. Aborting...")

            end

        else

            error("Uknown conductivity model. Aborting...")

        end % if

    end % for

end % function