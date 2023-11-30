classdef LeadFieldParams
%
% LeadFieldParams
%
% This class defines the input parameters to the lead field generation
% functions, that are only utilized inside of those functions and are not
% stored into the central data structure zef. A user of a lead field routine
% should construct an object of this class, and then pass it to the lead field
% routine as the "params" keyword argument.
%

    properties
        %
        % Determines the amount of peeling applied to the possible source
        % locations, before lead field construction is started.
        %
        acceptable_source_depth (1,1) double { mustBeNonnegative } = 0
        %
        % This field adjusts the quantile, above which columns would be removed
        % from the lead field based on their column norm.
        %
        lead_field_filter_quantile (1,1) double { mustBeGreaterThanOrEqual( lead_field_filter_quantile, 0 ), mustBeLessThanOrEqual( lead_field_filter_quantile, 1 ) } = 1
        %
        % The type of lead field one wishes to compute. Here 1 = EEG, 2 = MEG,
        % 3 = gMEG, 4 = EIT and 5 = tES.
        %
        lead_field_type (1,1) double { mustBeMember ( lead_field_type, [ 1, 2, 3, 4, 5 ] ) } = 1
        %
        % Sets whether a lead field is normalized based on the maximum value in
        % a column, the column norm, etc. This is possibly a legacy field
        % related to the Lead Field Bank Tool, but it is listed here for
        % completeness (for now).
        %
        lf_normalization (1,1) double { mustBeMember ( lf_normalization, [1, 2, 3, 4] ) } = 1
        %
        % Sets the unit of the source positions the lead field was constructed
        % from, in relation to meters. Here 1 ↦ mm, 2 ↦ cm and 3 ↦ m.
        %
        location_unit (1,1) double { mustBeMember( location_unit, [1,2,3]) } = 1
        %
        % The number of sources that are to be generated at the start of the
        % lead field computation. Note that this is an approximation, the
        % goodness of which depends on the value of
        % source_space_creation_iterations, as the placement of sources into
        % the volume is an iterative process.
        %
        n_sources (1,1) double { mustBePositive } = 1e4
        %
        % This defines which type of optimization method is used when dipoles
        % are interpolated into place, when the Whitney/Raviart–Thomas or
        % H(div) source models are used. Here "pbo" ↦ Position-Based
        % Optimization and "mpo" ↦ Mean Position and Orientation.
        %
        optimization_system_type (1,:) string { mustBeMember ( optimization_system_type, [ "pbo", "mpo" ] ) } = "pbo"
        %
        % Defines the type of preconditioner used by the preconditioned
        % conjugate gradient solver of the transfer matrix (lead field before
        % adjustments). Here 1 ↦ Cholinc and 2 ↦ SSOR.
        %
        preconditioner (1,1) double { mustBeMember ( preconditioner, [1, 2] ) } = 1
        %
        % Determines the numerical tolerance (accuracy) of the used
        % preconditioner.
        %
        preconditioner_tolerance (1,1) double { mustBePositive } = 0.001
        %
        % Determines the accuracy of the solver during PCG iteration.
        %
        solver_tolerance (1,1) double { mustBePositive } = 1e-8
        %
        % Determines whether to generate use Cartesian (1), surface-normal (2)
        % or face-based (3) sources. Note that Cartesian sources are usually
        % utilized in literature.
        %
        source_direction_mode (1,1) double { mustBeMember ( source_direction_mode, [1, 2, 3] ) } = 1
        %
        % If this is false, sources will not be interpolated into a place after
        % a lead field has been constructed.
        %
        source_interpolation_on (1,1) logical = true
        %
        % Determines which source model is to be used when generating sources.
        % Most tested ones are core.ZefSourceModel.{Whitney,Hdiv}, so one
        % should probably stick to these for now.
        %
        source_model (1,1) core.ZefSourceModel = core.ZefSourceModel.Hdiv
        %
        % Determines many iterations of source placements are attempted, to get
        % to the number of sources specified by n_sources.
        %
        source_space_creation_iterations (1,1) double { mustBeInteger, mustBePositive } = 10
        %
        % This might determine how deeply electrodes or other sensors are
        % forced into the volume conductor. Mainly used by the function
        % zef_attach_sensors_volume.
        %
        use_depth_electrodes (1,1) logical = false
        %
    end % properties

    methods

        function self = LeadFieldParams ( kwargs )
        %
        % self = LeadFieldParams ( kwargs )
        %
        % A constructor of this class. The kwargs contain the properties of
        % this class, that one wishes to set. The ones that are omitted will
        % use the default values.
        %

            arguments
                kwargs.acceptable_source_depth = 0
                kwargs.lead_field_filter_quantile = 1
                kwargs.lead_field_type = 1
                kwargs.lf_normalization = 1
                kwargs.location_unit = 1
                kwargs.n_sources = 1e4
                kwargs.optimization_system_type = "pbo"
                kwargs.preconditioner = 1
                kwargs.preconditioner_tolerance = 0.001
                kwargs.solver_tolerance = 1e-8
                kwargs.source_direction_mode = 1
                kwargs.source_interpolation_on = true
                kwargs.source_model = core.ZefSourceModel.Hdiv
                kwargs.source_space_creation_iterations = 10
                kwargs.use_depth_electrodes = false
            end

            fns = string ( fieldnames ( kwargs ) ) ;

            for fnI = 1 : numel ( fns )

                self.(fns(fnI)) = kwargs.(fns(fnI)) ;

            end % for

        end % function

    end % methods

end % classdef
