classdef IASInverter < inverse.CommonInverseParameters & dynamicprops

    %
    % IASInverter
    %
    % A class which defines the properties needed by the IAS inversion method,
    % and the method itself.
    %

    properties
        %
        %This defines the post-hoc weighting used with the Bayesian model
        %of Gaussian likelihood, Gaussian prior and inverse gamma or gamma
        %hyperprior where the hyperparameter are updated via IAS algorithm
        %
        method_type (1,1) string { mustBeMember(method_type, ["None", "sLORETA last step", "dSPM each step", "dSPM last step"]) } = "None"

        %
        %Defines the used hyperprior model; either gamma or inverse gamma
        %distribution
        %
        hyperprior (1,1) string { mustBeMember(hyperprior, ["Inverse gamma", "Gamma"]) } = "Inverse gamma"      %Will replace the 'inv_hyperprior' field, further modification needed in some option tool that controls this.
        
        %
        %Number of IAS iterations
        %
        n_map_iterations (1,1) double {mustBeInteger, mustBePositive} = 25

        %
        % Hyperprior balancing options:
        %- "Constant" (non-balanced)
        %- "Balanced" (eLORETA-type variance-balancing)
        %
        hyperprior_mode (1,1) string { mustBeMember(hyperprior_mode, ...
            ["Constant", "Balanced"] ) } = "Constant";

        %
        % Parameter corresponding to the desired tail-length of hyperprior
        % in units of dB.
        %
        hyperprior_tail_length_db (1,1) double = 10

        %
        % Relative hyperprior weighting factor
        %
        hyperprior_weight (1,1) double = 0

        %
        % amplitude_db
        %
        % Signal amplitude correction factor (dB) for the prior-over-measurement SNR
        % computations.
        %
        amplitude_db (1,1) double = 20;

        %
        % prior_over_measurement_db
        %
        % Reference factor of prior-over-measurement SNR computation in units of dB.
        %
        prior_over_measurement_db (1,1) double = 20;


    end % properties

    properties (SetAccess = protected)
        %
        % DOI for the corresponding article
        %
        DOI (1,1) string = "https://doi.org/10.1137/080723995"
    
    end

    methods

        function self = IASInverter(args)

            %
            % IASInverter
            %
            % The constructor for this class.
            %

            arguments

                args.method_type = "None"

                args.hyperprior_mode = "Constant"   %Will replace the 'ias_hyperprior' field

                args.hyperprior = "Inverse gamma"

                args.n_map_iterations = 25      %Will replace the 'ias_n_map_iterations' field

                args.data_normalization_method = "Maximum entry"

                args.amplitude_db = 20

                args.prior_over_measurement_db = 20

                args.hyperprior_tail_length_db = 10

                args.hyperprior_weight = 0

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
                "signal_to_noise_ratio", args.signal_to_noise_ratio ...
            );

            % Initialize own fields.

            self.method_type = args.method_type;

            self.n_map_iterations = args.n_map_iterations;
            
            self.hyperprior = args.hyperprior;
            
            %consider adding these three to CommonInverseParameters since the prior mode is there too:
            self.hyperprior_mode = args.hyperprior_mode;
            
            self.hyperprior_tail_length_db = args.hyperprior_tail_length_db;
            
            self.hyperprior_weight = args.hyperprior_weight;

            %Print the statement
            self.InitialStatement
        end

        % Declare the initialize and inverse method defined in the files invert and initialize in this same
        % folder.

        self = initialize(self)

        [reconstruction, self] = invert(self, f, L, procFile, source_direction_mode)

        function self = terminateComputation(self)
            
            theta0 = findprop(self,'theta0');
            beta = findprop(self,'beta');
            d_sqrt = findprop(self,'d_sqrt');
            noise_cov = findprop(self,'noise_cov');
            delete(theta0);
            delete(beta);
            delete(noise_cov);
            delete(d_sqrt);
        end

    end % methods

    methods (Static)
        function InitialStatement 
            txt = strcat('This class object is for computing inversion with the Iterative Alter-\n'...
                , 'nating Sequential (IAS) hyperparameter updating method for a conditio-\n' ...
                , 'nally Gaussian model with inverse-gamma or gamma distributed hyperparam-\n' ...
                , 'eters.\n'...
                , 'If You find this method useful for Your thesis, or research or refer to\n'...
                , 'it in any text format, please consider citing the following articles:\n\n' ...
                , '⦁ Daniela Calvetti and Erkki Somersalo. "Gaussian hypermodels and recov-\n'...
                , 'ery of blocky objects", In: Inverse Problems, 23 (2007), pp. 733–754.\n\n'...
                , '⦁ Daniela Calvetti, Harri Hakula, Sampsa Pursiainen, and Erkki Somer-\n'...
                , 'salo. "Conditionally gaussian hypermodels for cerebral source localiza-\n'...
                , 'tion". In: SIAM Journal on Imaging Sciences, 2(3), pp. 879-31.\n'...
                , 'DOI:https://doi.org/10.1137/080723995 \n');
            
             fprintf(txt)
        end
    end %static methods

end % classdef