function [GMModel,GMModelDipoles,GMModelAmplitudes,GMModelTimeVariables] = zef_GMModeling
h = waitbar(0,['Gaussian mixature model.']);
GMModelTimeVariables = [];
if evalin('base','isfield(zef,''reconstruction_information'')')
    reconstruction_information = evalin('base','zef.reconstruction_information');
    if isfield(reconstruction_information,'inv_time_1') && isfield(reconstruction_information,'inv_time_2') &&...
            isfield(reconstruction_information,'inv_time_3')
        if isfield(reconstruction_information,'inv_sampling_frequency') 
            GMModelTimeVariables.sampling_freq = reconstruction_information.inv_sampling_frequency;
        elseif isfield(reconstruction_information,'sampling_frequency')
            GMModelTimeVariables.sampling_frequency = reconstruction_information.sampling_frequency;
        end
        GMModelTimeVariables.time_1 = reconstruction_information.inv_time_1;
        GMModelTimeVariables.time_2 = reconstruction_information.inv_time_2;
        GMModelTimeVariables.time_3 = reconstruction_information.inv_time_3;
        
    end
end

parameters = evalin('base','zef.GMM.parameters.Values');
%Options 
options = statset('MaxIter',str2num(parameters{2}));
if strcmp(parameters{3},'1')
    Sigma = 'full';
else
    Sigma = 'diagonal';
end

if strcmp(parameters{4},'1')
    SharedCovariance = false;
else
    SharedCovariance = true;
end

%Initialization
K = str2num(parameters{1});
if size(K,1) > size(K,2)
    K=K';
end

z_vec = evalin('base','zef.reconstruction');
if isempty(z_vec)
    warning('There is no reconstruction.')
end

source_positions = evalin('base','zef.source_positions');
%check parcellation
tag_ind = evalin('base','find(strcmp(zef.GMM.parameters.Tags,''domain''))');


if strcmp(parameters{tag_ind},'2')
source_ind_aux = evalin('base','zef.source_interpolation_ind{1}');
p_ind_aux_1 = [];
p_selected = evalin('base','zef.parcellation_selected');
for p_ind = 1 : length(p_selected)
    p_ind_aux_2 = evalin('base',['zef.parcellation_interp_ind{' int2str(p_selected(p_ind)) '}{1}']);
    p_ind_aux_1 = [p_ind_aux_1 ;  unique(p_ind_aux_2)];
end
p_ind_aux_1 = unique(p_ind_aux_1);
I_aux = unique(source_ind_aux(p_ind_aux_1,:));
source_positions = source_positions(I_aux(:),:);
I_aux = [3*I_aux(:)-2,3*I_aux(:)-1,3*I_aux(:)];
end
clear p_ind_aux_1 p_ind_aux_2 p_ind p_selected source_ind_aux

threshold = str2num(parameters{5});
reg_value = str2num(parameters{15});

if iscell(z_vec)
    T=str2num(parameters{18});
    t_start = str2num(parameters{17});
    GMModel=cell(T,1);
    GMModelDipoles=cell(T,1);
else
    t_start=1;
    T=1;
end

if length(K) < T
    K = [K,K(end)*ones(1,T-length(K))];
end

