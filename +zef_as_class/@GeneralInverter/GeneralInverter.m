classdef GeneralInverter

    %
    % GeneralInverter
    %
    % A superclass for different inverters, classes that implement specific
    % inversion methods. If you are adding an inverse method to Zeffiro
    % Interface, please write a new class and inherit from this one to gain
    % access to the properties and methods defined within.
    %
    % TODO: maybe make this class abstract to force subclasses into
    % initializing the properties themselves and defining certain methods?
    %
    % Public interface
    % ----------------
    %
    % TODO
    %

    % These properties can be read by anyone, but only modified directly by
    % the subclasses of this class.

    properties (GetAccess = public, SetAccess = protected)

        data_normalization_method (1,1) string { mustBeMember( ...
            data_normalization_method, ...
            [ "maximum entry", "maximum column norm", "average column norm", "none" ] ...
        ) } = "maximum entry";

        high_cut_frequency (1,1) double { mustBePositive } = 9;

        inv_amplitude_db (1,1) double = 20;

        inv_prior_over_measurement_db (1,1) double = 20;

        low_cut_frequency (1,1) double { mustBePositive } = 7;

        number_of_frames (1,1) double { mustBeInteger, mustBePositive } = 1;

        sampling_frequency (1,1) double { mustBeReal, mustBePositive } = 1025;

        signal_to_noise_ratio (1,1) double { mustBeReal, mustBePositive } = 30;

        time_start (1,1) double { mustBeReal, mustBeNonnegative } = 0;

        time_window (1,1) double { mustBeReal, mustBeNonnegative } = 0;

        time_step (1,1) double { mustBeReal, mustBePositive } = 1;

    end % properties

    properties (Abstract)

        % This defines the type of prior distribution used in case of
        % distributed inverse methods. Could be "gamma", "inverse gamma" or
        % "gaussian", for example. If an inverter does not need a prior
        % distribution, this can be set as anything, but preferrably as
        % something like "None".

        prior_distribution (1,1) string

    end % properties (Abstract)

    methods

        function self = GeneralInverter(args)

            %
            % GeneralInverter
            %
            % The constructor for this class.
            %

            % Argument validation is not needed here, as the class itself
            % enforces what its fields are allowed to contain. We simply list
            % the possible inputs as name–value arguments here.

            arguments

                args.data_normalization_method

                args.high_cut_frequency

                args.inv_amplitude_db

                args.inv_prior_over_measurement_db

                args.low_cut_frequency

                args.number_of_frames

                args.sampling_frequency

                args.signal_to_noise_ratio

                args.time_start

                args.time_window

                args.time_step

            end

            self.data_normalization_method     = args.data_normalization_method;

            self.high_cut_frequency            = args.high_cut_frequency;

            self.inv_amplitude_db              = args.inv_amplitude_db;

            self.inv_prior_over_measurement_db = args.inv_prior_over_measurement_db;

            self.low_cut_frequency             = args.low_cut_frequency;

            self.number_of_frames              = args.number_of_frames;

            self.sampling_frequency            = args.sampling_frequency;

            self.signal_to_noise_ratio         = args.signal_to_noise_ratio;

            self.time_start                    = args.time_start;

            self.time_window                   = args.time_window;

            self.time_step                     = args.time_step;

        end

    end % methods

    % NOTE: this might not work if the class itself is not defined as
    % abstract.

    methods (Abstract)

        reconstruction = invert(self)

    end % methods (Abstract)

    methods (Static)

        [f,t] = get_time_step()

    end % methods (Static)

end % classdef
