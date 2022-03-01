function [z,Var_loc,reconstruction_information] = zef_beamformer

h = waitbar(0,['Beamformer.']);
[procFile.s_ind_1] = unique(evalin('base','zef.source_interpolation_ind{1}'));
n_interp = length(procFile.s_ind_1);
snr_val = evalin('base','zef.inv_snr');
std_lhood = 10^(-snr_val/20);
lambda_cov = evalin('base','zef.inv_cov_lambda');
lambda_L = evalin('base','zef.inv_leadfield_lambda');
sampling_freq = evalin('base','zef.inv_sampling_frequency');
high_pass = evalin('base','zef.inv_low_cut_frequency');
low_pass = evalin('base','zef.inv_high_cut_frequency');
number_of_frames = evalin('base','zef.number_of_frames');
time_step = evalin('base','zef.inv_time_3');
source_direction_mode = evalin('base','zef.source_direction_mode');
source_directions = evalin('base','zef.source_directions');
method_type = evalin('base','zef.bf_type');

switch method_type
    case 1
        reconstruction_information.tag = 'Beamformer/LCMV';
    case 2
        reconstruction_information.tag = 'Beamformer/UNG';
    case 3
        reconstruction_information.tag = 'Beamformer/UG';
    case 4
        reconstruction_information.tag = 'Beamformer/UNGsc';
end
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

[L,n_interp, procFile] = zef_processLeadfields(source_direction_mode);

L_aux = L;
S_mat = std_lhood^2*eye(size(L,1));

if number_of_frames > 1
z = cell(number_of_frames,1);
Var_loc = cell(number_of_frames,1);
else
number_of_frames = 1;
end

f_data = zef_getFilteredData;

  if evalin('base','zef.cov_type') == 1
    C = (f_data-mean(f_data,2))*(f_data-mean(f_data,2))'/size(f_data,2);
    C = C+lambda_cov*trace(C)*eye(size(C))/size(f_data,1);
elseif evalin('base','zef.cov_type') == 2
 C = (f_data-mean(f_data,2))*(f_data-mean(f_data,2))'/size(f_data,2);
    C = C + lambda_cov*eye(size(C));
end

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
size_f = size(f,2);

if evalin('base','zef.cov_type') == 3
    if size_f > 1
        C = (f-mean(f,2))*(f-mean(f,2))'/size(f,2);
    else
        C = (f-mean(f,1))*(f-mean(f,1))';
    end
    C = C+lambda_cov*trace(C)*eye(size(C))/size(f,1);
elseif evalin('base','zef.cov_type') == 4
    if size_f > 1
        C = (f-mean(f,2))*(f-mean(f,2))'/size(f,2);
    else
        C = (f-mean(f,1))*(f-mean(f,1))';
    end
    C = C + lambda_cov*eye(size(C));
end

if f_ind == 1
waitbar(0,h,['Beamformer. Time step ' int2str(f_ind) ' of ' int2str(number_of_frames) '.']);
end

%---------------CALCULATIONS STARTS HERE----------------------------------
%Data covariance matrix and its regularization