waitbar(0,h,['Step 1 of ',num2str(T),'. Please wait.']);
tic;
for t=t_start:T
    best_BIC = Inf;
    if T > 1
        time_val = toc;
    end
    for k = 1:K(t)
    if T == 1
        time_val = toc;
    end
    if t > 1
        date_str = ['Ready: ',datestr(datevec(now+(T/(t-1) - 1)*time_val/86400)),'.'];
    elseif k > 1 && T == 1
        date_str = ['Ready: ',datestr(datevec(now+(K(t)/(k-1) - 1)*time_val/86400)),'.'];
    else
        date_str = [];
    end
    %calculuate squares of current densities
    if iscell(z_vec)
        if strcmp(parameters{tag_ind},'1')
            z=sqrt(z_vec{t}(1:3:end).^2+z_vec{t}(2:3:end).^2+z_vec{t}(3:3:end).^2);
            direct = [z_vec{t}(1:3:end),z_vec{t}(2:3:end),z_vec{t}(3:3:end)];
            direct = direct./sqrt(sum(direct.^2,2));
        else
            z=sqrt(z_vec{t}(I_aux(:,1)).^2+z_vec{t}(I_aux(:,2)).^2+z_vec{t}(I_aux(:,3)).^2);
            direct = [z_vec{t}(I_aux(:,1)),z_vec{t}(I_aux(:,2)),z_vec{t}(I_aux(:,3))];
            direct = direct./sqrt(sum(direct.^2,2));
        end
    else
        if strcmp(parameters{tag_ind},'1')
            z=sqrt(z_vec(1:3:end).^2+z_vec(2:3:end).^2+z_vec(3:3:end).^2);
            direct = [z_vec(1:3:end),z_vec(2:3:end),z_vec(3:3:end)];
            direct = direct./sqrt(sum(direct.^2,2));
        else
            z=sqrt(z_vec(I_aux(:,1)).^2+z_vec(I_aux(:,2)).^2+z_vec(I_aux(:,3)).^2);
            direct = [z_vec(I_aux(:,1)),z_vec(I_aux(:,2)),z_vec(I_aux(:,3))];
            direct = direct./sqrt(sum(direct.^2,2));
        end
    end
    J = sqrt(z);      %current density
    z = z./max(z);
    %Maximally expected sampling step:
    ind = z<threshold;
    z(ind) = 0;
    normalization_const = 16*size(source_positions,1)/sum(z);
    z = round(normalization_const*z);
    z(z(~ind)==0)=1;
    ind = z > 0;
    z_cum = cumsum(z(ind));
    ind2 = zeros(1,z_cum(end));
    ind2(z_cum-z(ind)+1)=1;
    activity_pos = source_positions(ind,:);
    activity_dir = direct(ind,:);
    
    activity_space = [activity_pos(cumsum(ind2),:),activity_dir(cumsum(ind2),:)];    
    %calculate Gaussian mixature models:
    try
        GMModel_aux = fitgmdist(activity_space,k,'CovarianceType',Sigma, ...
            'SharedCovariance',SharedCovariance,'Options',options);
    catch
        GMModel_aux = fitgmdist(activity_space,k,'CovarianceType',Sigma, ...
            'SharedCovariance',SharedCovariance,'RegularizationValue',reg_value,'Options',options);
    end
    
    if GMModel_aux.BIC < best_BIC
            best_BIC = GMModel_aux.BIC;
        if T>1
            GMModel{t} = GMModel_aux;
        else
            GMModel = GMModel_aux;
        end
    end
    
    if T==1
      waitbar(k/K(t),h,['Step ',num2str(k),' of ',num2str(K(t)),'. ',date_str]);
    end
    
    end     %end of k loop
    
    if T > 1
        ind2 = [];
        for k = 1:size(GMModel{t}.mu,1)
            [~,ind2(k)] = min(sum((GMModel{t}.mu(k,1:3)-source_positions).^2,2));
        end
        disp(['Relative centroid current densities at the frame ',num2str(t),': ',num2str(J(ind2)'/max(J))])
        GMModelDipoles{t} = J(ind2).*GMModel{t}.mu(:,4:6);
        GMModelAmplitudes{t} = sqrt(sum(GMModelDipoles{t}.^2,2));
        GMModelAmplitudes{t} = GMModelAmplitudes{t}/max(GMModelAmplitudes{t});
        waitbar((t-t_start+1)/(T-t_start+1),h,['Frame ',num2str(t),' of ',num2str(T),'. ',date_str]);
    else
       ind2 = [];
        for k = 1:size(GMModel.mu,1)
            [~,ind2(k)] = min(sum((GMModel.mu(k,1:3)-source_positions).^2,2));
        end
        disp(['Relative centroid current densities: ',num2str(J(ind2)'/max(J))]) 
        GMModelDipoles = J(ind2).*GMModel.mu(:,4:6);
        GMModelAmplitudes = sqrt(sum(GMModelDipoles.^2,2));
        GMModelAmplitudes = GMModelAmplitudes/max(GMModelAmplitudes);
    end

end     %end of t loop

close(h);
end
    