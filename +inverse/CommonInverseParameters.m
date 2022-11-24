classdef CommonInverseParameters

    %
    % CommonInverseParameters
    %
    % This class holds onto inverse parameters common to all inverse methods.
    %

    properties

        %
        % low_cut_frequency
        %
        % TODO: description.
        %
        low_cut_frequency (1,1) double { mustBePositive } = 7;

        %
        % high_cut_frequency
        %
        % TODO: description.
        %
        high_cut_frequency (1,1) double { mustBePositive } = 9;

        %
        % data_normalization_method
        %
        % TODO: description.
        %
        data_normalization_method (1,1) string { mustBeMember( ...
            data_normalization_method, ...
            [ "maximum entry", "maximum column norm", "average column norm", "none" ] ...
        ) } = "maximum entry";

        %
        % number_of_frames
        %
        % TODO: description.
        %
        number_of_frames (1,1) double { mustBeInteger, mustBePositive } = 1;

        %
        % prior_mode
        %
        % TODO: description.
        %
        prior_mode (1,1) string { mustBeMember( ...
            prior_mode, ...
            [ "balanced", "constant" ] ...
        ) } = "constant";

        %
        % sampling_frequency
        %
        % TODO: description.
        %
        sampling_frequency (1,1) double { mustBeReal, mustBePositive } = 1025;

        %
        % time_start
        %
        % TODO: description.
        %
        time_start (1,1) double { mustBeReal, mustBeNonnegative } = 0;

        %
        % time_window
        %
        % TODO: description.
        %
        time_window (1,1) double { mustBeReal, mustBeNonnegative } = 0;

        %
        % time_step
        %
        % TODO: description.
        %
        time_step (1,1) double { mustBeReal, mustBePositive } = 1;

        %
        % signal_to_noise_ratio
        %
        % TODO: description.
        %
        signal_to_noise_ratio (1,1) double { mustBeReal, mustBePositive } = 30;

        %
        % inv_amplitude_db
        %
        % TODO: description.
        %
        inv_amplitude_db (1,1) double = 20;

        %
        % inv_prior_over_measurement_db
        %
        % TODO: description.
        %
        inv_prior_over_measurement_db (1,1) double = 20;

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

                args.data_normalization_method = "maximum entry";

                args.number_of_frames = 1;

                args.prior_mode = "constant";

                args.sampling_frequency = 1025;

                args.time_start = 0;

                args.time_window = 0;

                args.time_step = 1;

                args.signal_to_noise_ratio = 30;

                args.inv_amplitude_db = 20;

                args.inv_prior_over_measurement_db = 20;

            end % arguments

            self.low_cut_frequency = args.low_cut_frequency;

            self.high_cut_frequency = args.high_cut_frequency;

            self.data_normalization_method = args.data_normalization_method;

            self.number_of_frames = args.number_of_frames;

            self.prior_mode = args.prior_mode;

            self.sampling_frequency = args.sampling_frequency;

            self.time_start = args.time_start;

            self.time_window = args.time_window;

            self.time_step = args.time_step;

            self.signal_to_noise_ratio = args.signal_to_noise_ratio;

            self.inv_amplitude_db = args.inv_amplitude_db;

            self.inv_prior_over_measurement_db = args.inv_prior_over_measurement_db;

        end % function

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

        end % function

    end % methods (Static)

end % classdef
