%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
function [shape_param, scale_param, snr_vec] = find_ig_hyperprior( ...
    L, ...
    snr_val, ...
    tail_length_db, ...
    source_space_size, ...
    normalize_data, ...
    eps_val, ...
    delta_val, ...
    balance_snr, ...
    w_param, ...
    balance_param, ...
    use_gpu, ...
    gpu_count ...
)

    %
    % find_ig_hyperprior
    %
    % Forms the inverse-gamma (inv-γ) hyper-prior information needed by
    % inverse methods such as RAMUS.
    %

    arguments

        L (:,:) double

        snr_val (1,1) double { mustBeReal, mustBePositive }

        tail_length_db (1,1) double { mustBeGreaterThanOrEqual(tail_length_db, 1) } = 1

        source_space_size (1,1) double { mustBeInteger, mustBePositive } = size(L,2)

        normalize_data (1,1) string { mustBeMember(normalize_data, ["maximum", "L2"]) } = "maximum"

        eps_val (1,1) double { mustBePositive } = 2e-3

        delta_val (1,1) double = 0.1

        balance_snr (1,1) logical = true

        w_param (1,1) double = 1 / 2

        balance_param (1,1) double = 0

        use_gpu (1,1) logical = true

        gpu_count (1,1) double { mustBeInteger, mustBePositive } = gpuDeviceCount("available")

    end

    if isempty(L)

        snr_vec = snr_val;
        snr_vec_limited = snr_vec;
        source_strength = 1e-2;

    else

        if normalize_data == "maximum"

            source_strength = mean(1./((max(abs(L))').^w_param));

        else

            source_strength = mean(1./(sqrt(sum(L.^2)').^w_param));

        end

        if balance_snr

            theta0 = zef_find_gaussian_prior(snr_val+balance_param);

            std_lhood = 10^(-snr_val/20);

            S_mat = std_lhood^2*eye(size(L,1));

            d_sqrt = sqrt(theta0)*ones(size(L,2),1);

            L_inv = L.*repmat(d_sqrt',size(L,1),1);
            L_inv = d_sqrt.*(L_inv'*(inv(L_inv*L_inv' + S_mat)));

            sloreta_vec = sqrt(max(0,sum(L_inv.*L', 2)));

            L = L./sloreta_vec';

            if normalize_data == "maximum"

                signal_strength = (size(L,2)*(max(abs(L))')./sum(max(abs(L))')).^(w_param);

            else

                signal_strength = (size(L,2).*(sqrt(sum(L.^2))')./sum(sqrt(sum(L.^2))')).^(w_param);

            end

            snr_vec = snr_val + db(signal_strength);

        else

            snr_vec = snr_val;

        end

        snr_vec_limited = max(1,snr_vec);

    end % if

    relative_noise_std = 10.^(-snr_vec_limited/20);

    tail_length = 10.^(tail_length_db/20);

    a = 1*ones(size(relative_noise_std));

    b = 170*ones(size(relative_noise_std));

    if use_gpu == 1 && gpu_count > 0

        relative_noise_std = gpuArray(relative_noise_std);

        a = gpuArray(a);
        b = gpuArray(b);

    end

    for j = 1 : 10

        shape_param_vec = a + (b-a).*[0:delta_val:1];

        p_val_vec = goodness_of_inversion.inverse_gamma_gpu( ...
            relative_noise_std.^2 .* tail_length.^2, ...
            shape_param_vec, ...
            relative_noise_std(:, ones(size(shape_param_vec,2),1)).^2 .* (shape_param_vec - 1) ...
        );

        eps_val_aux = eps_val./(relative_noise_std.^2*tail_length.^2);

        [m_aux,i_aux] = min(abs(p_val_vec(:,2:end) - eps_val_aux), [], 2);

        i_aux = i_aux + 1;
        i_aux = min(size(p_val_vec,2),i_aux);

        b = shape_param_vec((i_aux-1)*size(p_val_vec,1)+[1:size(p_val_vec,1)]');
        a = shape_param_vec((i_aux-2)*size(p_val_vec,1)+[1:size(p_val_vec,1)]');

    end

    shape_param = (a+b)/2;

    scale_param = source_strength.^2 .* relative_noise_std.^2 .* (shape_param - 1) ./ source_space_size;

end % function
