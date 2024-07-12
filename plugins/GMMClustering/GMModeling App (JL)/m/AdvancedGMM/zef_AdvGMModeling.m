function [GMModel,GMModelDipoles,GMModelAmplitudes,GMModelTimeVariables] = zef_AdvGMModeling
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
        elseif isfield(reconstruction_information,'sampling_freq')
            GMModelTimeVariables.sampling_frequency = reconstruction_information.sampling_freq;
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

estim_param = str2num(parameters{22}); 
threshold = str2num(parameters{5});
reg_value = str2num(parameters{15});
amp_est_type = str2num(parameters{21});
meta1 = evalin('base','zef.GMM.meta{1}');
smooth_std = str2num(parameters{meta1+6});
initial_mode = parameters{meta1+2};
model_criterion = parameters{meta1+1};
replicates =str2num(parameters{meta1+3});
logpdfThreshold = 10^(-str2num(parameters{meta1+4})/20);
r_squared = chi2inv(str2num(parameters{meta1+5}),5);

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
    best_fit = Inf;
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
    J = z;      %current density
    z = J/max(J);
    ind = z<threshold;
    z(ind) = 0;
    %Gaussian moothing step
    if smooth_std > 0
        ind_s = find(z>=threshold);
        MdlKDT = KDTreeSearcher(source_positions(ind_s,:));
        neighbours = knnsearch(MdlKDT,source_positions(ind_s,:),'K',10);
        for i = 1:50
            z(ind_s) = mean(z(ind_s(neighbours)),2);
        end
    end
  
    %Define the estimation space and weights
    ind = not(ind);
    if not(any(ind))
        if T>1
            GMModel{t} = [];
        else
            GMModel = [];
        end
        break;
    end
    weight = z(ind)/sum(z(ind));
    activity_pos = source_positions;
    
    if estim_param == 1
        activity_dir = [atan2(sqrt(sum((direct(ind,[1,2]).^2),2)),direct(ind,3)),atan2(direct(ind,2),direct(ind,1))];
        activity_space = [activity_pos(ind,:),activity_dir];
    elseif estim_param == 2
        activity_space = activity_pos(ind,:);
    end
    
    if size(activity_space,1)<=size(activity_space,2)
        if T>1
            GMModel{t} = [];
        else
            GMModel = [];
        end
        break;
    end

    if strcmp(initial_mode,'1')
        %calculate Gaussian mixature models:
        try
            GMModel_aux = FitAdvGMM(activity_space,weight,k,'CovarianceType',Sigma, ...
                'SharedCovariance',SharedCovariance,'Start','plus','Replicates',replicates,'Options',options);
        catch
            GMModel_aux = FitAdvGMM(activity_space,weight,k,'CovarianceType',Sigma, ...
                'SharedCovariance',SharedCovariance,'Start','plus','Replicates',replicates,'RegularizationValue',reg_value,'Options',options);
        end
    elseif strcmp(initial_mode,'2') || strcmp(initial_mode,'3')
        index_vec1=ones(size(activity_space,1),1);
        if strcmp(initial_mode,'2')
        if k>1
            try %if they have updated the cluster version from 2011 back to the modern one that eats GMMs
                [index_vec1, ~,~, mylogpdf]=cluster(GMModel_aux, activity_space);
            catch 
            %Do it by hand
            %create Mahlanobis distance matrix n x k
            MahalanobisD2 = nan(size(activity_space,1),GMModel_aux.NComponents);
            for kk = 1:GMModel_aux.NComponents
                MahalanobisD2(:,kk) = diag((GMModel_aux.mu(kk,:)-activity_space)*(squeeze(GMModel_aux.Sigma(:,:,kk))\(GMModel_aux.mu(kk,:)-activity_space)'));
            end
            %cluster indices
            [~,index_vec1] = min(MahalanobisD2,[],2);
            %Logarithm of the estimated pdf, evaluated at each observation in activity_space
            mylogpdf = log(sum(exp(-0.5*MahalanobisD2).*GMModel_aux.ComponentProportion,2));
            end

        counter=0;
        index_vec2=index_vec1;

        while length(unique(index_vec2))~=k && counter<256/logpdfThreshold
            index_vec2=index_vec1;
            counter=counter+1;
            ind1=find(mylogpdf<max(mylogpdf)-counter*logpdfThreshold);
            index_vec2(ind1)=k;
        end
        index_vec1=index_vec2;
        
        if length(unique(index_vec1))~=k
            disp(['The ',num2str(k),'-component GMM was not realized.']);
            break;
        end
        end
        elseif strcmp(initial_mode,'3')
            if k>1
                try %if they have updated the cluster version from 2011 back to the modern one that eats GMMs
                    [index_vec1, ~,~, ~, MahalanobisD2]=cluster(GMModel_aux, activity_space);
                catch
                    %Do it by hand
                    %create Mahlanobis distance matrix n x k
                    MahalanobisD2 = nan(size(activity_space,1),GMModel_aux.NComponents);
                    for kk = 1:GMModel_aux.NComponents
                        MahalanobisD2(:,kk) = diag((GMModel_aux.mu(kk,:)-activity_space)*(squeeze(GMModel_aux.Sigma(:,:,kk))\(GMModel_aux.mu(kk,:)-activity_space)'));
                    end
                    %cluster indices
                    [~,index_vec1] = min(MahalanobisD2,[],2);
                end
                ind = ones(size(MahalanobisD2,1),1);
                for kk = 1:(k-1)
                    ind1=MahalanobisD2(:,kk)<r_squared;
                    index_vec1(ind1)=kk;
                    ind = ind & not(ind1);
                    index_vec1(ind)=k;
                end      
             if length(unique(index_vec1))~=k
                disp(['The ',num2str(k),'-component GMM was not realized.'])
                break;
            end
            end
        end

        %modified Start-Option
        try
            GMModel_aux = FitAdvGMM(activity_space,weight,k,'CovarianceType',Sigma, ...
                'SharedCovariance',SharedCovariance,'Start',index_vec1, 'Options',options);
        catch
            GMModel_aux = FitAdvGMM(activity_space,weight,k,'CovarianceType',Sigma, ...
                'SharedCovariance',SharedCovariance,'Start',index_vec1,'RegularizationValue',reg_value,'Options',options);
        end
    end
    
    if strcmp(model_criterion,'1')
        if T>1
            GMModel{t} = GMModel_aux;
        else
            GMModel = GMModel_aux;
        end
    elseif strcmp(model_criterion,'2')
        if GMModel_aux.BIC < best_fit
                best_fit = GMModel_aux.BIC;
            if T>1
                GMModel{t} = GMModel_aux;
            else
                GMModel = GMModel_aux;
            end
        end
    elseif strcmp(model_criterion,'3')
        density = pdf(gmdistribution(GMModel_aux.mu(:,1:3),GMModel_aux.Sigma(1:3,1:3,:),GMModel_aux.ComponentProportion),source_positions);
        fit = sum((z/sum(z)-density/sum(density)).^2);
        disp(fit)
        if fit < best_fit
            best_fit = fit;
            if T>1
                GMModel{t} = GMModel_aux;
            else
                GMModel = GMModel_aux;
            end
        end
    end
    
    if T==1
      waitbar(k/K(t),h,['Step ',num2str(k),' of ',num2str(K(t)),'. ',date_str]);
    end
    
    end     %end of k loop
    
    if T > 1
        if isstruct(GMModel{t})
        ind2 = [];
        for k = 1:size(GMModel{t}.mu,1)
            [~,ind2(k)] = min(sum((GMModel{t}.mu(k,1:3)-source_positions).^2,2));
        end
        disp(['Relative centroid point current densities at the frame ',num2str(t),': ',num2str(J(ind2)'/max(J))])
        if estim_param == 1
        GMModelDipoles{t} = [cos(GMModel{t}.mu(:,5)).*sin(GMModel{t}.mu(:,4)),sin(GMModel{t}.mu(:,5)).*sin(GMModel{t}.mu(:,4)),cos(GMModel{t}.mu(:,4))];
        if amp_est_type == 1
            amp = J(ind2);
        elseif amp_est_type == 2
            amp = GMM2amplitude(GMModelDipoles{t},ind2,t,1)*1e3;
        else
            amp = GMM2amplitude(GMModelDipoles{t},ind2,t,2)*1e3;
        end
        GMModelDipoles{t} = amp.*GMModelDipoles{t};
        GMModelAmplitudes{t} = amp;
        elseif estim_param == 2
            GMModelDipoles{t} = NaN;
            amp = GMM2amplitude(ones(size(GMModel{t}.mu,1),3),ind2,t,2)*1e3;
            GMModelAmplitudes{t} = amp;
        end 
        
        waitbar((t-t_start+1)/(T-t_start+1),h,['Frame ',num2str(t),' of ',num2str(T),'. ',date_str]);
        end
    else
       if isstruct(GMModel)
       ind2 = [];
        for k = 1:size(GMModel.mu,1)
            [~,ind2(k)] = min(sum((GMModel.mu(k,1:3)-source_positions).^2,2));
        end
        disp(['Relative centroid point current densities: ',num2str(J(ind2)'/max(J))]) 
        if estim_param == 1
        GMModelDipoles = [cos(GMModel.mu(:,5)).*sin(GMModel.mu(:,4)),sin(GMModel.mu(:,5)).*sin(GMModel.mu(:,4)),cos(GMModel.mu(:,4))];
        if amp_est_type == 1
            amp = J(ind2);
        elseif amp_est_type == 2
            amp = GMM2amplitude(GMModelDipoles,ind2,1,1)*1e3;
        else
            amp = GMM2amplitude(GMModelDipoles,ind2,1,2)*1e3;
        end
        GMModelDipoles = amp.*GMModelDipoles;
        GMModelAmplitudes = amp;
        elseif estim_param == 2
            GMModelDipoles{t} = NaN;
            amp = GMM2amplitude(ones(size(GMModel.mu,1),3),ind2,t,2)*1e3;
            GMModelAmplitudes = amp;
        end
       end
    end
end     %end of t loop

close(h);
end
    