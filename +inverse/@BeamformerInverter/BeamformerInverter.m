classdef BeamformerInverter < inverse.CommonInverseParameters & handle

    %
    % BeamformerInverter
    %
    % A class which defines the properties needed for different types of
    % beamforming, and the method itself.
    %

    properties

        %
        %The inverse algorithm used. The options are currently: 
        % - Linearly constrained minimum variance (LCMV) beamformer
        % - Unit noise gain (UNG) beamformer
        % - Unit-gain constrained beamformer
        % The last option is essentially UNG but beamformer-optimal, i.e.,
        % maximal-signal-producing orientation is calculated first.
        %
        method_type (1,1) string { mustBeMember(method_type, ["Linearly constrained minimum variance (LCMV) beamformer", "Unit noise gain (UNG) beamformer", "Unit-gain constrained beamformer"]) } = "Linearly constrained minimum variance (LCMV) beamformer"

        %
        %The error covariance regularization parameter
        %
        cov_reg_parameter (1,1) double {mustBeNonnegative} = 0.05

        %
        %The lead field regularization parameter
        %
        leadfield_reg_parameter (1,1) double {mustBeNonnegative} = 0.001

        %
        %The leadfield regularization procedure
        %
        leadfield_reg_type (1,1) string { mustBeMember(leadfield_reg_type, ["Basic", "Pseudoinverse"]) } = "Basic"
       
        %
        %Lead field normalization strategy
        %
        leadfield_normalization (1,1) string { mustBeMember(leadfield_normalization, ["None", "Matrix norm", "Column norm", "Row norm"]) } = "None"

        %
        % Property to check if user has changed the error covariance by
        % hand
        %
        error_covSetted (1,1) {mustBeNumericOrLogical} = false

        %
        % Support variable to ensure that only user changed of error_cov
        % causes action.
        %
        computing_parameters (1,1) {mustBeNumericOrLogical} = false

    end % properties
    properties (SetObservable)
         
        %
        %The data error covariance matrix (optional)
        %
        error_cov = []

    end %SetObservable properties

    methods

        function self = BeamformerInverter(args)

            %
            % BeamformerInverter
            %
            % The constructor for this class.
            %
            arguments

                args.method_type = "Linearly constrained minimum variance (LCMV) beamformer"

                args.cov_reg_parameter = 0.05

                args.leadfield_reg_parameter = 0.001

                args.reg_type = "Basic"

                args.error_cov = []

                args.error_covSetted = false

                args.computing_parameters = false

                args.leadfield_normalization = "None"

                args.data_normalization_method = "Maximum entry"

                args.high_cut_frequency = 9

                args.low_cut_frequency = 7

                args.number_of_frames = 1

                args.sampling_frequency = 1024

                args.time_start = 0

                args.time_window = 0

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
                "time_step", args.time_step ...
            );

            % Initialize own fields.

            self.method_type = args.method_type;

            self.leadfield_reg_type = args.reg_type;

            self.cov_reg_parameter = args.cov_reg_parameter;

            self.leadfield_reg_parameter = args.leadfield_reg_parameter;

            self.leadfield_normalization = args.leadfield_normalization;

            self.error_cov = args.error_cov;

            self.error_covSetted = args.error_covSetted;

            self.computing_parameters = args.computing_parameters;

            %Set listener for error_cov
            addlistener(self,'error_cov','PostSet',@(src,evnt)self.setEventsFlags(src,evnt,self));

        end

        % Declare the initialize and inverse method defined in the files invert and initialize in this same
        % folder.

        self = initialize(self)

        [reconstruction, self] = invert(self, f, L, procFile, source_direction_mode)

        % Function that ZI runs after all inversions are done for each
        % desired time steps. With this function, one can reset the
        % variables and properties that has been changed during the
        % computing process

        function self = terminateComputation(self)
            %If the user has not given their own inversion parameters, we
            %reset the automatically computed parameters because the user 
            %could change the data or model between separate runs.
            if not(self.error_covSetted)
                self.error_cov = [];
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
               if isempty(self.error_cov)
                   self.error_covSetted = false;
               else
                   self.error_covSetted = true;
               end
         end
        end % function
    end % static methods

end % classdef
