function reconstruction = invert(self, measurements, mne_type, params, opts)

    %
    % invert (MNE)
    %
    % A function which performs a minimum norm estimate (MNE) of type MNE,
    % sLORETA or dSPM on a given lead field.
    %
    % Input:
    %
    % - self
    %
    %   An instance of the core struct self of Zeffiro Interface.
    %
    % - mne_type
    %
    %   One of "MNE", "sLORETA" or "dSPM". Capitalization matters.
    %
    % - params
    %
    %   The set of parameters related to MNE as name–value pairs. They are as
    %   follows:
    %
    %   - TODO
    %
    % - opts
    %
    %   Additional options like whether to use GPU or not as name–value pairs.
    %
    % Output:
    %
    % - reconstruction
    %
    %   The MNE reconstruction or a set of source directions.
    %

    arguments

        self (1,1) zef_as_class.MNEInverter

        measurements (:,:) double

        mne_type (1,1) string { mustBeMember(mne_type, ["MNE", "sLORETA", "dSPM"]) }

        params.low_cut_frequency (1,1) double { mustBePositive } = 7;

        params.high_cut_frequency (1,1) double { mustBePositive } = 9;

        params.normalize_data (1,1) string { mustBeMember( ...
            params.normalize_data, ...
            [ "maximum entry", "maximum column norm", "average column norm", "none" ] ...
        ) } = "maximum entry";

        params.number_of_frames (1,1) double { mustBeInteger, mustBePositive } = 1;

        params.prior (1,1) string { mustBeMember( ...
            params.prior, ...
            [ "balanced", "constant" ] ...
        ) } = "balanced";

        params.sampling_frequency (1,1) double { mustBeReal, mustBePositive } = 1025;

        params.time_start (1,1) double { mustBeReal, mustBeNonnegative } = 0;

        params.time_window (1,1) double { mustBeReal, mustBeNonnegative } = 0;

        params.time_step (1,1) double { mustBeReal, mustBePositive } = 1;

        params.signal_to_noise_ratio (1,1) double { mustBeReal, mustBePositive } = 30;

        params.inv_amplitude_db (1,1) double = 20;

        params.inv_prior_over_measurement_db (1,1) double = 20;

        opts.use_gpu (1,1) logical = false

        opts.gpu_count (1,1) double { mustBeInteger, mustBeNonnegative } = gpuDeviceCount("available")

    end

    h = zef_waitbar(0,['MNE Reconstruction.']);

    cleanup_fn = @(graphics) close(graphics);

    cleanup_obj = onCleanup(@() cleanup_fn(h));

    [procFile.s_ind_1] = self.source_interpolation_ind{1};

    n_interp = length(procFile.s_ind_1);

    pm_val = params.inv_prior_over_measurement_db;
    amplitude_db = params.inv_amplitude_db;
    pm_val = pm_val - amplitude_db;

    snr_val = params.signal_to_noise_ratio;
    mne_type = mne_type;
    mne_prior = params.prior;
    std_lhood = 10^(-snr_val/20);

    self.inv_sampling_frequency = params.sampling_frequency;
    self.inv_high_pass = params.low_cut_frequency;
    self.inv_low_pass = params.high_cut_frequency;
    self.number_of_frames = params.number_of_frames;
    self.inv_time_1 = params.time_start;
    self.inv_time_2 = params.time_window;
    self.inv_time_3 = params.time_step;

    source_direction_mode = self.source_direction_mode;

    source_directions = self.source_directions;

    [L,n_interp, procFile] = zef_as_class.GeneralInverter.process_lead_fields(self);

    source_count = n_interp;

    if params.prior == "balanced"

        balance_spatially = 1;

    else

        balance_spatially = 0;

    end

    [theta0] = zef_as_class.GeneralInverter.find_gaussian_prior( ...
        snr_val-pm_val, ...
        L, ...
        "source_space_size", size(L,2), ...
        "normalization_type", params.normalize_data, ...
        "balance_snr", balance_spatially ...
    );

    if opts.use_gpu == 1 & opts.gpu_count > 0

        L = gpuArray(L);

    end

    S_mat = std_lhood^2*eye(size(L,1));

    if opts.use_gpu == 1 & opts.gpu_count > 0

        S_mat = gpuArray(S_mat);

    end

    if params.number_of_frames > 1

        reconstruction = cell(params.number_of_frames,1);

    else

        self.number_of_frames = 1;

    end


    [f_data] = zef_as_class.GeneralInverter.get_filtered_data( ...
        measurements, ...
        false, ...
        "low_cut_frequency", params.low_cut_frequency, ...
        "high_cut_frequency", params.high_cut_frequency ...
    );

    tic;

    for f_ind = 1 : self.number_of_frames

        time_val = toc;

        if f_ind > 1

            date_str = datestr(datevec(now+(self.number_of_frames/(f_ind-1) - 1)*time_val/86400));

        end

        if ismember(source_direction_mode, [1,2])

            z_aux = zeros(size(L,2),1);

        end

        if source_direction_mode == 3

            z_aux = zeros(3*size(L,2),1);

        end

        z_vec = ones(size(L,2),1);

        [f] = zef_as_class.GeneralInverter.get_time_step( ...
            f_data, ...
            f_ind, ...
            params.time_start, ...
            params.time_window, ...
            params.time_step, ...
            params.sampling_frequency ...
        );

        if f_ind == 1

            zef_waitbar(0,h,['MNE reconstruction. Time step ' int2str(f_ind) ' of ' int2str(self.number_of_frames) '.']);

        end

        if opts.use_gpu == 1 & opts.gpu_count > 0

            f = gpuArray(f);

        end

        if f_ind > 1

            zef_waitbar(f_ind/self.number_of_frames,h,['Step ' int2str(f_ind) ' of ' int2str(self.number_of_frames) '. Ready: ' date_str '.' ]);

        else

            zef_waitbar(f_ind/self.number_of_frames,h,['MNE reconstruction. Time step ' int2str(f_ind) ' of ' int2str(self.number_of_frames) '.' ]);

        end

        m_max = sqrt(size(L,2));
        u = zeros(length(z_vec),1);
        z_vec = zeros(length(z_vec),1);

        if length(theta0)==1

            d_sqrt = sqrt(theta0)*ones(size(z_vec));

        else

            d_sqrt = sqrt(theta0);

        end

        if opts.use_gpu == 1 & opts.gpu_count > 0

            d_sqrt = gpuArray(d_sqrt);

        end

        L_inv = L.*repmat(d_sqrt',size(L,1),1);
        L_inv = d_sqrt.*(L_inv'*(inv(L_inv*L_inv' + S_mat)));

        if mne_type == "dSPM"

            aux_vec = sum(L_inv.^2, 2);
            aux_vec = sqrt(aux_vec);
            L_inv = L_inv./aux_vec(:,ones(size(L_inv,2),1));

        elseif mne_type == "sLORETA"

            aux_vec = sqrt(sum(L_inv.*L', 2));
            L_inv = L_inv./aux_vec(:,ones(size(L_inv,2),1));

        end

        z_vec = L_inv * f;

        if opts.use_gpu == 1 & opts.gpu_count > 0

            z_vec = gather(z_vec);

        end

        z_inverse{f_ind} = z_vec;

    end % for

    reconstruction = zef_as_class.GeneralInverter.postprocess_reconstruction(z_inverse, procFile);

end % function
