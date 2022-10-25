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

        prior (1,1) string { mustBeMember( ...
            params.prior, ...
            [ "balanced", "constant" ] ...
        ) } = "balanced";

        sampling_frequency (1,1) double { mustBeReal, mustBePositive } = 1025;

        signal_to_noise_ratio (1,1) double { mustBeReal, mustBePositive } = 30;

        time_start (1,1) double { mustBeReal, mustBeNonnegative } = 0;

        time_window (1,1) double { mustBeReal, mustBeNonnegative } = 0;

        time_step (1,1) double { mustBeReal, mustBePositive } = 1;

    end % properties

    methods (Abstract)

        reconstruction = invert(self)

    end

end % classdef
