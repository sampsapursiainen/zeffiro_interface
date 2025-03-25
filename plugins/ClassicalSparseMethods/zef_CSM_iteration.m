%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
function [z,reconstruction_information] = zef_CSM_iteration

h = waitbar(0,['CSM MAP iteration.']);
[s_ind_1] = unique(evalin('base','zef.source_interpolation_ind{1}'));
n_interp = length(s_ind_1);
snr_val = evalin('base','zef.inv_snr');
std_lhood = 10^(-snr_val/20);

pm_val = evalin('base','zef.inv_prior_over_measurement_db');
amplitude_db = evalin('base','zef.inv_amplitude_db');
pm_val = pm_val - amplitude_db;

sampling_freq = evalin('base','zef.inv_sampling_frequency');
high_pass = evalin('base','zef.inv_low_cut_frequency');
low_pass = evalin('base','zef.inv_high_cut_frequency');
number_of_frames = evalin('base','zef.number_of_frames');
source_direction_mode = evalin('base','zef.source_direction_mode');
source_directions = evalin('base','zef.source_directions');
method_type = evalin('base','zef.csm_type');

if method_type == 1
    reconstruction_information.tag = 'CSM/dSPM';
elseif method_type == 2
    reconstruction_information.tag = 'CSM/sLORETA';
elseif method_type == 3
    reconstruction_information.tag = 'CSM/sLORETA-3D';
elseif method_type == 4
    reconstruction_information.tag = 'CSM/SBL';
end
reconstruction_information.inv_time_1 = evalin('base','zef.inv_time_1');
reconstruction_information.inv_time_2 = evalin('base','zef.inv_time_2');
reconstruction_information.inv_time_3 = evalin('base','zef.inv_time_3');
reconstruction_information.sampling_freq = evalin('base','zef.inv_sampling_frequency');
reconstruction_information.low_pass = evalin('base','zef.inv_high_cut_frequency');
reconstruction_information.high_pass = evalin('base','zef.inv_low_cut_frequency');
reconstruction_information.source_direction_mode = evalin('base','zef.source_direction_mode');
reconstruction_information.source_directions = evalin('base','zef.source_directions');
reconstruction_information.snr_val = evalin('base','zef.inv_snr');
reconstruction_information.number_of_frames = evalin('base','zef.number_of_frames');

[L,n_interp, procFile] = zef_processLeadfields(source_direction_mode);

z = cell(number_of_frames,1);
f_data = zef_getFilteredData;
size_f = size(f_data,2);
f_data=cell2mat(arrayfun(@(x) zef_getTimeStep(f_data, x), 1:number_of_frames, 'UniformOutput', false));

theta0 = (1-std_lhood^2)*sum(f_data.^2,'all')/sum(L.^2,'all');

if evalin('base','zef.use_gpu') == 1 && gpuDeviceCount > 0
    L = gpuArray(L);
end