if method_type == 1
   %__ LCMV Beamformer __

    %determine indices of triplets (ind) and their total amount (nn)
    if source_direction_mode == 1  || source_direction_mode == 2
        nn = length(procFile.s_ind_1)/3;
        %L_ind = [procFile.s_ind_1(1:nn),procFile.s_ind_1(nn+(1:nn)),procFile.s_ind_1(2*nn+(1:nn))];
        L_ind = [1:nn;nn+(1:nn);2*nn+(1:nn)]';
    elseif source_direction_mode == 3
        nn = length(procFile.s_ind_1);
        L_ind = transpose(1:nn);
    end

    nn = size(L_ind,1);
    update_waiting_bar = floor(0.1*(nn-2));

    f = sqrtm(C)\f;
    L_aux2 = sqrtm(C)\L;

    for n_iter = 1:nn
        %Date string if one time point
        if number_of_frames == 1 && n_iter > 1
            time_val = toc;
            date_str = datestr(datevec(now+(nn/(n_iter-1) - 1)*time_val/86400));
        end

        %Normalized directions are calculated via scalar beamformer
        if source_direction_mode == 2
            if ismember(L_ind(n_iter,1),procFile.s_ind_4)
                L_aux = L_aux2(:,L_ind(n_iter,1));
            else
                %Leadfield normalizations
                if strcmp(evalin('base','zef.beamformer.normalize_leadfield.Value'),'1')
                    %Leadfield normalization suggested by
                    %- B.D. Van Veen et al. "Localization of brain electrical activity via linearly constrained minimum variance spatial filtering",
                    %IEEE Trans. Biomed. Eng., vol. 44, pp. 867–880, Sept. 1997.
                    %- J. Gross and A.A. Ioannides. "Linear transformations of data space in MEG",
                    %Phys. Med. Biol., vol. 44, pp. 2081–2097, 1999.
                    L_aux = L(:,L_ind(n_iter,:));
                    L_aux = L_aux2(:,L_ind(n_iter,:))/norm(L_aux);
                elseif strcmp(evalin('base','zef.beamformer.normalize_leadfield.Value'),'2')
                    L_aux = L(:,L_ind(n_iter,:));
                    L_aux = L_aux2(:,L_ind(n_iter,:))./sqrt(sum(L_aux.^2,1));
                elseif strcmp(evalin('base','zef.beamformer.normalize_leadfield.Value'),'3')
                    L_aux = L(:,L_ind(n_iter,:));
                    L_aux = L_aux2(:,L_ind(n_iter,:))./sqrt(sum(L_aux.^2,2));
                else
                    L_aux = L_aux2(:,L_ind(n_iter,:));
                end
            end
        else
        %Leadfield normalizations
        if strcmp(evalin('base','zef.beamformer.normalize_leadfield.Value'),'1')
            %Leadfield normalization suggested by
            %- B.D. Van Veen et al. "Localization of brain electrical activity via linearly constrained minimum variance spatial filtering",
            %IEEE Trans. Biomed. Eng., vol. 44, pp. 867–880, Sept. 1997.
            %- J. Gross and A.A. Ioannides. "Linear transformations of data space in MEG",
            %Phys. Med. Biol., vol. 44, pp. 2081–2097, 1999.
            L_aux = L(:,L_ind(n_iter,:));
            L_aux = L_aux2(:,L_ind(n_iter,:))/norm(L_aux);
        elseif strcmp(evalin('base','zef.beamformer.normalize_leadfield.Value'),'2')
            L_aux = L(:,L_ind(n_iter,:));
            L_aux = L_aux2(:,L_ind(n_iter,:))./sqrt(sum(L_aux.^2,1));
        elseif strcmp(evalin('base','zef.beamformer.normalize_leadfield.Value'),'3')
            L_aux = L(:,L_ind(n_iter,:));
            L_aux = L_aux2(:,L_ind(n_iter,:))./sqrt(sum(L_aux.^2,2));
        else
            L_aux = L_aux2(:,L_ind(n_iter,:));
        end
        end

        %Leadfield regularization
        if evalin('base','zef.L_reg_type')==1
            invLTinvCL = inv(L_aux'*L_aux+lambda_L*eye(size(L_aux,2)));
        elseif evalin('base','zef.L_reg_type')==2
            invLTinvCL = pinv(L_aux'*L_aux);
        end

        %dipole momentum estimate:

        z_vec(L_ind(n_iter,:)) = real(invLTinvCL*L_aux'*f);
        %location estimation:
        Var_vec(L_ind(n_iter,:)) = trace(z_vec(L_ind(n_iter,:))*z_vec(L_ind(n_iter,:))');

        if mod(n_iter-2,update_waiting_bar) == 0
        if f_ind > 1;
         waitbar(f_ind/number_of_frames,h,['Step ' int2str(f_ind) ' of ' int2str(number_of_frames) '. Ready: ' date_str '.' ]);
        elseif number_of_frames == 1
            waitbar(n_iter/nn,h,['LCMV iteration ',num2str(n_iter),' of ',num2str(nn),'. Ready: ' date_str '.']);
        end;
        end
    end

elseif method_type == 2
    %__ Sekihara's Borgiotti-Kaplan Beamformer __
%Inversion method is based on article's "Reconstructing Spatio-Temporal Activities of
%Neural Sources Using an MEG Vector Beamformer Technique1" description.
%K. Sekihara et al., IEEE TRANSACTIONS ON BIOMEDICAL ENGINEERING, VOL. 48, NO. 7, JULY 2001

    %determine indices of triplets (ind) and their total amount (nn)
    if source_direction_mode == 1  || source_direction_mode == 2
        nn = length(procFile.s_ind_1)/3;
        %L_ind = [procFile.s_ind_1(1:nn),procFile.s_ind_1(nn+(1:nn)),procFile.s_ind_1(2*nn+(1:nn))];
        L_ind = [1:nn;nn+(1:nn);2*nn+(1:nn)]';
    elseif source_direction_mode == 3
        nn = length(procFile.s_ind_1);
        L_ind = transpose(1:nn);
    end

    nn = size(L_ind,1);
    update_waiting_bar = floor(0.1*(nn-2));
    L_aux2 = sqrtm(C)\L;

    for n_iter = 1:nn
        %Date string if one time point
        if number_of_frames == 1  && n_iter > 1
            time_val = toc;
            date_str = datestr(datevec(now+(nn/(n_iter-1) - 1)*time_val/86400));
        end

        %Normalized directions are calculated via scalar beamformer
        if source_direction_mode == 2
            %=== NORMAL DIRECTIONED COMPONENTS ===
            if ismember(L_ind(n_iter,1),procFile.s_ind_4)
                L_aux = L(:,L_ind(n_iter,1));
                %Leadfield regularization
                if evalin('base','zef.L_reg_type')==1
                    lambdaI = lambda_L*eye(size(L_aux,2));
                end
                L_aux = L_aux2(:,L_ind(n_iter,1));
                if evalin('base','zef.L_reg_type')==2
                    weights = C\pinv(L_aux)';
                else
                    weights = (C\L(:,L_ind(n_iter,1)))/(L_aux'*L_aux+lambdaI);
                end
            %Leadfield normalization can not be used with scalar beamformer and therefore need to be carefully valuated in general
            %when norma leadfiel direction is used.
            %=== CARTESIAN DIRECTIONED COMPONENTS ===
            else
                L_aux = L(:,L_ind(n_iter,1));
                %Leadfield regularization
                if evalin('base','zef.L_reg_type')==1
                    lambdaI = lambda_L*eye(size(L_aux,2));
                end
                %Leadfield normalization
                if strcmp(evalin('base','zef.beamformer.normalize_leadfield.Value'),'1')
                    %Leadfield normalization suggested by
            %- B.D. Van Veen et al. "Localization of brain electrical activity via linearly constrained minimum variance spatial filtering",
            %IEEE Trans. Biomed. Eng., vol. 44, pp. 867–880, Sept. 1997.
            %- J. Gross and A.A. Ioannides. "Linear transformations of data space in MEG",
            %Phys. Med. Biol., vol. 44, pp. 2081–2097, 1999.
                      L_aux = L_aux2(:,L_ind(n_iter,:))/norm(L_aux);
                      if ~ismember(evalin('base','zef.L_reg_type'),[2])
                          weights = C\L_aux;
                          weights = weights/(L_aux'*L_aux+lambdaI);
                      else
                          weights = C\pinv(L_aux)';
                      end
                elseif strcmp(evalin('base','zef.beamformer.normalize_leadfield.Value'),'2')
                    L_aux = L_aux2(:,L_ind(n_iter,:))./sqrt(sum(L_aux.^2,1));
                    if ~ismember(evalin('base','zef.L_reg_type'),[2])
                        weights = C\L_aux;
                        weights = weights/(L_aux'*L_aux+lambdaI);
                    else
                        weights = C\pinv(L_aux)';
                    end
                elseif strcmp(evalin('base','zef.beamformer.normalize_leadfield.Value'),'3')
                    L_aux = L_aux2(:,L_ind(n_iter,:))./sqrt(sum(L_aux.^2,2));
                    if ~ismember(evalin('base','zef.L_reg_type'),[2])
                        weights = C\L_aux;
                        weights = weights/(L_aux'*L_aux+lambdaI);
                    else
                        weights = C\pinv(L_aux)';
                    end
                else
                    L_aux = L_aux2(:,L_ind(n_iter,:));
                    if ~ismember(evalin('base','zef.L_reg_type'),[2])
                        weights = C\L_aux;
                        weights = weights/(L_aux'*L_aux+lambdaI);
                    else
                        weights = C\pinv(L_aux)';
                    end
                end
            end
        else
        L_aux = L(:,L_ind(n_iter,1));
        %Leadfield regularization
        if evalin('base','zef.L_reg_type')==1
            lambdaI = lambda_L*eye(size(L_aux,2));
        end
        %Leadfield normalization
        if strcmp(evalin('base','zef.beamformer.normalize_leadfield.Value'),'1')
            %Leadfield normalization suggested by
            %- B.D. Van Veen et al. "Localization of brain electrical activity via linearly constrained minimum variance spatial filtering",
            %IEEE Trans. Biomed. Eng., vol. 44, pp. 867–880, Sept. 1997.
            %- J. Gross and A.A. Ioannides. "Linear transformations of data space in MEG",
            %Phys. Med. Biol., vol. 44, pp. 2081–2097, 1999.
            L_aux = L_aux2(:,L_ind(n_iter,:))/norm(L_aux);
            if ~ismember(evalin('base','zef.L_reg_type'),[2])
                weights = C\L_aux;
                weights = weights/(L_aux'*L_aux+lambdaI);
            else
                weights = weights*pinv(L_aux'*L_aux);
            end
        elseif strcmp(evalin('base','zef.beamformer.normalize_leadfield.Value'),'2')
            L_aux = L_aux2(:,L_ind(n_iter,:))./sqrt(sum(L_aux.^2,1));
            if ~ismember(evalin('base','zef.L_reg_type'),[2])
                weights = C\L_aux;
                weights = weights/(L_aux'*L_aux+lambdaI);
            else
                weights = weights*pinv(L_aux'*L_aux);
            end
        elseif strcmp(evalin('base','zef.beamformer.normalize_leadfield.Value'),'3')
            L_aux = L_aux2(:,L_ind(n_iter,:))./sqrt(sum(L_aux.^2,2));
            if ~ismember(evalin('base','zef.L_reg_type'),[2])
                weights = C\L_aux;
                weights = weights/(L_aux'*L_aux+lambdaI);
            else
                weights = C\pinv(L_aux)';
            end
        else
            L_aux = L_aux2(:,L_ind(n_iter,:));
            if ~ismember(evalin('base','zef.L_reg_type'),[2])
                weights = C\L_aux;
                weights = weights/(L_aux'*L_aux+lambdaI);
            else
                weights = C\pinv(L_aux)';
            end
        end
        end
        %Borgiotti-Kaplan steering:
        weights = weights./sqrt(sum(weights.^2,1));

        %dipole moment estimation:
        z_vec(L_ind(n_iter,:)) = real(weights'*f);
        %location estimation:
        Var_vec(L_ind(n_iter,:)) = trace(z_vec(L_ind(n_iter,:))*z_vec(L_ind(n_iter,:))');

        if mod(n_iter-2,update_waiting_bar) == 0
        if f_ind > 1;
         waitbar(f_ind/number_of_frames,h,['Step ' int2str(f_ind) ' of ' int2str(number_of_frames) '. Ready: ' date_str '.' ]);
        elseif number_of_frames == 1
            waitbar(n_iter/nn,h,['UNG iteration ',num2str(n_iter),' of ',num2str(nn),'. Ready: ' date_str '.']);
        end;
        end
    end

elseif method_type == 3
   %__ Unit-Gain constraint Beamformer __

    %determine indices of triplets (ind) and their total amount (nn)
    if source_direction_mode == 1  || source_direction_mode == 2
        nn = length(procFile.s_ind_1)/3;
        %L_ind = [procFile.s_ind_1(1:nn),procFile.s_ind_1(nn+(1:nn)),procFile.s_ind_1(2*nn+(1:nn))];
        L_ind = [1:nn;nn+(1:nn);2*nn+(1:nn)]';
    elseif source_direction_mode == 3
        nn = length(procFile.s_ind_1);
        L_ind = transpose(1:nn);
    end

    nn = size(L_ind,1);
    update_waiting_bar = floor(0.1*(nn-2));

    f = sqrtm(C)\f;
    L_aux2 = sqrtm(C)\L;

    for n_iter = 1:nn
        %Date string if one time point
        if number_of_frames == 1 && n_iter > 1
            time_val = toc;
            date_str = datestr(datevec(now+(nn/(n_iter-1) - 1)*time_val/86400));
        end

        %Normalized directions are calculated via scalar beamformer
        if source_direction_mode == 2
            if ismember(L_ind(n_iter,1),procFile.s_ind_4)
                L_aux = L_aux2(:,L_ind(n_iter,1));
            else
                %Leadfield normalizations
                if strcmp(evalin('base','zef.beamformer.normalize_leadfield.Value'),'1')
                    %Leadfield normalization suggested by
                    %- B.D. Van Veen et al. "Localization of brain electrical activity via linearly constrained minimum variance spatial filtering",
                    %IEEE Trans. Biomed. Eng., vol. 44, pp. 867–880, Sept. 1997.
                    %- J. Gross and A.A. Ioannides. "Linear transformations of data space in MEG",
                    %Phys. Med. Biol., vol. 44, pp. 2081–2097, 1999.
                    L_aux = L(:,L_ind(n_iter,:));
                    L_aux = L_aux2(:,L_ind(n_iter,:))/norm(L_aux);
                elseif strcmp(evalin('base','zef.beamformer.normalize_leadfield.Value'),'2')
                    L_aux = L(:,L_ind(n_iter,:));
                    L_aux = L_aux2(:,L_ind(n_iter,:))./sqrt(sum(L_aux.^2,1));
                elseif strcmp(evalin('base','zef.beamformer.normalize_leadfield.Value'),'3')
                    L_aux = L(:,L_ind(n_iter,:));
                    L_aux = L_aux2(:,L_ind(n_iter,:))./sqrt(sum(L_aux.^2,2));
                else
                    L_aux = L_aux2(:,L_ind(n_iter,:));
                end
            end
        else
        %Leadfield normalizations
        if strcmp(evalin('base','zef.beamformer.normalize_leadfield.Value'),'1')
            %Leadfield normalization suggested by
            %- B.D. Van Veen et al. "Localization of brain electrical activity via linearly constrained minimum variance spatial filtering",
            %IEEE Trans. Biomed. Eng., vol. 44, pp. 867–880, Sept. 1997.
            %- J. Gross and A.A. Ioannides. "Linear transformations of data space in MEG",
            %Phys. Med. Biol., vol. 44, pp. 2081–2097, 1999.
            L_aux = L(:,L_ind(n_iter,:));
            L_aux = L_aux2(:,L_ind(n_iter,:))/norm(L_aux);
        elseif strcmp(evalin('base','zef.beamformer.normalize_leadfield.Value'),'2')
            L_aux = L(:,L_ind(n_iter,:));
            L_aux = L_aux2(:,L_ind(n_iter,:))./sqrt(sum(L_aux.^2,1));
        elseif strcmp(evalin('base','zef.beamformer.normalize_leadfield.Value'),'3')
            L_aux = L(:,L_ind(n_iter,:));
            L_aux = L_aux2(:,L_ind(n_iter,:))./sqrt(sum(L_aux.^2,2));
        else
            L_aux = L_aux2(:,L_ind(n_iter,:));
        end
        end

        %Find optiomal orienation via Rayleigh-Ritz formula
        [opt_orientation ,~] = eigs(L_aux'*L_aux,1,'smallestabs');
        opt_orientation = opt_orientation/norm(opt_orientation);
        L_aux = L_aux*opt_orientation;

        %Leadfield regularization
        if evalin('base','zef.L_reg_type')==1
            invLTinvCL = inv(L_aux'*L_aux+lambda_L*eye(size(L_aux,2)));
        elseif evalin('base','zef.L_reg_type')==2
            invLTinvCL = pinv(L_aux'*L_aux);
        end

        %dipole momentum estimate:

        z_vec(L_ind(n_iter,:)) = real(invLTinvCL*L_aux'*f)*opt_orientation;
        %location estimation:
        Var_vec(L_ind(n_iter,:)) = trace(z_vec(L_ind(n_iter,:))*z_vec(L_ind(n_iter,:))');

        if mod(n_iter-2,update_waiting_bar) == 0
        if f_ind > 1;
         waitbar(f_ind/number_of_frames,h,['Step ' int2str(f_ind) ' of ' int2str(number_of_frames) '. Ready: ' date_str '.' ]);
        elseif number_of_frames == 1
            waitbar(n_iter/nn,h,['LCMV iteration ',num2str(n_iter),' of ',num2str(nn),'. Ready: ' date_str '.']);
        end;
        end
    end

elseif method_type==4

    %determine indices of triplets (ind) and their total amount (nn)
    if source_direction_mode == 1  || source_direction_mode == 2
        nn = length(procFile.s_ind_1)/3;
        %L_ind = [procFile.s_ind_1(1:nn),procFile.s_ind_1(nn+(1:nn)),procFile.s_ind_1(2*nn+(1:nn))];
        L_ind = [1:nn;nn+(1:nn);2*nn+(1:nn)]';
    elseif source_direction_mode == 3
        nn = length(procFile.s_ind_1);
        L_ind = transpose(1:nn);
    end

    nn = size(L_ind,1);
    update_waiting_bar = floor(0.1*(nn-2));

    %f = sqrtm(C)\f;
   % L_aux2 = C\L;

    for n_iter = 1:nn
        %Date string if one time point
        if number_of_frames == 1 && n_iter > 1
            time_val = toc;
            date_str = datestr(datevec(now+(nn/(n_iter-1) - 1)*time_val/86400));
        end

        %Normalized directions are calculated via scalar beamformer
        if source_direction_mode == 2
            if ismember(L_ind(n_iter,1),procFile.s_ind_4)
                L_aux = L(:,L_ind(n_iter,1));
            else
                %Leadfield normalizations
                if strcmp(evalin('base','zef.beamformer.normalize_leadfield.Value'),'1')
                    %Leadfield normalization suggested by
                    %- B.D. Van Veen et al. "Localization of brain electrical activity via linearly constrained minimum variance spatial filtering",
                    %IEEE Trans. Biomed. Eng., vol. 44, pp. 867–880, Sept. 1997.
                    %- J. Gross and A.A. Ioannides. "Linear transformations of data space in MEG",
                    %Phys. Med. Biol., vol. 44, pp. 2081–2097, 1999.
                    L_aux = L(:,L_ind(n_iter,:));
                    L_aux = L(:,L_ind(n_iter,:))/norm(L_aux);
                elseif strcmp(evalin('base','zef.beamformer.normalize_leadfield.Value'),'2')
                    L_aux = L(:,L_ind(n_iter,:));
                    L_aux = L(:,L_ind(n_iter,:))./sqrt(sum(L_aux.^2,1));
                elseif strcmp(evalin('base','zef.beamformer.normalize_leadfield.Value'),'3')
                    L_aux = L(:,L_ind(n_iter,:));
                    L_aux = L(:,L_ind(n_iter,:))./sqrt(sum(L_aux.^2,2));
                else
                    L_aux = L(:,L_ind(n_iter,:));
                end
            end
        else
            %Leadfield normalizations
            if strcmp(evalin('base','zef.beamformer.normalize_leadfield.Value'),'1')
                %Leadfield normalization suggested by
                %- B.D. Van Veen et al. "Localization of brain electrical activity via linearly constrained minimum variance spatial filtering",
                %IEEE Trans. Biomed. Eng., vol. 44, pp. 867–880, Sept. 1997.
                %- J. Gross and A.A. Ioannides. "Linear transformations of data space in MEG",
                %Phys. Med. Biol., vol. 44, pp. 2081–2097, 1999.
                L_aux = L(:,L_ind(n_iter,:));
                L_aux = L(:,L_ind(n_iter,:))/norm(L_aux);
            elseif strcmp(evalin('base','zef.beamformer.normalize_leadfield.Value'),'2')
                L_aux = L(:,L_ind(n_iter,:));
                L_aux = L(:,L_ind(n_iter,:))./sqrt(sum(L_aux.^2,1));
            elseif strcmp(evalin('base','zef.beamformer.normalize_leadfield.Value'),'3')
                L_aux = L(:,L_ind(n_iter,:));
                L_aux = L(:,L_ind(n_iter,:))./sqrt(sum(L_aux.^2,2));
            else
                L_aux = L(:,L_ind(n_iter,:));
            end
        end

        L_aux2=L_aux'*(C\L_aux); %is needed for the orientation
        L_aux=C\L_aux;

        %Find optiomal orienation via Rayleigh-Ritz formula
        [opt_orientation ,~] = eigs(L_aux'*L_aux,L_aux2, 1,'smallestabs');
        opt_orientation = opt_orientation/norm(opt_orientation);
        L_aux = L_aux*opt_orientation;

        %Leadfield regularization
        if evalin('base','zef.L_reg_type')==1
            invSqrtLTinvC2L = sqrt(inv(L_aux'*L_aux+lambda_L*eye(size(L_aux,2))));
        elseif evalin('base','zef.L_reg_type')==2
            invSqrtLTinvC2L = sqrt(pinv(L_aux'*L_aux));
        end

        %dipole momentum estimate:

        z_vec(L_ind(n_iter,:)) = real(invSqrtLTinvC2L*L_aux'*f)*opt_orientation; %orientation for the zef data format
        %location estimation:
        Var_vec(L_ind(n_iter,:)) = trace(z_vec(L_ind(n_iter,:))*z_vec(L_ind(n_iter,:))');

        if mod(n_iter-2,update_waiting_bar) == 0
            if f_ind > 1;
                waitbar(f_ind/number_of_frames,h,['Step ' int2str(f_ind) ' of ' int2str(number_of_frames) '. Ready: ' date_str '.' ]);
            elseif number_of_frames == 1
                waitbar(n_iter/nn,h,['LCMV iteration ',num2str(n_iter),' of ',num2str(nn),'. Ready: ' date_str '.']);
            end;
        end
    end

end
% %location estimation:
% current_vec = [z_vec(ind(:,1)),z_vec(ind(:,2)),z_vec(ind(:,3))];
% Var_vec(ind(:,1)) = sum((current_vec-mean(current_vec,1)).^2,2);
% Var_vec(ind(:,2)) = Var_vec(ind(:,1));
% Var_vec(ind(:,3)) = Var_vec(ind(:,1));

%------------------------------------------------------------------
z{f_ind} = z_vec;
Var_loc{f_ind} = Var_vec;
end;

z = zef_postProcessInverse(z, procFile);
z = zef_normalizeInverseReconstruction(z);

Var_loc = zef_postProcessInverse(Var_loc, procFile);
Var_loc = zef_normalizeInverseReconstruction(Var_loc);

close(h);
end
