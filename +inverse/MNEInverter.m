classdef MNEInverter < inverse.CommonInverseParameters

    %
    % MNEInverter < CommonInverseParameters
    %
    % An inverter whose invert-method relies on the Minimum Norm Estimate
    % algorithm or one of its variants.
    %

    properties

        %
        % mne_flavour
        %
        % The variant of the MNE algorithm used by this solver. One of "MNE",
        % "sLORETA" or "dSPM".
        %
        mne_flavour (1,1) string { mustBeMember(mne_flavour, ["MNE", "sLORETA", "dSPM"]) } = "MNE"

    end % properties

    methods

        function self = MNEInverter(args)

            %
            % MNEInverter.MNEInverter
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
            %       >> help MNEInverter.property_name
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
            %   - prior
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
            %   - mne_flavour
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

                args.prior = "balanced";

                args.sampling_frequency = 1025;

                args.time_start = 0;

                args.time_window = 0;

                args.time_step = 1;

                args.signal_to_noise_ratio = 30;

                args.inv_amplitude_db = 20;

                args.inv_prior_over_measurement_db = 20;

                args.mne_flavour = "MNE"

            end % arguments

            % Instantiate superclass parameters.

            self = self@inverse.CommonInverseParameters( ...
                "low_cut_frequency" ,args.low_cut_frequency, ...
                "high_cut_frequency", args.high_cut_frequency, ...
                "data_normalization_method", args.data_normalization_method, ...
                "number_of_frames", args.number_of_frames, ...
                "prior", args.prior, ...
                "sampling_frequency", args.sampling_frequency, ...
                "time_start", args.time_start, ...
                "time_window", args.time_window, ...
                "time_step", args.time_step, ...
                "signal_to_noise_ratio", args.signal_to_noise_ratio, ...
                "inv_amplitude_db", args.inv_amplitude_db, ...
                "inv_prior_over_measurement_db", args.inv_prior_over_measurement_db ...
            );

            % Then initilize own fields.

            self.mne_flavour = args.mne_flavour;

        end % function

        function [reconstruction, resolution_matrix] = invert(self, L, source_directions)

            %
            % MNEInverter.invert
            %
            % The inversion method of MNEInverter. Forms a minimum norm
            % estimate based on the given inputs.
            %
            % Inputs:
            %
            % - self
            %
            %   An intance of this inverter type.
            %
            % - L
            %
            %   A lead field matrix that will be used to create a resolution
            %   matrix.
            %
            % - source_directions
            %
            %   An M × 3 matrix of the xyz-directions of synthetic sources.
            %
            % TODO: more input arguments needed?
            %

            arguments

                self (1,1) inversion.MNEInverter

                L (:,:) double

                source_directions (:,3) double

            end

            % TODO: implementation

        end % function

    end % methods

end % classdef
