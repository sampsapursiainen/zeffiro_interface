function [z, info] = zef_find_mne_reconstruction(zef,data_mode)

if nargin < 2
    data_mode = 'filtered';
end

inverse_gamma_ind = [1:4];
gamma_ind = [5:10];
h = zef_waitbar(0,1,['MNE Reconstruction.']);
[procFile.s_ind_1] = unique(eval('zef.source_interpolation_ind{1}'));
n_interp = length(procFile.s_ind_1);

pm_val = eval('zef.inv_prior_over_measurement_db');
amplitude_db = eval('zef.inv_amplitude_db');
pm_val = pm_val - amplitude_db;

snr_val = eval('zef.inv_snr');
mne_type = eval('zef.mne_type');
mne_prior = eval('zef.mne_prior');
mne_exponent = 0.7;                            %EXPONENT PARAMETER HERE!, JL
std_lhood = 10^(-snr_val/20);

zef.inv_sampling_frequency = zef.mne_sampling_frequency;
zef.inv_high_pass = zef.mne_low_cut_frequency;
zef.inv_low_pass = zef.mne_high_cut_frequency;
zef.number_of_frames = zef.mne_number_of_frames;
zef.inv_time_1 = zef.mne_time_1;
zef.inv_time_2 = zef.mne_time_2;
zef.inv_time_3 = zef.mne_time_3;

source_direction_mode = eval('zef.source_direction_mode');
source_directions = eval('zef.source_directions');

info=[];
info.tag='mne_type';
info.type='mne_type';
info.std_lhood=std_lhood;

info.snr_val = eval('zef.inv_snr');
info.mne_type = eval('zef.mne_type');
info.mne_prior = eval('zef.mne_prior');
info.sampling_freq = eval('zef.mne_sampling_frequency');
info.high_pass = eval('zef.mne_low_cut_frequency');
info.low_pass = eval('zef.mne_high_cut_frequency');
info.number_of_frames = eval('zef.mne_number_of_frames');
info.time_step = eval('zef.mne_time_3');
info.source_direction_mode = eval('zef.source_direction_mode');
info.source_directions = eval('zef.source_directions');

[L,n_interp, procFile] = zef_processLeadfields(zef);

source_count = n_interp;
if eval('zef.mne_normalize_data')==1;
    normalize_data = 'maximum';
else
    normalize_data = 'average';
end

if mne_prior == 1
    balance_spatially = 1;
else
    balance_spatially = 0;
end

[theta0] = zef_find_gaussian_prior(snr_val-pm_val,L,size(L,2),eval('zef.mne_normalize_data'),balance_spatially);

if eval('zef.use_gpu') == 1 & eval('zef.gpu_count') > 0
    L = gpuArray(L);
end

S_mat = std_lhood^2*eye(size(L,1));
if eval('zef.use_gpu') == 1 & eval('zef.gpu_count') > 0
    S_mat = gpuArray(S_mat);
end

if zef.number_of_frames > 1
    z = cell(zef.number_of_frames,1);
else
    zef.number_of_frames = 1;
end

[f_data] = zef_getFilteredData(zef);

tic;
for f_ind = 1 : zef.number_of_frames
    time_val = toc;
    if f_ind > 1;
        date_str = datestr(datevec(now+(zef.number_of_frames/(f_ind-1) - 1)*time_val/86400));
    end;

    if ismember(source_direction_mode, [1,2])
        z_aux = zeros(size(L,2),1);
    end
    if source_direction_mode == 3
        z_aux = zeros(3*size(L,2),1);
    end
    z_vec = ones(size(L,2),1);

    %aux_norm = (sum(L.^2))';
    %aux_norm = aux_norm./max(aux_norm(:));
    %theta = theta0*aux_norm;


    [f] = zef_getTimeStep(f_data, f_ind, zef);


    if f_ind == 1
        zef_waitbar(0,1,h,['MNE reconstruction. Time step ' int2str(f_ind) ' of ' int2str(zef.number_of_frames) '.']);
    end

    if eval('zef.use_gpu') == 1 & eval('zef.gpu_count') > 0
        f = gpuArray(f);
    end

    if f_ind > 1;
        zef_waitbar(f_ind,zef.number_of_frames,h,['Step ' int2str(f_ind) ' of ' int2str(zef.number_of_frames) '. Ready: ' date_str '.' ]);
    else
        zef_waitbar(f_ind,zef.number_of_frames,h,['MNE reconstruction. Time step ' int2str(f_ind) ' of ' int2str(zef.number_of_frames) '.' ]);
    end;
    m_max = sqrt(size(L,2));
    u = zeros(length(z_vec),1);
    z_vec = zeros(length(z_vec),1);
    if length(theta0)==1
        d_sqrt = sqrt(theta0)*ones(size(z_vec));
    else
        d_sqrt = sqrt(theta0);
    end

    % wMNE as the weighting is done in regularization (source prior)
    if isequal(mne_type,4)
        aux_vec = repelem(sum(reshape(sum(L.^2,1),n_interp,[]),2),3);
        d_sqrt = d_sqrt./(aux_vec.^(0.5*mne_exponent));
    end
    
    
    if eval('zef.use_gpu') == 1 & eval('zef.gpu_count') > 0
        d_sqrt = gpuArray(d_sqrt);
    end
    L_inv = L.*repmat(d_sqrt',size(L,1),1);
    L_inv = d_sqrt.*(L_inv'*(inv(L_inv*L_inv' + S_mat)));

    if isequal(mne_type,2)
        % dSPM
        aux_vec = sum(L_inv.^2, 2);
        aux_vec = sqrt(aux_vec);
        L_inv = L_inv./aux_vec;

    elseif isequal(mne_type, 3)
        %'sLORETA'

        aux_vec = sqrt(sum(L_inv.*L', 2));
        L_inv = L_inv./aux_vec;
        
    end

    z_vec = L_inv * f;

    if eval('zef.use_gpu') == 1 & eval('zef.gpu_count') > 0
        z_vec = gather(z_vec);
    end

    z_inverse{f_ind} = z_vec;

end

[z] = zef_postProcessInverse(z_inverse, procFile);
z = zef_normalizeInverseReconstruction(z);


close(h);
end
