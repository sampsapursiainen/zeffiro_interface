classdef KalmanInverter < inverse.CommonInverseParameters

    %
    % KalmanInverter, Copyright © 2025- Joonas Lahtinen
    %
    % A class which defines the properties needed by the Kalma filter / Standardized Kalman filter inversion method,
    % and the method itself.
    % The method is based on the article:
    % "Standardized Kalman filtering for dynamical source localization of concurrent subcortical and cortical brain activity"
    % In: Clinical neurophysiology 168 (2024),
    % DOI: https://doi.org/10.1016/j.clinph.2024.09.021.
    %

    properties

        %
        %The inverse algorithm used. The options are: dSPM, sLORETA,
        %sLORETA's 3D implementation and Sparse Bayesian learning
        %
        method_type (1,1) string { mustBeMember(method_type, ["Basic Kalman filter", "Standardized Kalman filter", "Approximated Standardized Kalman filter", "Ensembled Kalman filter"]) } = "Basic Kalman filter"

        %
        %Evolution prior model
        %The "sensitivity scaling option is based on D. Calvetti et al. approach from the article 
        % "Brain Activity Mapping from MEG Data via a Hierarchical Bayesian
        % Algorithm with Automatic Depth Weighting" (2017)
        %The SVD-based approach is one step more general version of
        %sensitivity weighting that uses SVD to ensure the simulated data
        %to match with the observed/assumed distribution of measurements
        %"Avg." prefix indicates that the "sensitivity balancing" is
        %averaged over, yielding i.i.d distributed evolution.
        %"Reworked original" uses the approach from the article 
        % "Standardized Kalman filtering for dynamical source localization
        % of concurrent subcortical and cortical brain activity" (2024)
        %but the physiology-based scaling is reworked to not be tied in a
        %certain set of units.
        %
        evolution_prior_model (1,1) string { mustBeMember(evolution_prior_model, ["Sensitivity scaling", "Avg. sensit. scaling", "SVD-based", "Avg. SVD-based", "Reworked original"]) } = "Sensitivity scaling"

        %
        %Number of ensembles
        %
        number_of_ensembles (1,1) int8 {mustBeNonnegative, mustBeInteger} = 100

        %
        %use smoothing
        %
        use_smoothing (1,1) = false

        %
        %smoother type
        %
        smoother_type (1,1) string { mustBeMember(smoother_type, ["None", "RTS"]) } = "None"

        %
        %state transition model of Kalman Filter (usually denoted A)
        %
        state_transition_model_A = [];

        %
        %evolution prior scaling parameter (in dB)
        evolution_prior_db = -34

        %
        %dB value for steering the intial prior
        %
        initial_prior_steering_db = 0;

        %
        %Number of the beginning steps that are considered as pure noise as
        %possible
        %
        number_of_noise_steps = 4

        %
        %initial prior variance
        %
        theta0 = []

        %
        %measurement noise covariance matrix
        %
        noise_cov = [];

        %
        %the evolution variance
        %
        evolution_cov = [] 

        %
        %Prevoius step reconstruction
        %
        prev_step_reconstruction = []
    
        %
        %Previous step posterior covariance
        %
        prev_step_posterior_cov = []

        %
        %Stored posterior covariances
        %
        posterior_covs = cell(0)

    end % properties

    properties (SetAccess = protected)

        %
        % DOI to the corresponding article
        %
        DOI (1,1) string = "https://doi.org/10.1016/j.clinph.2024.09.021"
    end

    methods
        %set the use_smoothing to a logical value. Set simultaneously the
        %smoother type to "None" when use_smoothing set to false
        function obj = set.use_smoothing(obj,val)
            if islogical(val)
                obj.use_smoothing = val;
            elseif isnumeric(val)
                    obj.use_smoothing = logical(val);
            else
                error("Field 'use_RTS_smoothing' should be logical.")
            end

        end

        %setter to set the use_smoothing to true, when smoothing is used
        %and visa versa
        function obj = set.smoother_type(obj,val)
            if strcmp(val,"None")
                obj.use_smoothing = false;
            else
                obj.use_smoothing = true;
            end
        end


        function self = KalmanInverter(args)

            %
            % KalmanInverter
            %
            % The constructor for this class.
            %

            arguments

                args.method_type = "Basic Kalman filter"

                args.evolution_prior_model = "Sensitivity scaling"

                args.state_transition_model_A = [];

                args.number_of_ensembles = 100

                args.use_smoothing = false

                args.smoother_type = "None"

                args.number_of_noise_steps = 4

                args.evolution_prior_db = -34

                args.initial_prior_steering_db = 0

                args.theta0 = [];

                args.noise_cov = [];

                args.evolution_cov = [];

                args.prev_step_reconstruction = [];

                args.prev_step_posterior_cov = [];
                
                args.posterior_covs = cell(0);

                args.data_normalization_method = "Maximum entry"

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
                "signal_to_noise_ratio", args.signal_to_noise_ratio...
            );

            % Initialize own fields.

            self.method_type = args.method_type;

            self.evolution_prior_model = args.evolution_prior_model;

            self.state_transition_model_A = args.state_transition_model_A;

            self.number_of_ensembles = args.number_of_ensembles;

            self.use_smoothing = args.use_smoothing;

            self.smoother_type = args.smoother_type;

            self.number_of_noise_steps = args.number_of_noise_steps;

            self.evolution_prior_db = args.evolution_prior_db;

            self.initial_prior_steering_db = args.initial_prior_steering_db;

            self.theta0 = args.theta0;

            self.noise_cov = args.noise_cov;

            self.evolution_cov = args.evolution_cov;

            self.prev_step_posterior_cov = args.prev_step_posterior_cov;

            self.prev_step_reconstruction = args.prev_step_reconstruction;

            %Print the statement:
            self.InitialStatement

        end

        % Declare the inverse method defined in the file invert, in this same
        % folder.

        self = initialize(self)

        [reconstruction, self] = invert(self, f, L, procFile, source_direction_mode)

        [reconstruction, self] = smoother(self, z_inverse)

    end % methods

    methods (Static)
        function InitialStatement 
            txt = strcat('This class object is for computing inversion with the (Basic) Kalman\n'...
    , 'filter, the Standardized Kalman filter or Ensembled Kalman filter.\n'...
    , 'If You find this method useful for Your thesis, or research or refer to\n'...
    , 'it in any text format, please consider citing the following article:\n\n' ...
    , 'Joonas Lahtinen, Paavo Ronni, Narayan Puthanmadam Subramaniyam,\n'...
    , 'Alexandra Koulouri, Carsten Wolters, and Sampsa Pursiainen.\n'...
    , '"Standardized Kalman filtering for dynamical source localization of con-\n'...
    , 'current subcortical and cortical brain activity".\n'...
    , 'In: Clinical neurophysiology 168 (2024), pp. 15–24. ISSN: 1388-2457.\n'...
    , 'DOI: https://doi.org/10.1016/j.clinph.2024.09.021.\n');
            
            fprintf(txt)
        end
    end %static methods 

end % classdef