%_ Time Serie Loop _
tic;
for f_ind = 1 : number_of_frames
    time_val = toc;
    if f_ind > 1
        date_str = datestr(datevec(now+(number_of_frames/(f_ind-1) - 1)*time_val/86400)); %what does that do?
        waitbar(100,h,['Step ' int2str(f_ind) ' of ' int2str(number_of_frames) '. Ready: ' date_str '.' ]);
    end
    f=f_data(:, f_ind);
    z_vec = nan(size(L,2),1);

    if evalin('base','zef.use_gpu') == 1 && gpuDeviceCount > 0
        f = gpuArray(f);
    end

    if f_ind == 1
        waitbar(0,h,['CSM MAP initialization. Time step ' int2str(f_ind) ' of ' int2str(number_of_frames) '.']);
    end

    %___ Calculations start ___


    if method_type == 1 || method_type == 2 || method_type == 3

        S_mat = (std_lhood^2/theta0)*eye(size(L,1));
        if evalin('base','zef.use_gpu') == 1 && gpuDeviceCount > 0

            S_mat = gpuArray(S_mat);
        end

        if size_f > 1
            f = mean(f,2);
        end

        %__ dSPM __
        %Source covariance
        P = L'/(L*L'+S_mat);
        if method_type == 1
            %d = 1./sqrt(diag(P*S_mat*P'));
            d = 1./sqrt(sum(((P*S_mat).*P),2));
            z_vec = d.*P*f;
        elseif method_type == 2
            %__ sLORETA __
            %d = 1./sqrt(diag(P*L));
            d = 1./sqrt(sum(P.'.*L,1)');
            z_vec = d.*P*f/sqrt(theta0);
        else
            z_vec = P*f;
            if evalin('base','zef.use_gpu') == 1 && gpuDeviceCount > 0
                P = gather(P);
                L = gather(L);
                z_vec = gather(z_vec);
            end

            if source_direction_mode == 2
                r_ind = setdiff(1:n_interp,procFile.s_ind_4);
                surf_ind = procFile.s_ind_4+[0,n_interp,2*n_interp];
                surf_ind=surf_ind(:);
                M = 1./sum(P(surf_ind,:).'.*L(:,surf_ind),1)';
                z_vec(surf_ind) = M.*z_vec(surf_ind);
                for i = 1:length(r_ind)
                    if number_of_frames <= 1 && i > 1
                        date_str = datestr(datevec(now+(n_interp/(i-1) - 1)*time_val/86400)); %what does that do?
                    end
                    ind = r_ind(i)+[0,n_interp,2*n_interp];
                    M = sqrtm(P(ind,:)*L(:,ind));
                    z_vec(ind) = (M\z_vec(ind));
                    if number_of_frames <= 1 && i > 1
                        waitbar(i/n_interp,h,['Step ' int2str(i) ' of ' int2str(n_interp) '. Ready: ' date_str '.' ]);
                    end
                end
                z_vec = z_vec/sqrt(theta0);
            else
                for i = 1:n_interp
                    if number_of_frames <= 1 && i > 1
                        date_str = datestr(datevec(now+(n_interp/(i-1) - 1)*time_val/86400)); %what does that do?
                    end
                    ind = [i,i+n_interp,i+2*n_interp];
                    M = sqrtm(P(ind,:)*L(:,ind));
                    z_vec(ind) = M\z_vec(ind);
                    if number_of_frames <= 1 && i > 1
                        waitbar(i/n_interp,h,['Step ' int2str(i) ' of ' int2str(n_interp) '. Ready: ' date_str '.' ]);
                    end
                end
                z_vec = z_vec/sqrt(theta0);
            end
        end
        if f_ind > 1;
            waitbar(f_ind/number_of_frames,h,['Step ' int2str(f_ind) ' of ' int2str(number_of_frames) '. Ready: ' date_str '.' ]);
        end

    elseif method_type == 4

        S_mat = (std_lhood^2)*eye(size(L,1));
        if evalin('base','zef.use_gpu') == 1 && gpuDeviceCount > 0
            S_mat = gpuArray(S_mat);
        end
        %__ Sparse Bayesian Learning _
        n_iter = evalin('base','zef.csm_n_iter');
        C_data = cov(f');
        if det(C_data) < eps
            C_data = C_data + 0.05*trace(C_data)*eye(size(C_data,1))/size(C_data,1);
        end
        inv_sqrt_C = inv(sqrtm(gather(C_data)));
        gamma = ones(size(L,2),1);
        const = zeros(size(L,2),1);
        if evalin('base','zef.use_gpu') == 1 & gpuDeviceCount > 0
            const = gather(const);
            L = gather(L);
        end

        for i = 1:size(L,2)
            const(i) = 1/(rank(L(:,i)*L(:,i)')*size(f,2));
        end
        if evalin('base','zef.use_gpu') == 1 & gpuDeviceCount > 0
            const = gpuArray(const);
            gamma = gpuArray(gamma);
            L = gpuArray(L);
        end

        for i = 1:n_iter
            if f_ind > 1;
                waitbar(i/n_iter,h,['Step ' int2str(f_ind) ' of ' int2str(number_of_frames) '. Ready: ' date_str '.' ]);
            else
                waitbar(i/n_iter,h,['SBL MAP iteration. Time step ' int2str(f_ind) ' of ' int2str(number_of_frames) '.' ]);
            end;
            f_aux = inv_sqrt_C*f;
            L_aux = inv_sqrt_C*L;
            gamma = const.*gamma.*sum((L_aux'*f_aux).^2,2)./(size(L,2)-gamma.*sum(L_aux.^2,1)');
            C_data = L*(gamma.*L')+S_mat;
            inv_sqrt_C = inv(sqrtm(gather(C_data)));
        end
        if size_f > 1
            f = mean(f,2);
        end
        z_vec = real(gamma.*(L'*(C_data\f)));
    end

    if evalin('base','zef.use_gpu') == 1 && gpuDeviceCount > 0
        z_vec = gather(z_vec);
    end

    %-------------Calculations end---------------
    z{f_ind}=z_vec;
end

z = zef_postProcessInverse(z, procFile);
z = zef_normalizeInverseReconstruction(z);

close(h);
end
