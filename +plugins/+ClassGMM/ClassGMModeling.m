%% Copyright © 2025- Joonas Lahtinen
function [MethodClassObj] = ClassGMModeling(MethodClassObj,reconstruction,zef,args)
arguments
    MethodClassObj (1,1) inverse.CommonInverseParameters
    reconstruction (:,:) {mustBeA(reconstruction,["double","gpuArray","cell"])}
    zef (:,:) struct
    args.number_of_clusters (1,:) int8 = 3
    args.sought_estimate (1,1) string {mustBeMember(args.sought_estimate,["Location & orientation","Location"])} = "Location & orientation"
    args.covariance_type (1,1) string {mustBeMember(args.covariance_type,["full","diagonal"])} = "full"
    args.MaxIter (1,1) int8 = 1000
    args.reconstruction_threshold (1,1) double = 0.25
    args.regularization_parameter (1,1) double = 1e-2
    args.SharedCovariance (1,1) logical = false
    args.use_selected_parcellations (1,1) logical = false
    args.amplitude_estimation_type (1,1) string {mustBeMember(args.amplitude_estimation_type,["Point density", "Maximal likelihood", "Maximum a posteriori"])} = "Point density"
    args.model_selection_criterion (1,1) string {mustBeMember(args.model_selection_criterion,["Given number of components","Bayesian information criterion","L2 density error"])} = "Bayesian information criterion"
    args.initial_cluster_finding_approach (1,1) string {mustBeMember(args.initial_cluster_finding_approach,["k-means ++","Maximum probability","Maximum component-wise fit"])} = "Maximum component-wise fit"
    args.number_of_replicates (1,1) int8 = 1
    args.log_posterior_threshold_dB (1,1) double = 6
    args.reconstruction_smoothing_std (1,1) double = 0
    args.mixture_component_probability (1,1) double = 0.95;
    args.start_frame (:,:) int8 = int8([])
    args.stop_frame (:,:) int8 = int8([])
end

h = zef_waitbar(0,['Gaussian mixature model.']);
cleanup_fn = @(wb) close(wb);
cleanup_obj = onCleanup(@() cleanup_fn(h));
MethodClassObj.GMM.TimeVariables = [];
MethodClassObj.GMM.TimeVariables.sampling_frequency = MethodClassObj.sampling_frequency;
MethodClassObj.GMM.TimeVariables.time_start = MethodClassObj.time_start;
MethodClassObj.GMM.TimeVariables.time_window = MethodClassObj.time_window;
MethodClassObj.GMM.TimeVariables.time_step = MethodClassObj.time_step;

%Se parameters used in calculations
Sigma = char(args.covariance_type);
SharedCovariance = args.SharedCovariance;
K = double(args.number_of_clusters);

%Options 
options = statset('MaxIter',double(args.MaxIter));


z_vec = reconstruction;
if isempty(z_vec)
    warning('There is no reconstruction.')
end

source_positions = zef.source_positions;
%check parcellation


if args.use_selected_parcellations
source_ind_aux = zef.source_interpolation_ind{1};
p_ind_aux_1 = [];
p_selected = zef.parcellation_selected;
for p_ind = 1 : length(p_selected)
    p_ind_aux_2 = zef.parcellation_interp_ind{p_selected(p_ind)}{1};
    p_ind_aux_1 = [p_ind_aux_1 ;  unique(p_ind_aux_2)];
end
p_ind_aux_1 = unique(p_ind_aux_1);
I_aux = unique(source_ind_aux(p_ind_aux_1,:));
source_positions = source_positions(I_aux(:),:);
I_aux = [3*I_aux(:)-2,3*I_aux(:)-1,3*I_aux(:)];
end
clear p_ind_aux_1 p_ind_aux_2 p_ind p_selected source_ind_aux

if strcmp(args.sought_estimate,"Location & orientation")
    estim_param = 1;
else
    estim_param = 2;
end
threshold = args.reconstruction_threshold;
reg_value = args.regularization_parameter;
switch args.amplitude_estimation_type
    case "Point density"
        amp_est_type = 1;
    case "Maximal likelihood"
        amp_est_type = 2;
    otherwise
        amp_est_type = 3;
end

smooth_std = args.reconstruction_smoothing_std;
switch args.initial_cluster_finding_approach
    case "k-means ++"
        initial_mode = '1';
    case "Maximum probability"
        initial_mode = '2';
    otherwise
        initial_mode = '3';
end
model_criterion = args.model_selection_criterion;
replicates = double(args.number_of_replicates);
logpdfThreshold = 10^(-args.log_posterior_threshold_dB/20);
r_squared = chi2inv(args.mixture_component_probability,5);

if iscell(z_vec)
    if isempty(args.start_frame)
        t_start = 1;
    else
        t_start = args.start_frame;
    end
    if isempty(args.stop_frame)
        T = length(z_vec);
    else
        T = args.stop_frame;
    end
    MethodClassObj.GMM.Model=cell(T,1);
    MethodClassObj.GMM.Dipoles=cell(T,1);
else
    t_start=1;
    T=1;
end

if length(K) < T
    K = [K,K(end)*ones(1,T-length(K))];
end

