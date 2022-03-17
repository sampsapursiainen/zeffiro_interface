function [z,Var_loc,reconstruction_information] = RAP_MUSIC_iteration
%Based on
%- "Source Localization Using Recursively Applied and Projected (RAP) MUSIC" (1999)
%- "EEG and MEG Source Localization using Recursively Applied (RAP) MUSIC" (1997)
%by John C. Mosher and Richard M. Leahy

h = waitbar(0,['RAP MUSIC.']);
[s_ind_1] = unique(evalin('base','zef.source_interpolation_ind{1}'));
n_interp = length(s_ind_1);
snr_val = evalin('base','zef.inv_snr');
std_lhood = 10^(-snr_val/20);
lambda_L = evalin('base','zef.RAPMUSIC_leadfield_lambda');
sampling_freq = evalin('base','zef.inv_sampling_frequency');
high_pass = evalin('base','zef.inv_low_cut_frequency');
low_pass = evalin('base','zef.inv_high_cut_frequency');
number_of_frames = evalin('base','zef.number_of_frames');
n_dipoles = evalin('base','zef.RAPMUSIC_n_dipoles');
source_direction_mode = evalin('base','zef.source_direction_mode');
source_directions = evalin('base','zef.source_directions');

pm_val = evalin('base','zef.inv_prior_over_measurement_db');
if evalin('base','isfield(zef,''inv_amplitude_db'')');
    amplitude_db = evalin('base','zef.inv_amplitude_db');
else
    amplitude_db = 20;
end
pm_val = pm_val - amplitude_db;

reconstruction_information.tag = 'RAP-MUSIC';
reconstruction_information.inv_time_1 = evalin('base','zef.inv_time_1');
reconstruction_information.inv_time_2 = evalin('base','zef.inv_time_2');
reconstruction_information.inv_time_3 = evalin('base','zef.inv_time_3');
reconstruction_information.sampling_frequency = evalin('base','zef.inv_sampling_frequency');
reconstruction_information.low_pass = evalin('base','zef.inv_high_cut_frequency');
reconstruction_information.high_pass = evalin('base','zef.inv_low_cut_frequency');
reconstruction_information.source_direction_mode = evalin('base','zef.source_direction_mode');
reconstruction_information.source_directions = evalin('base','zef.source_directions');
reconstruction_information.snr_val = evalin('base','zef.inv_snr');
reconstruction_information.number_of_frames = evalin('base','zef.number_of_frames');
reconstruction_information.leadfield_lambda = lambda_L;
reconstruction_information.n_dipoles = n_dipoles;

[L,n_interp, procFile] = zef_processLeadfields(source_direction_mode);

if evalin('base','zef.inv_hyperprior') == 1
[~, theta0] = zef_find_ig_hyperprior(snr_val-pm_val,evalin('base','zef.inv_hyperprior_tail_length_db'),[],size(L,2));
elseif evalin('base','zef.inv_hyperprior') == 2
[~, theta0] = zef_find_g_hyperprior(snr_val-pm_val,evalin('base','zef.inv_hyperprior_tail_length_db'),[],size(L,2));
end

if number_of_frames > 1
z = cell(number_of_frames,1);
Var_loc = cell(number_of_frames,1);
else
number_of_frames = 1;
end

f_data = zef_getFilteredData;

tic;
%------------------ TIME LOOP STARTS HERE ------------------------------
for f_ind = 1 : number_of_frames
time_val = toc;
if f_ind > 1
date_str = datestr(datevec(now+(number_of_frames/(f_ind-1) - 1)*time_val/86400));
end

if ismember(source_direction_mode, [1,2])
z_aux = zeros(size(L,2),1);
Var_aux = zeros(size(L,2),1);
end
if source_direction_mode == 3
z_aux = zeros(3*size(L,2),1);
Var_aux = zeros(3*size(L,2),1);
end
z_vec = ones(size(L,2),1);
Var_vec = ones(size(L,2),1);
f=zef_getTimeStep(f_data, f_ind, true);

S_mat = max(f.^2,[],'all')*(std_lhood^2/theta0)*eye(size(L,1));
if evalin('base','zef.use_gpu') == 1 && gpuDeviceCount > 0
    S_mat = gpuArray(S_mat);
end

