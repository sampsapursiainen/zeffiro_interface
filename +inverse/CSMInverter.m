classdef CSMInverter < inverse.CommonInverseParameters

    %
    % CSMInverter
    %
    % A class which defines the properties needed by the MNE inversion method,
    % and the method itself.
    %

    properties

        %
        %The inverse algorithm used. The options are: dSPM, sLORETA,
        %sLORETA's 3D implementation and Sparse Bayesian learning
        %
        method_type (1,1) string { mustBeMember(method_type, ["dSPM", "sLORETA", "sLORETA 3D", "SBL"]) } = "dSPM"

    end % properties

    methods

        function self = CSMInverter(args)

            %
            % CSMInverter
            %
            % The constructor for this class.
            %

            arguments

                args.method_type = "dSPM"

                args.data_normalization_method = "maximum entry"

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
                "signal_to_noise_ratio", args.signal_to_noise_ratio, ...
                "inv_amplitude_db", args.inv_amplitude_db, ...
                "inv_prior_over_measurement_db", args.inv_prior_over_measurement_db ...
            );

            % Initialize own fields.

            self.method_type = args.method_type;

        end

        % Declare the inverse method defined in the file invert, in this same
        % folder.

        reconstruction = invert(self)

    end % methods

end % classdef