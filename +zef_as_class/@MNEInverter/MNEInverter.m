classdef MNEInverter < zef_as_class.GeneralInverter

    %
    % MNEInverter
    %
    % A class which defines the properties needed by the MNE inversion method,
    % and the method itself.
    %

    properties

        mne_flavour (1,1) string { mustBeMember(mne_flavour, ["MNE", "sLORETA", "dSPM"]) } = "MNE"

        prior_distribution = "None"

    end % properties

    methods

        function self = MNEInverter(args)

            %
            % MNEInverter
            %
            % The constructor for this class.
            %

            arguments

                args.data_normalization_method = "maximum column norm"

                args.high_cut_frequency = 9

                args.inv_amplitude_db = 1

                args.inv_prior_over_measurement_db = 1

                args.low_cut_frequency = 7

                args.number_of_frames = 1

                args.sampling_frequency = 1024

                args.signal_to_noise_ratio = 30

                args.time_start = 0

                args.time_window = 1

                args.time_step = 1

                args.mne_flavour = "MNE"

            end

            % Initialize superclass fields.

            self = self@zef_as_class.GeneralInverter( ...
                "data_normalization_method", args.data_normalization_method, ...
                "high_cut_frequency", args.high_cut_frequency, ...
                "inv_amplitude_db", args.inv_amplitude_db, ...
                "inv_prior_over_measurement_db", args.inv_prior_over_measurement_db, ...
                "low_cut_frequency", args.low_cut_frequency, ...
                "number_of_frames", args.number_of_frames, ...
                "sampling_frequency", args.sampling_frequency, ...
                "signal_to_noise_ratio", args.signal_to_noise_ratio, ...
                "time_start", args.time_start, ...
                "time_window", args.time_window, ...
                "time_step", args.time_step ...
            );

            % Initialize own fields.

            self.mne_flavour = args.mne_flavour;

            self.prior_distribution = "None"

        end

        % Declare the inverse method defined in the file invert, in this same
        % folder.

        reconstruction = invert(self)

    end % methods

end % classdef
