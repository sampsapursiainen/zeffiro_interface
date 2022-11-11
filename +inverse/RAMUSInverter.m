classdef RAMUSInverter < inverse.CommonInverseParameters

    %
    % RAMUSInverter
    %
    % A class which defines the properties needed by the MNE inversion method,
    % and the method itself.
    %

    properties

        %These three objects are either empty numerics or nested cells.
        %Fromat is:
        %multiresolution_dec{Decomposition_j}{multires_lvl_n}
        %
        %Source space indices of each decomposition for every
        %multiresolution level.
        %
        multiresolution_dec = [];
        
        %
        %Interpolation indices from a decomposition to the full source space
        %
        multiresolution_ind = [];
        
        %
        %Number of source locations where a source point in a decomposition
        %is interpolated to.
        %
        multiresolution_count = [];

        %
        %This defines the post-hoc weighting used with the Bayesian model
        %of Gaussian likelihood, Gaussian prior and inverse gamma or gamma
        %hyperprior where the hyperparameter are updated via IAS algorithm
        %
        ias_type (1,:) char { mustBeMember(ias_type, ['None', 'sLORETA each step', 'sLORETA last step', 'dSPM each step', 'dSPM last step']) } = 'None'

        %
        %Defines the used hyperprior model; either gamma or inverse gamma
        %distribution
        %
        hyperprior (1,1) string { mustBeMember(hyperprior, ["Inverse gamma", "Gamma"]) } = "Inverse gamma"      %Will replace the 'inv_hyperprior' field, further modification needed in some option tool that controls this.

        %
        %Number of IAS iterations. Can be a 1xn vector in case of RAMUS;
        %having different number of iterations on different resolution
        %level
        %
        n_map_iterations (1,:) int16 { mustBeInteger } = 10

        %
        %Number of multiresolution levels
        %
        number_of_multiresolution_levels (1,1) int32 {mustBePositive, mustBeInteger} = 3

        %
        %sparsity factor: defines how many times denser the next level
        %is compared to previous one
        %
        sparsity_factor (1,1) int32 {mustBePositive, mustBeInteger} = 10

        %
        %Number of sampled resolution levels of a certain size
        %
        number_of_decompositions (1,1) int32 {mustBePositive, mustBeInteger} = 20

        %consider adding these three to CommonInverseParameters since the prior_mode is there too:
        hyperprior_mode (1,1) string { mustBeMember(hyperprior_mode, ...
            [ "balanced", "constant" ] ) } = "constant";

        inv_hyperprior_tail_length_db (1,1) double = 10

        inv_hyperprior_weight (1,1) double = 0

    end % properties

    methods

        function self = RAMUSInverter(args)

            %
            % RAMUSInverter
            %
            % The constructor for this class.
            %

            arguments

                args.multiresolution_dec = [];
        
                args.multiresolution_ind = [];
        
                args.multiresolution_count = [];

                args.number_of_multiresolution_levels = 3  %Will replace 'ramus_multires_n_levels'

                args.sparsity_factor = 10 %Will replace 'ramus_multires_sparsity'

                args.number_of_decompositions = 20  %Will replace 'ramus_multires_n_decompositions'

                args.ias_type = 'None'      %Probably upcoming feature

                args.hyperprior_mode = "constant"   %Will replace the 'rammus_hyperprior' field

                args.hyperprior = "Inverse gamma"

                args.n_map_iterations = 10      %Will replace the 'ramus_multires_n_iter' field

                args.data_normalization_method = "maximum entry"

                args.inv_amplitude_db = 20

                args.inv_prior_over_measurement_db = 20

                args.inv_hyperprior_tail_length_db = 10

                args.inv_hyperprior_weight = 0

                args.high_cut_frequency = 9

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

            self.multiresolution_dec = args.multiresolution_dec;
            self.multiresolution_ind = args.multiresolution_ind;
            self.multiresolution_count = args.multiresolution_count;
            self.ias_type = args.ias_type;
            self.number_of_multiresolution_levels = args.number_of_multiresolution_levels;
            self.sparsity_factor = args.sparsity_factor;
            self.number_of_decompositions = args.number_of_decompositions;
            self.n_map_iterations = args.n_map_iterations;
            self.hyperprior = args.hyperprior;
            %consider adding these three to CommonInverseParameters since the prior mode is there too:
            self.hyperprior_mode = args.hyperprior_mode;
            self.inv_hyperprior_tail_length_db = args.inv_hyperprior_tail_length_db;
            self.inv_hyperprior_weight = args.inv_hyperprior_weight;

        end

        %IDK what I am doing but this function calculates the
        %multiresolution decompositions as it would by pressing the make
        %decomposition button
        function self = make_multires_dec(args)
            [self.multiresolution_dec, self.multiresolution_ind, self.multiresolution_count] = zef_make_multires_dec(args.number_of_decompositions, args.number_of_multiresolution_levels, args.sparsity_factor);
        end

        % Declare the inverse method defined in the file invert, in this same
        % folder.

        reconstruction = invert(self)

    end % methods

end % classdef