zef_waitbar(0,h,['Step 1 of ',num2str(T),'. Please wait.']);
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
        if not(args.use_selected_parcellations)
            z=sqrt(z_vec{t}(1:3:end).^2+z_vec{t}(2:3:end).^2+z_vec{t}(3:3:end).^2);
            direct = [z_vec{t}(1:3:end),z_vec{t}(2:3:end),z_vec{t}(3:3:end)];
            direct = direct./sqrt(sum(direct.^2,2));
        else
            z=sqrt(z_vec{t}(I_aux(:,1)).^2+z_vec{t}(I_aux(:,2)).^2+z_vec{t}(I_aux(:,3)).^2);
            direct = [z_vec{t}(I_aux(:,1)),z_vec{t}(I_aux(:,2)),z_vec{t}(I_aux(:,3))];
            direct = direct./sqrt(sum(direct.^2,2));
        end
    else
        if not(args.use_selected_parcellations)
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
            MethodClassObj.GMM.Model{t} = [];
        else
            MethodClassObj.GMM.Model = [];
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
            MethodClassObj.GMM.Model{t} = [];
        else
            MethodClassObj.GMM.Model = [];
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
    
    if strcmp(model_criterion,"Given number of components")
        if T>1
            MethodClassObj.GMM.Model{t} = GMModel_aux;
        else
            MethodClassObj.GMM.Model = GMModel_aux;
        end
    elseif strcmp(model_criterion,"Bayesian information criterion")
        if GMModel_aux.BIC < best_fit
                best_fit = GMModel_aux.BIC;
            if T>1
                MethodClassObj.GMM.Model{t} = GMModel_aux;
            else
                MethodClassObj.GMM.Model = GMModel_aux;
            end
        end
    elseif strcmp(model_criterion,"L2 density error")
        density = pdf(gmdistribution(GMModel_aux.mu(:,1:3),GMModel_aux.Sigma(1:3,1:3,:),GMModel_aux.ComponentProportion),source_positions);
        fit = sum((z/sum(z)-density/sum(density)).^2);
        disp(fit)
        if fit < best_fit
            best_fit = fit;
            if T>1
                MethodClassObj.GMM.Model{t} = GMModel_aux;
            else
                MethodClassObj.GMM.Model = GMModel_aux;
            end
        end
    end
    
    if T==1
      zef_waitbar(k/K(t),h,['Step ',num2str(k),' of ',num2str(K(t)),'. ',date_str]);
    end
    
    end     %end of k loop
    
    if T > 1
        if isstruct(MethodClassObj.GMM.Model{t})
        ind2 = [];
        for k = 1:size(MethodClassObj.GMM.Model{t}.mu,1)
            [~,ind2(k)] = min(sum((MethodClassObj.GMM.Model{t}.mu(k,1:3)-source_positions).^2,2));
        end
        disp(['Relative centroid point current densities at the frame ',num2str(t),': ',num2str(J(ind2)'/max(J))])
        if estim_param == 1
        MethodClassObj.GMM.Dipoles{t} = [cos(MethodClassObj.GMM.Model{t}.mu(:,5)).*sin(MethodClassObj.GMM.Model{t}.mu(:,4)),sin(MethodClassObj.GMM.Model{t}.mu(:,5)).*sin(MethodClassObj.GMM.Model{t}.mu(:,4)),cos(MethodClassObj.GMM.Model{t}.mu(:,4))];
        if amp_est_type == 1
            amp = J(ind2);
        elseif amp_est_type == 2
            amp = GMM2amplitude(MethodClassObj.GMM.Dipoles{t},ind2,t,1)*1e3;
        else
            amp = GMM2amplitude(MethodClassObj.GMM.Dipoles{t},ind2,t,2)*1e3;
        end
        MethodClassObj.GMM.Dipoles{t} = amp.*MethodClassObj.GMM.Dipoles{t};
        MethodClassObj.GMM.Amplitudes{t} = amp;
        elseif estim_param == 2
            MethodClassObj.GMM.Dipoles{t} = NaN;
            amp = GMM2amplitude(ones(size(MethodClassObj.GMM.Model{t}.mu,1),3),ind2,t,2)*1e3;
            MethodClassObj.GMM.Amplitudes{t} = amp;
        end 
        
        zef_waitbar((t-t_start+1)/(T-t_start+1),h,['Frame ',num2str(t),' of ',num2str(T),'. ',date_str]);
        end
    else
       if isstruct(MethodClassObj.GMM.Model)
       ind2 = [];
        for k = 1:size(MethodClassObj.GMM.Model.mu,1)
            [~,ind2(k)] = min(sum((MethodClassObj.GMM.Model.mu(k,1:3)-source_positions).^2,2));
        end
        disp(['Relative centroid point current densities: ',num2str(J(ind2)'/max(J))]) 
        if estim_param == 1
        MethodClassObj.GMM.Dipoles = [cos(MethodClassObj.GMM.Model.mu(:,5)).*sin(MethodClassObj.GMM.Model.mu(:,4)),sin(MethodClassObj.GMM.Model.mu(:,5)).*sin(MethodClassObj.GMM.Model.mu(:,4)),cos(MethodClassObj.GMM.Model.mu(:,4))];
        if amp_est_type == 1
            amp = J(ind2);
        elseif amp_est_type == 2
            amp = GMM2amplitude(MethodClassObj.GMM.Dipoles,ind2,1,1)*1e3;
        else
            amp = GMM2amplitude(MethodClassObj.GMM.Dipoles,ind2,1,2)*1e3;
        end
        MethodClassObj.GMM.Dipoles = amp.*MethodClassObj.GMM.Dipoles;
        MethodClassObj.GMM.Amplitudes = amp;
        elseif estim_param == 2
            MethodClassObj.GMM.Dipoles{t} = NaN;
            amp = GMM2amplitude(ones(size(MethodClassObj.GMM.Model.mu,1),3),ind2,t,2)*1e3;
            MethodClassObj.GMM.Amplitudes = amp;
        end
       end
    end
end     %end of t loop

close(h);
end
    