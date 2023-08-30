classdef EXPInverter < inverse.CommonInverseParameters

    %
    % EXPInverter
    %
    % A class which defines the properties needed by the MNE inversion method,
    % and the method itself.
    %

    properties

        estimation_type (1,1) string { mustBeMember(estimation_type, ["IAS", "EM", "sLORETA"]) } = "IAS"

        use_multiresolution (1,1) logical = false;

        hyperprior_mode (1,1) string { mustBeMember( ...
            hyperprior_mode, ...
            [ "balanced", "constant", "manually selected" ] ...
        ) } = "constant";

        beta (1,1) double {mustBePositive} = 3;

        theta0 (1,1)  double {mustBePositive} = 1e-10;

        q (1,1) int8 {mustBeInRange(q,1,2)} = 1;

        n_map_iterations (1,1) int16 {mustBePositive,mustBeInteger} = 25;

        n_L1_iterations (1,1) int16 {mustBePositive,mustBeInteger} = 5;

        multiresolution_levels_number (1,1) int16 {mustBePositive,mustBeInteger} = 10;

        multiresolution_sparsity_factor (1,1)  double {mustBeNonnegative} = 0.001;

        multiresolution_decomposition_number (1,1) int16 {mustBePositive,mustBeInteger} = 10;

        %consider adding these three to CommonInverseParameters since the prior_mode is there too:
        inv_hyperprior_tail_length_db (1,1) double = 10

        inv_hyperprior_weight (1,1) double = 0

    end % properties

    methods

        function self = EXPInverter(args)

            %
            % EXPInverter
            %
            % The constructor for this class.
            %

            arguments

                args.beta = 3

                args.theta0 = 1e-10

                args.q = 1

                args.hyperprior_mode = "constant"

                args.n_map_iterations = 25

                args.n_L1_iterations = 5

                args.estimation_type = "IAS"

                args.use_multiresolution = false

                args.multiresolution_levels_number = 10;

                args.multiresolution_sparsity_factor = 0.001;

                args.multiresolution_decomposition_number = 10;

                args.data_normalization_method = "maximum entry"

                args.high_cut_frequency = 9

                args.inv_amplitude_db = 1

                args.inv_prior_over_measurement_db = 1

                args.inv_hyperprior_tail_length_db = 10

                args.inv_hyperprior_weight = 0

                args.low_cut_frequency = 7

                args.number_of_frames = 1

                args.sampling_frequency = 1024

                args.signal_to_noise_ratio = 30

                args.time_start = 0

                args.time_window = 1

                args.time_step = 1

            end

            % Initialize superclass fields.

            self = self@inverse.CommonInverseParameters( ...
                "low_cut_frequency" ,args.low_cut_frequency, ...
                "high_cut_frequency", args.high_cut_frequency, ...
                "data_normalization_method", args.data_normalization_method, ...
                "number_of_frames", args.number_of_frames, ...
                "sampling_frequency", args.sampling_frequency, ...
                "time_start", args.time_start, ...
                "time_window", args.time_window, ...
                "time_step", args.time_step, ...
                "signal_to_noise_ratio", args.signal_to_noise_ratio, ...
                "inv_amplitude_db", args.inv_amplitude_db, ...
                "inv_prior_over_measurement_db", args.inv_prior_over_measurement_db ...
            );

            % Initialize own fields.

            self.estimation_type = args.estimation_type;

            self.use_multiresolution = false;

            self.beta = args.beta;

            self.theta0 = args.theta0;

            self.q = args.q;

            self.hyperprior_mode = args.hyperprior_mode;

            self.n_map_iterations = args.n_map_iterations;

            self.n_L1_iterations = args.n_L1_iterations;

            self.multiresolution_levels_number = args.multiresolution_levels_number;

            self.multiresolution_sparsity_factor = args.multiresolution_sparsity_factor;

            self.multiresolution_decomposition_number = args.multiresolution_decomposition_number;

            self.inv_hyperprior_tail_length_db = args.inv_hyperprior_tail_length_db;
            
            self.inv_hyperprior_weight = args.inv_hyperprior_weight;

        end
    
        % Declare the inverse method defined in the file invert, in this same
        % folder.

            reconstruction = invert(self)

    end % methods

end % classdef