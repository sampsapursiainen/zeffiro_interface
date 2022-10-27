%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
function [scale_param, snr_vec] = find_gaussian_prior(snr_val, L, opts)

    % find_gaussian_prior
    %
    % Inputs:
    %
    % Outputs:

    arguments

        snr_val (:,1) double

        L (:,:) double

        opts.source_space_size (1,1) double { mustBeInteger, mustBePositive } = 1;

        opts.normalization_type (1,1) string { mustBeMember( ...
            opts.normalization_type, ...
            ["maximum entry", "average"] ...
        ) } = "maximum entry";

        opts.balance_snr (1,1) logical = true;

        opts.w_param (1,1) double = 0.5;

        opts.w_param_modifier (1,1) double = 0;

    end

    w_param = opts.w_param;

    if opts.balance_snr

        w_param = w_param - 0.05*(opts.w_param_modifier-1);

    end

    if isempty(L)

        snr_vec = snr_val;

        snr_vec_limited = snr_vec;

        source_strength = 1e-2;

    else

        if isequal(opts.normalization_type, "maximum entry")

            source_strength = mean(1./((max(abs(L))') .^ w_param));

        else

            source_strength = mean(1./(sqrt(sum(L.^2)') .^ w_param));

        end

        if opts.balance_snr

            if isequal(opts.normalization_type, "maximum entry")
                signal_strength = (size(L,2)*(max(abs(L))')./sum(max(abs(L))')).^(w_param);
            else
                signal_strength = (size(L,2).*(sqrt(sum(L.^2))')./sum(sqrt(sum(L.^2))')).^(w_param);
            end

            snr_vec = snr_val + db(signal_strength);

        else

            snr_vec = snr_val;

        end

        snr_vec_limited = max(1,snr_vec);

    end

    relative_noise_std = 10.^(-snr_vec_limited/20);

    scale_param = source_strength.^2 .* relative_noise_std.^2 ./ (opts.source_space_size);

end % function
