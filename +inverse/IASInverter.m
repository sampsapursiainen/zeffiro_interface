classdef IASInverter < inverse.CommonInverseParameters

    %
    % IASInverter
    %
    % A class which defines the properties needed by the MNE inversion method,
    % and the method itself.
    %

    properties
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
        %Number of IAS iterations
        %
        n_map_iterations (1,1) double {mustBeInteger, mustBePositive} = 25

        %consider adding these three to CommonInverseParameters since the prior_mode is there too:
        hyperprior_mode (1,1) string { mustBeMember(hyperprior_mode, ...
            [ "balanced", "constant" ] ) } = "constant";

        inv_hyperprior_tail_length_db (1,1) double = 10

        inv_hyperprior_weight (1,1) double = 0


    end % properties

    methods

        function self = IASInverter(args)

            %
            % IASInverter
            %
            % The constructor for this class.
            %

            arguments

                args.ias_type = 'None'

                args.hyperprior_mode = "constant"   %Will replace the 'ias_hyperprior' field

                args.hyperprior = "Inverse gamma"

                args.n_map_iterations = 25      %Will replace the 'ias_n_map_iterations' field

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

            self.ias_type = args.ias_type;

            self.n_map_iterations = args.n_map_iterations;
            
            self.hyperprior = args.hyperprior;
            
            %consider adding these three to CommonInverseParameters since the prior mode is there too:
            self.hyperprior_mode = args.hyperprior_mode;
            
            self.inv_hyperprior_tail_length_db = args.inv_hyperprior_tail_length_db;
            
            self.inv_hyperprior_weight = args.inv_hyperprior_weight;

        end

        % Declare the inverse method defined in the file invert, in this same
        % folder.

        reconstruction = invert(self)

    end % methods

end % classdef