classdef (HandleCompatible) CommonInverseParameters < dynamicprops

    %
    % CommonInverseParameters
    %
    % This class holds onto inverse parameters common to all inverse methods.
    %

    properties

        %
        % low_cut_frequency
        %
        % Highpass passband edge frequency (Hz) used for the elliptic
        % filter of order 3.
        %
        low_cut_frequency (1,1) double { mustBeNonnegative } = 7;

        %
        % high_cut_frequency
        %
        % Lowpass passband edge frequency (Hz) used for the elliptic
        % filter of order 3.
        %
        high_cut_frequency (1,1) double { mustBeNonnegative } = 9;

        %
        % data_normalization_method
        %
        % Procedure type of data normalization. In ZI, the measurement data
        % is considered as m x T matrix with m sensors and T time samples.
        % Hence, all sensor outputs at the sample point t correspond to a
        % column within this matrix. With that in mind, the normalization
        % options are:
        % - "Maximum entry" (maximum element of the data matrix)
        % - "Maximum column norm" (maximum of columns' norms)
        % - "Average column norm" (average of column norms)
        % - "None"
        %
        data_normalization_method (1,1) string { mustBeMember( ...
            data_normalization_method, ...
            [ "Maximum entry", "Maximum column norm", "Average column norm", "None" ] ...
        ) } = "Maximum entry";

        %
        % number_of_frames
        %
        % Number of subsequent sampling points taken into account starting
        % from the start_time time point.
        %
        number_of_frames (1,1) double { mustBeInteger, mustBePositive } = 1;

        %
        % sampling_frequency
        %
        % Sampling frequency of the given measurement data.
        %
        sampling_frequency (1,1) double { mustBeReal, mustBePositive } = 1025;

        %
        % time_start
        %
        % Measurement data time point (in seconds) at which the inversion
        % calculation is supposed to begin. Setting sampling_frequency
        % accordingly is advisable.
        %
        time_start (1,1) double { mustBeReal, mustBeNonnegative } = 0;

        %
        % time_window
        %
        % Time interval used in average smoothing of the measurement data.
        %
        time_window (1,1) double { mustBeReal, mustBeNonnegative } = 0;

        %
        % time_step
        %
        % The time interval used as a step size when progressing the
        % measurement data over time. Using 1-over-sampling frequency is
        % advisable to take every data sample point into account.
        %
        time_step (1,1) double { mustBeReal, mustBePositive } = 1;

        %
        % signal_to_noise_ratio
        %
        % Value describes the ratio of pure signal power with respect to
        % the noise power. The value is in decibels (dB) units.
        %
        signal_to_noise_ratio (1,1) double { mustBeReal, mustBePositive } = 30;

        %
        % normalize reconstruction
        %
        % Logical value describing, if the maximum reconstruction magnitude
        % over discrete mesh-based source locations is normalized to one.
        % In the case of time serial data, the reconstruction of each time
        % steps is normalized by the maximum magnitude over the whole time
        % series.
        %
        normalize_reconstruction (1,1) logical = false;

        %
        % GMM
        %
        % Gaussian mixture model structure
        %
        GMM struct = struct;

    end % properties

    properties (Constant)

        %
        % REQUIRED_METHODS
        %
        % This constant property lists the methods that a subclass of this
        % class must contain to be an inverter. This is referenced by the
        % isAnInverter static validator function namespaced under this class.
        %
        % This approach is taken instead of making this class abstract to
        % allow for argument validation in functions that take inverters as
        % arguments. Abstract methods do not allow for function argument
        % validation.
        %
        REQUIRED_METHODS = [ "invert" ]

    end

    methods

        function self = CommonInverseParameters(args)

            %
            % CommonInverseParameters.CommonInverseParameters
            %
            % The constructor of this class.
            %
            % ---------------------  Inputs  ---------------------
            %
            % - args
            %
            %   A set of name–value pairs, identical to the properties of this
            %   class. See the documentation of each property with
            %
            %       >> help CommonInverseParameters.property_name
            %
            %   If a default value is to be used, simply do not pass the value
            %   into this constructor. For completeness, the names of the
            %   properties are listed below:
            %
            %   - low_cut_frequency
            %
            %   - high_cut_frequency
            %
            %   - data_normalization_method
            %
            %   - number_of_frames
            %
            %   - prior_mode
            %
            %   - sampling_frequency
            %
            %   - time_start
            %
            %   - time_window
            %
            %   - time_step
            %
            %   - signal_to_noise_ratio
            %
            %   - inv_amplitude_db
            %
            %   - inv_prior_over_measurement_db
            %
            % ---------------------  Outputs  ---------------------
            %
            % - self
            %
            %   An instance of this type or class.
            %

            arguments

                args.low_cut_frequency = 7;

                args.high_cut_frequency = 9;

                args.data_normalization_method = "Maximum entry";

                args.number_of_frames = 1;

                args.sampling_frequency = 1025;

                args.time_start = 0;

                args.time_window = 0;

                args.time_step = 1;

                args.signal_to_noise_ratio = 30;

                args.normalize_reconstruction = false;

            end % arguments

            fns = string ( fieldnames ( args ) ) ;

            for ii = 1 : numel ( fns )

                self.(fns(ii)) = args.(fns(ii)) ;

            end

        end % function

        function self = withPropertiesFromZef(self, zef)
            % Function to load the inversion computing parameters from the
            % zef structure.
            % Usage: ClassObject.withPropertiesFromZef(zef);

             arguments
                 self (1,1) inverse.CommonInverseParameters
                 zef (1,1) struct
             end
            ValidDataOptions = ...
                [ "Maximum entry", "Maximum column norm", "Average column norm", "None" ];

            self.low_cut_frequency = zef.inv_low_cut_frequency;
            self.high_cut_frequency = zef.inv_high_cut_frequency;
            self.data_normalization_method = ValidDataOptions(zef.normalize_data);
            self.number_of_frames = zef.number_of_frames;
            self.sampling_frequency = zef.inv_sampling_frequency;
            self.time_start = zef.inv_time_1;
            self.time_window = zef.inv_time_2;
            self.time_step = zef.inv_time_3;
            self.signal_to_noise_ratio = zef.inv_snr;
            self.normalize_reconstruction = false;

        end  % withPropertiesFromZef function

        function self = computeGMM(self,args)
            % Function to compute Gaussian mixture model for the given
            % reconstruction
            arguments
                 self (1,1) inverse.CommonInverseParameters
                 args.reconstruction (:,:) {mustBeA(args.reconstruction,["double","gpuArray","cell"])}
                 args.zef (1,1) struct
                 args.number_of_clusters (1,:) int8 = 3
                 args.sought_estimate (1,1) string {mustBeMember(args.sought_estimate,["Location & orientation","Location"])} = "Location & orientation"
                 args.covariance_type (1,1) string {mustBeMember(args.covariance_type,["full","diagonal"])} = "full"
                 args.MaxIter (1,1) int8 = 1000
                 args.reconstruction_threshold (1,1) double = 0.25
                 args.regularization_parameter (1,1) double = 1e-2
                 args.SharedCovariance (1,1) logical = false
                 args.use_selected_parcellations (1,1) logical = false
                 args.amplitude_estimation_type (1,1) string {mustBeMember(args.amplitude_estimation_type,["Point density", "Maximal likelihood", "Maximum a posteriori"])} = "Point density"
                 args.model_selection_criterion (1,1) string {mustBeMember(args.model_selection_criterion,["Given number of components","Bayesian information criterion","L2 density error"])} = "Bayesian information criterion"
                 args.initial_cluster_finding_approach (1,1) string {mustBeMember(args.initial_cluster_finding_approach,["k-means ++","Maximum probability","Maximum component-wise fit"])} = "Maximum component-wise fit"
                 args.number_of_replicates (1,1) int8 = 1
                 args.log_posterior_threshold_dB (1,1) double = 6
                 args.reconstruction_smoothing_std (1,1) double = 0
                 args.mixture_component_probability (1,1) double = 0.95;
                 args.start_frame (:,:) int8 = int8([])
                 args.stop_frame (:,:) int8 = int8([])
            end
            zef = args.zef;
            reconstruction = args.reconstruction;
            args = rmfield(args,'zef');
            args = rmfield(args,'reconstruction');
            argcell = namedargs2cell(args);
            self = plugins.ClassGMM.ClassGMModeling(self,reconstruction,zef,argcell{:});
        end %computeGMM function

        function [self, zef] = computeInversionWithZI(self, zef)
            % Function to automatically update the reconstruction
            % information to the given zef structure.
            [zef, self] = zef_process_inversion(zef,self);
        end

    end % methods

    methods (Static)

        function isAnInverter(inverter_candidate)

            %
            % isAnInverter
            %
            % A static validator method for checking whether the given
            % argument inverter_candidate is a subclass of this class. Throws
            % and exception if this is not the case.
            %

            % This argument validation is here just to enforce exactly one
            % input argument.

            arguments

                inverter_candidate

            end

            % Import this class here to shorten code later.

            import inverse.CommonInverseParameters

            % First check that we have the correct type.

            if ~ isa(inverter_candidate, "CommonInverseParameters")

                eidType = "isAnInverter:notAnInverter";

                msgType = "Input must be a subclass of CommonInverseParameters.";

                throwAsCaller(MException(eidType,msgType))

            end

            % Then check that it has the required methods and properties.

            meta_class = metaclass(inverter_candidate);

            method_list = meta_class.MethodList;

            method_name_cells = arrayfun(@(m) m.Name, method_list, 'UniformOutput', false);

            method_name_list = string(method_name_cells);

            for ind = 1 : numel(CommonInverseParameters.REQUIRED_METHODS)

                required_method = CommonInverseParameters.REQUIRED_METHODS(ind);

                if ~ ismember(required_method, method_name_list)

                    eidType = "isAnInverter:missingMethod";

                    msgType = "The input class does not contain all necessary methods to be an inverter." ...
                        + " These are as follows:" + newline;

                    for mind = 1 : numel(CommonInverseParameters.REQUIRED_METHODS)

                        msgType = msgType + newline + "  - " ...
                            + CommonInverseParameters.REQUIRED_METHODS(mind);

                    end

                    throwAsCaller(MException(eidType, msgType))

                end % if

            end % for

        end % isAnInverter function

        function self = substituteCommonInverseParameters(self,ParameterClassObj)
            % Function to substitute a common set of inverse parameters
            % between inverters or inverter and CommonInverseParameters
            % object. The method automatically rejects the parameters that
            % do not belong to the object where the parameters are
            % substituted.
            % ---------------------  Inputs  ---------------------
            % 1st argument: Class object where the parameters are substituted
            % 2nd argument: Class object from which the parameters are
            % taken.
            arguments
                self (1,1)
                ParameterClassObj (1,1) inverse.CommonInverseParameters
            end
            commonProps = convertCharsToStrings(properties(ParameterClassObj));
            commonProps(strcmp(commonProps,"REQUIRED_METHODS"))=[];
            Props = convertCharsToStrings(properties(self));
            commonProps = intersect(commonProps,Props);
            for ii = 1 : numel (commonProps)
                prop = commonProps(ii);
                self.(prop) = ParameterClassObj.(prop);
            end
        end %substituteCommonInverseParameters function

    end % methods (Static)

end % classdef
