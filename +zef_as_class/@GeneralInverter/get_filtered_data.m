function [f] = get_filtered_data(zef, use_normalization, normalize_data, data_mode, opts)

% get_filtered_data
%
% Reads the datafrom zef.measurement and applies the filter that are specified
% in zef.inv_low_cut_frequency and zef.inv_low_cut_frequency at a sampling
% frequency of zef.inv_sampling_frequency. f has the same size as the
% measurement.
%

    arguments

        zef (1,1) struct

        use_normalization (1,1) logical = false;

        normalize_data (1,1) string { mustBeMember( ...
            normalize_data, ...
            [ "maximum entry", "maximum column norm", "average column norm", "none" ] ...
        ) } = "maximum entry";

        data_mode (1,1) string { mustBeMember( data_mode, ["raw", "filtered temporal"] ) } = "raw";

        opts.low_cut_frequency (1,1) double { mustBePositive } = 7;

        opts.high_cut_frequency (1,1) double { mustBePositive } = 9;

        opts.sampling_frequency (1,1) double { mustBePositive } = 20000;

    end

    f = zef.measurements;

    if data_mode == "raw"

        return

    end

    high_pass = opts.low_cut_frequency;

    low_pass = opts.high_cut_frequency;

    sampling_freq = opts.sampling_frequency;

    if use_normalization

        switch normalize_data

            case "maximum entry"
                data_norm = max(abs(f(:)));
            case "maximum column norm"
                data_norm = max(sqrt(sum(abs(f).^2)));
            case "average column norm"
                data_norm = sum(sqrt(sum(abs(f).^2)))/size(f,2);
            otherwise
                data_norm = 1;
        end

        f = f / data_norm;

    end

    filter_order = 3;

    if size(f,2) > 1 && low_pass > 0

        [lp_f_1,lp_f_2] = ellip(filter_order,3,80,low_pass/(sampling_freq/2));

        f = filter(lp_f_1,lp_f_2,f')';

    end

    if size(f,2) > 1 && high_pass > 0

        [hp_f_1,hp_f_2] = ellip(filter_order,3,80,high_pass/(sampling_freq/2),'high');

        f = filter(hp_f_1,hp_f_2,f')';

    end

end % function