if f_ind == 1
waitbar(0,h,['MUSIC. Time step ' int2str(f_ind) ' of ' int2str(number_of_frames) '.']);
end

%---------------CALCULATIONS STARTS HERE----------------------------------
%Data covariance matrix (assuming that this is John Mosher's "sample covariance
%matrix" \hat{R}
if size(f,2) > 1
    C = cov(f');
else
    C = (f-mean(f,1))*(f-mean(f,1))';
end

[Phi_s,D] = eigs(C,n_dipoles);
Phi_s = Phi_s(:,abs(diag(D))>eps);  %"signal subspace estimate"

%determine indices of triplets (ind) and their total amount (nn)
if source_direction_mode == 1  || source_direction_mode == 2
    nn = length(s_ind_1)/3;
    L_ind = round([1:nn;nn+(1:nn);2*nn+(1:nn)])';
elseif source_direction_mode == 3
    nn = length(s_ind_1);
    L_ind = round(transpose(1:nn));
end
    nn = size(L_ind,1);
    %Initial objects
    ind_space = [];     %indices of L_ind (i.e., source position nodes) that are already estimated as true source positions
    orj = [];   % orjentation of estimates as 3*n x 1 -vector
    search_space = 1:nn;    %source position indices where dipoles are searched
    A_mat = [];     %source space gain forwardmodel
    %_ Main loop _
    for d_iter = 1:n_dipoles
        if number_of_frames == 1
            if d_iter > 1
                date_str = datestr(datevec(now+(n_dipoles/(d_iter-1) - 1)*time_val/86400));
            else
                date_str = [];
            end
        end

        s_max = -1; % maximum eigenvalue of subspace correlations
        ind_space(end+1) = nan;
        %go trough every source point from search_space to find the one
        %point that has the maximum "s", i.e., largest maximum singular
        %value of subspace correlation
        for n_iter = 1:length(search_space)
            n = search_space(n_iter);
            [s,u] = zef_subspace_corr([A_mat L(:,L_ind(n,:))],Phi_s,'max');   %See Appendix from "EEG and MEG Source Localization using Recursively Applied (RAP) MUSIC" (1997), J. C. Mosher & R. M. Leahy
            if s > s_max
                s_max = s;
                orj_best = u;
                ind_space(end) = n;
            end
        end
            %orj = [orj,orj_best];   %add the best orjentation to the orjentation vector
            orj = orj_best;
            A_mat = L(:,reshape(L_ind(ind_space,:),[],1)).*reshape(orj,[],1)';    %form the matrix A that is leadfield of found sources times their orjentation
            search_space = setdiff(search_space,ind_space(d_iter)); %extract the found dipole location from searched nodes.

        if f_ind > 1;
         waitbar(f_ind/number_of_frames,h,['Step ' int2str(f_ind) ' of ' int2str(number_of_frames) '. Ready: ' date_str '.' ]);
        elseif number_of_frames == 1
            waitbar(d_iter/n_dipoles,h,['RAP MUSIC iteration ',num2str(d_iter),' of ',num2str(n_dipoles),'. Ready: ' date_str '.']);
        end;
    end

    %forming the reconstruction from the A_mat and orientation
    An_interp = size(A_mat,2)/3;
    %Amplitude leadfield a.k.a gain matrix:
    A_mat = sqrt(A_mat(:,1:An_interp).^2+A_mat(:,(An_interp+1):2*An_interp).^2+A_mat(:,(2*An_interp+1):3*An_interp).^2);
    if evalin('base','zef.use_gpu') == 1 && gpuDeviceCount > 0
        A_mat = gpuArray(A_mat);
    end
    z_amp = A_mat'*((A_mat*A_mat'+S_mat)\f);    %amplitude estimation
    z_vec = zeros(size(L,2),1);
    z_vec_aux = repelem(z_amp,3).*orj;
    z_vec(reshape(L_ind(ind_space,:),[],1)) = z_vec_aux([1:3:end,2:3:end,3:3:end]); %couple the amplitude with the orjentation.
    %Notice that L_ind(ind_space,:) and orj are structurally same, and
    %reshape form order similar with s_ind indexing.

z{f_ind} = z_vec;
end;
z = zef_postProcessInverse(z, procFile);
z = zef_normalizeInverseReconstruction(z);

close(h);
end
