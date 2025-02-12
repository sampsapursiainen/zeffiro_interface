%% Copyright © 2025- Joonas Lahtinen and Alexandra Koulouri
classdef GroupLassoInverter < inverse.CommonInverseParameters & dynamicprops

    %
    % GroupLassoInverter
    %
    % A class which defines the properties needed by the GroupLasso inversion method,
    % and the method itself.
    %

    properties

        estimation_type (1,1) string { mustBeMember(estimation_type, ["IAS", "EM", "Standardized"]) } = "IAS"

        use_multiresolution (1,1) logical = false;

        hyperprior_mode (1,1) string { mustBeMember( ...
            hyperprior_mode, ...
            [ "Sensitivity weighted", "Manually selected" ] ...
        ) } = "Sensitivity weighted";

        beta (1,1) double {mustBePositive} = 3;

        theta0 (1,1)  double {mustBePositive} = 1e-10;

        n_map_iterations (1,1) int16 {mustBePositive,mustBeInteger} = 25;

        n_L1_iterations (1,1) int16 {mustBePositive,mustBeInteger} = 5;

        multiresolution_levels_number (1,1) int16 {mustBePositive,mustBeInteger} = 10;

        multiresolution_sparsity_factor (1,1)  double {mustBeNonnegative} = 0.001;

        multiresolution_decomposition_number (1,1) int16 {mustBePositive,mustBeInteger} = 10;

        %
        % Parameter for prior variance selection
        %

        initial_prior_steering_db (1,1) {mustBeA(initial_prior_steering_db,["double","gpuArray"])} = 0

        %
        % tag string for waitbar especially
        %

        tag (1,1) string = ""

        %
        % Checking flag if user has changed the value of noise_cov parameter
        %
        noise_covSetted (1,1) {mustBeNumericOrLogical} = false

    end % properties

    properties (SetObservable)

        %
        % Measurement noise covariace (optional)
        % User can set their own noise covariance matrix through this
        % property.
        %
        
        noise_cov (:,:) {mustBeA(noise_cov,["double","gpuArray"])} = []

        %
        % Checking flag if the inversion computing is running. This
        % prevents the value changes made by computation to be identified
        % as user-made.
        %
        computing_parameters (1,1) {mustBeNumericOrLogical} = false

    end

    methods

        function self = GroupLassoInverter(args)

            %
            % GroupLassoInverter
            %
            % The constructor for this class.
            %

            arguments

                args.beta = 3

                args.theta0 = 1e-10

                args.hyperprior_mode = "Sensitivity weighted"

                args.n_map_iterations = 25

                args.n_L1_iterations = 5

                args.estimation_type = "IAS"

                args.use_multiresolution = false

                args.multiresolution_levels_number = 10;

                args.multiresolution_sparsity_factor = 0.001;

                args.multiresolution_decomposition_number = 10;

                args.data_normalization_method = "Maximum entry"

                args.high_cut_frequency = 9

                args.low_cut_frequency = 7

                args.number_of_frames = 1

                args.sampling_frequency = 1024

                args.signal_to_noise_ratio = 30

                args.time_start = 0

                args.time_window = 1

                args.time_step = 1

                args.tag = ""

                args.initial_prior_steering_db = 0

                args.noise_cov = []

                args.noise_covSetted = false

                args.computing_parameters = false

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

            self.estimation_type = args.estimation_type;

            self.use_multiresolution = false;

            self.beta = args.beta;

            self.theta0 = args.theta0;

            self.hyperprior_mode = args.hyperprior_mode;

            self.n_map_iterations = args.n_map_iterations;

            self.n_L1_iterations = args.n_L1_iterations;

            self.multiresolution_levels_number = args.multiresolution_levels_number;

            self.multiresolution_sparsity_factor = args.multiresolution_sparsity_factor;

            self.multiresolution_decomposition_number = args.multiresolution_decomposition_number;

            self.initial_prior_steering_db = args.initial_prior_steering_db;
            
            self.tag = args.tag;

            self.noise_cov = args.noise_cov;

            self.noise_covSetted = args.noise_covSetted;

            self.computing_parameters = args.computing_parameters;

            % Initialize listeners 
            addlistener(self,'noise_cov','PostSet',@(src,evnt)self.setEventsFlags(src,evnt,self));

        end

        %This function calculates the
        %multiresolution decompositions as it would by pressing the make
        %decomposition button
        function self = make_multires_dec(self)
            arguments
                self (1,1)
            end
            [self.multiresolution_dec, self.multiresolution_ind, self.multiresolution_count] = zef_make_multires_dec(self.number_of_decompositions, self.number_of_multiresolution_levels, self.sparsity_factor);
        end %function
    
        % Declare the initialize and inverse method defined in the files invert and initialize in this same
        % folder.
        self = initialize(self)

        [reconstruction, self] = invert(self)

        function self = terminateComputation(self)
            %If the user has not given their own inversion parameters, we
            %reset the automatically computed parameters because the user 
            %could change the data or model between separate runs.
            SNR_variable = findprop(self,'SNR_variable');
            delete(SNR_variable);
            if not(self.noise_covSetted)
                self.noise_cov = [];
            end
        end

    end % methods

    methods (Static)
        %The function that is woken by listener when the value of theta or
        %noise_cov is changed to something else than empty by hand. 
        % The function set the respective *Setted property value true when 
        % value is changed.
        function setEventsFlags(src,evnt,self) %two first inputs must be there and have these dedicated roles. The third 'self' is an extra variable.
         if not(self.computing_parameters)
             if isempty(self.noise_cov)
                 self.noise_covSetted = false;
             else
                 self.noise_covSetted = true;
             end
         end
        end % function
    end % static methods

end % classdef