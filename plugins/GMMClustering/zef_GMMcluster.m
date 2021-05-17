function GMModel = zef_GMMcluster
h = waitbar(0,['Gaussian mixature model clustering.']);

%Options 
options = statset('MaxIter',evalin('base','zef.GMMcluster_MaxIter'));
if evalin('base','zef.GMMcluster_covtype')==1
    Sigma = 'full';
else
    Sigma = 'diagonal';
end

if evalin('base','zef.GMMcluster_covident')==1
    SharedCovariance = false;
else
    SharedCovariance = true;
end

%Initialization
K = evalin('base','zef.GMMcluster_clustnum');
if size(K,1) > size(K,2)
    K=K';
end

z_vec = evalin('base','zef.reconstruction');
if isempty(z_vec)
    warning('There is no reconstruction.')
end

source_positions = evalin('base','zef.source_positions');
threshold = evalin('base','zef.GMMcluster_threshold');
 
if iscell(z_vec)
    T=length(z_vec);
else
    T=1;
end
GMModel=cell(T,1);
%extend vector of K values to the length of the  time serie
if length(K) < T
    K = [K,K(end)*ones(1,T-length(K))];
end

waitbar(0,h,['Step 1 of ',num2str(T),'. Please wait.']);
tic;
for t=1:T
    time_val = toc;
    if t > 1
        date_str = ['Ready: ',datestr(datevec(now+(T/(t-1) - 1)*time_val/86400)),'.'];
    else
        date_str = [];
    end
    %calculuate squares of current densities
    if iscell(z_vec)
        z=sqrt(z_vec{t}(1:3:end).^2+z_vec{t}(2:3:end).^2+z_vec{t}(3:3:end).^2);
    else
        z=sqrt(z_vec(1:3:end).^2+z_vec(2:3:end).^2+z_vec(3:3:end).^2);
    end
    z = z./max(z);
    J = z;      %normalized current density
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
    activity_pos = activity_pos(cumsum(ind2),:);    
    %calculate Gaussian mixature models:
    if T>1
        GMModel{t} = fitgmdist(activity_pos,K(t),'CovarianceType',Sigma, ...
            'SharedCovariance',SharedCovariance,'Options',options);
        ind2 = [];
        for k = 1:K(t)
            [~,ind2(k)] = min(sum((GMModel{t}.mu(k,:)-source_positions).^2,2));
        end
        disp(['Relative centroid current densities at the frame ',num2str(t),': ',num2str(sqrt(J(ind2))')])
    else
        GMModel = fitgmdist(activity_pos,K,'CovarianceType',Sigma, ...
            'SharedCovariance',SharedCovariance,'Options',options);
        ind2 = [];
        for k = 1:K
            [~,ind2(k)] = min(sum((GMModel.mu(k,:)-source_positions).^2,2));
        end
        disp(['Relative centroid current densities: ',num2str(sqrt(J(ind2))')])
    end
    
    waitbar(t/T,h,['Step ',num2str(t),' of ',num2str(T),'. ',date_str]);

end

close(h);
end
    
    
    
        
        
        
    
    