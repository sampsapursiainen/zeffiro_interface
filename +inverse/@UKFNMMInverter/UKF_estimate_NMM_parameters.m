
function [z_vec,time_series] = UKF_estimate_NMM_parameters(self,L)
% This function detect the sources that causes "number_of_corrclusters"
% different spike activities obtained during the time interval.
% Additionally, the function estimates the time evolution of each of the
% spikes using Jensen-Rit neural mass model whose parameters are estimated
% via Unscented Kalman filter (UKF).
arguments
    self (1,1) inverse.UKFNMMInverter
    L (:,:)
end

if isgpuarray(L)
    L = gather(L);
end
if isgpuarray(self.reconstruction)
    self.reconstruction = gather(self.reconstruction);
end

if isgpuarray(self.noise_cov)
    self.noise_cov = gather(self.noise_cov);
end

% initialize the output
z_vec = zeros(size(self.reconstruction));
time_series = zeros(self.number_of_corrclusters,size(self.reconstruction,2));

t_span = 0:(1/self.sampling_frequency):((self.number_of_frames-1)/self.sampling_frequency);
n = round(size(L,2)/3);
% compute "#source_positions x T" size z matrix
z = sqrt(reshape(sum(reshape(self.reconstruction.^2,3,[])),n,[]));
z = z/max(z,[],"all");
s_ind = find(max(z,[],2) > self.score_threshold); %threshold the insignificant source contributions off
z = z(s_ind,:);

% correlation matrix:
  Corr_matrix = z*z';

% compute number_of_corrclusters+1 correlation clusters and assume there is 1
% nonsense cluster within whose total score is lowest
clusters_ind = kmeans(Corr_matrix,self.number_of_corrclusters+1);
score = zeros(1,self.number_of_corrclusters+1);     %relevance score for each cluster
for n = 1:(self.number_of_corrclusters+1)
    score(n) = mean(sum(Corr_matrix(:,clusters_ind==n)));
end
% remove the nonsense cluster:
[~,cluster_id] = maxk(score,self.number_of_corrclusters);
        
%Find the peaking time points from average time course estimated by SKF:
% [PROBLEM] Spike detection can be improved
   [peaking_times,cluster_order] = estimate_peaks(z,t_span,self.number_of_corrclusters,clusters_ind,cluster_id);

% Estimate the Jansen-Rit parameters using Unscented KF for each correlation cluster:
N = 11;     % number of Jansen- Rit parameters

% initialize UKF

Q = diag(10.^round(log10([3.25;100.0;22.0;50.0;135.0;108.0;33.75;33.75;2.5;6.0;0.56]/10)));
%define the constant weights
Wmean = zeros(2*N+1,1);
Wcov = zeros(2*N+1,1);
UKF_coef = self.alpha^2*(N+self.kappa);
Wmean(1) = (UKF_coef-N)/(UKF_coef);
Wmean(2:end) = 0.5/UKF_coef;
Wcov(1) = (UKF_coef-N)/(UKF_coef) + 1 -self.alpha^2+self.beta;
Wcov(2:end) = 0.5/UKF_coef;

warning('off')
for k = 1:self.number_of_corrclusters
    % define the examined corrcluster-indicated spike
    s_ind3D = 3*s_ind(clusters_ind==cluster_id(cluster_order(k)))'-[0;1;2];
    s_ind3D = s_ind3D(:);
    m = [3.25;100.0;22.0;50.0;135.0;108.0;33.75;33.75;2.5;6.0;0.56]; % A, a, B, b, C1, C2, C3, C4, e0, v0, r
    P = eye(N);
    spatial_potentials = L(:,s_ind3D)*self.reconstruction(s_ind3D,:);
    % as the JR parameters are constant, there is no need to start UKF
    % tracking until the time serie is propely into developement (a time save)
    t0 = find(sum(abs(spatial_potentials))>0.5*max(sum(abs(spatial_potentials))),1);
    peaking_time = peaking_times(k);
    for t = t0:self.number_of_frames
        y = spatial_potentials(:,t); % Use back-projection as "observations" to avoid interference from other clusters. SKF is proved to be good so this is justified.
        sqrtP = sqrtm(P);
        % compute sigma-points:
        X0 = m;
        Xp = m + self.alpha*sqrt(N+self.kappa)*sqrtP;
        Xm = m - self.alpha*sqrt(N+self.kappa)*sqrtP;
        X = [X0,Xp,Xm];
        
        X_hat = X; % [PROBLEM]: Could there be evolution related function as X_hat = F(X)?

        % compute predictive mean and covariance
        m = X_hat*Wmean;
        P = zeros(size(P));
        for j = 1:length(Wcov)
            P = P + Wcov(j)*(X_hat(:,j)-m)*(X_hat(:,j)-m)';
        end
        P = P + Q;
        sqrtP = sqrtm(P);

        %Update
        X0 = m;
        Xp = m + self.alpha*sqrt(N+self.kappa)*sqrtP;
        Xm = m - self.alpha*sqrt(N+self.kappa)*sqrtP;
        X = [X0,Xp,Xm];

        % compute the non-linear time evolutions with JR model for
        % estimated parameters
        f = JR_model([X;repelem(peaking_time,1,size(X,2))],1.2*self.number_of_frames/self.sampling_frequency,self.sampling_frequency);
        f(isnan(f)) = 0;    % zeros are mapped to NaNs
        f=f(:,t0:t);    % snip the extra time points off, which are necessary if the time series is ending to partial spike, e.g., ends to peak time point
        [Y,contribution_vec] = obs(f,s_ind3D,L,y);    % contribution vector gives the proportions of each spatial and orientational entry

        % compute predicted observation statistics:
        mu = Y*Wmean;
        S = zeros(size(Y,1));
        C = zeros(size(X,1),size(Y,1));
        for j = 1:length(Wcov)
            S = S + Wcov(j)*(Y(:,j)-mu)*(Y(:,j)-mu)';
            C = C + Wcov(j)*(X(:,j)-m)*(Y(:,j)-mu)';
        end
        S = S + self.noise_cov;
        
        % Compute the Kalman gain
        K = C / S;
        if sum(isnan(K(:)))>0
            error('Predicted observation covariances did not converge properly.')
        end
                
                

        % Update the state estimate
        m = m + K * (y - mu);

        % Update the posterior covariance
        P = P - K*S*K';
    end
    % Compute the next partial reconstruction
    f = JR_model([m;peaking_time],1.2*self.number_of_frames/self.sampling_frequency,self.sampling_frequency);
    f(isnan(f)) = 0;
    f=f(1:self.number_of_frames);
    z_vec(s_ind3D,:) = contribution_vec.*f;
    time_series(k,:) = f;
end
warning('on')
self.modified_L=[];
end

function [sequence] = JR_model(params,T,sampling_frequency)

% Pulse function that initiate the sequence
for k = 1:size(params,2)
pfun = @(t) (t>=params(end,k) & t<params(end,k) + 0.05)*220;
% time grid (solver will adapt, but we use this for output interpolation)
    tspan = [0, T];

    % Initial state (can be zeros or small random values)
    X0 = zeros(6,1);

    % Choose solver (JR is usually fine with ode45; use ode15s if stiff)
    opts = odeset('RelTol',1e-6,'AbsTol',1e-8);
    odefun = @(t,x) jr_ode(t,x,params(:,k),pfun);

    [t, X] = ode45(odefun, tspan, X0, opts);

    % Outputs commonly used as "EEG-like" signals
    V_pyr = X(:,1);               % pyramidal PSP (y0)
    V_net = X(:,3) - X(:,5);      % net pyramidal input (y1 - y2)

    t_span = 0:(1/sampling_frequency):T; % the time span of the activity when 
%first, find the peak (it is always positive)
[~,tind_max] = max(V_net);
    % convert the peak inndex to peak time
    peak_t = t(tind_max);
    %  do the time translation to set the peaking times accordingly
    % In addition, we use interpolation to bring every solution to the
    % linear time scale dictated by the sampling rate.
    % This is because the time "out(k).t" is non-linear and non-smooth due
    % to ode45
    
    if tind_max < length(t)
    sequence(k,:) = interp1(t+params(end,k)-peak_t,V_net,t_span); %Did not
    %work as the time points did not overlap
    else
        sequence(k,:) = interp1(t,V_net,t_span); 
    end
end

% Helper: nested ODE
    function dx = jr_ode(t, x, params, pfun_)

        % Unpack states
        y0 = x(1);  y3 = x(2);        % pyramidal
        y1 = x(3);  y4 = x(4);        % excitatory interneuron
        y2 = x(5);  y5 = x(6);        % inhibitory  interneuron

        % Firing rates via sigmoid (potential -> rate), PRO in PyRates
        %S_y0 = S(P, y0);
        %S_y1 = S(P, y1);
        %S_y2 = S(P, y2);

        % External drive (to excitatory interneurons), units: [s^-1]
        p = pfun_(t);

        % Second-order PSP ODEs (written as 2 x first-order each)
        % Pyramidal population:
        %   y0'' = A*a * S(y1 - y2) - 2*a*y0' - a^2 * y0
        % Excitatory interneurons:
        %   y1'' = A*a * (p + C2*S(C1*y0)) - 2*a*y1' - a^2 * y1
        % Inhibitory interneurons:
        %   y2'' = B*b * (C4*S(C3*y0))    - 2*b*y2' - b^2 * y2

        S_y1_minus_y2 = Sigm(params, y1 - y2);
        S_C1y0 = Sigm(params, params(5) * y0);
        S_C3y0 = Sigm(params, params(7) * y0);

        dy0 = y3;
        dy3 = params(1)*params(2) * S_y1_minus_y2 - 2*params(2)*y3 - (params(2)^2)*y0;

        dy1 = y4;
        dy4 = params(1)*params(2) * (p + params(6)*S_C1y0) - 2*params(2)*y4 - (params(2)^2)*y1;

        dy2 = y5;
        dy5 = params(3)*params(4) * (params(8)*S_C3y0)    - 2*params(4)*y5 - (params(4)^2)*y2;

        dx = [dy0; dy3; dy1; dy4; dy2; dy5];
    end

end



function [Y,contribution_vec] = obs(time_sequence,s_ind3D,L,data)
M = L(:,s_ind3D);
n_interp = round(length(s_ind3D)/3);
contribution_vec = zeros(length(s_ind3D),size(data,2));
for n = 1:n_interp
    ind = 3*n-[2,1,0];
    contribution_vec(ind,:) = pinv(M(:,ind))*data;
end
z = reshape(sqrt(sum(reshape(contribution_vec.^2,3,[]))),n_interp,[]);
contribution_vec = contribution_vec./max(z);
Y = (M*contribution_vec).*transpose(time_sequence(:,end));
if sum(isnan(Y(:))) > 0
    error('Error in JR modeled sequence or lead field, e.g., elements with exactly zero value.')
end
end

function s = Sigm(Params, V)
    % Sigmoid PRO (potential-to-rate), as used in PyRates templates:
    % m_out = m_max / (1 + exp(r*(v0 - V))); we set m_max = 2*e0
    s = (2*Params(9,:)) ./ (1 + exp(Params(11,:) .* (Params(10,:) - V)));
end

function [peaking_times,cluster_order] = estimate_peaks(reconstruction,t,num_of_clusters,clusters_ind,cluster_id)
%n = round(size(reconstruction,1)/3);
dt = mean(diff(t));
%reconstruction = reshape(sqrt(sum(reshape(reconstruction.^2,3,[]))),n,[]);  %n x T

%compute clustered time series
clustered_recs = nan(num_of_clusters+1,size(reconstruction,2));
for k = 1:num_of_clusters
    if sum(clusters_ind==cluster_id(k)) > 0
    clustered_recs(k,:) = mean(reconstruction(clusters_ind==cluster_id(k),:),1);
    end
end  
clustered_recs(isnan(clustered_recs(:,1)),:) = [];
%Use mean estimate of time_series:
reconstruction = mean(reconstruction,1);
T = length(reconstruction);

%remove the most insignificant points so that the time array is dividable
%by num_of_clusters:
r = rem(T,num_of_clusters);
if r > 0
[~,ind] = mink(abs(reconstruction),r);
reconstruction(ind)=[];
t(ind)=[];
end
T = length(t);
Tsub = T/num_of_clusters;

% estimate the spikes' peak time points by using average of the three highest
% values of the time series at each time windows (k-1)*Tsub+1:k*Tsub.
% if the maximum is at the time point k*Tsub, the peak appear somewhere
% later, so we extend the window by 10 %: (k+0.1)*Tsub or k*Tsub+1 -- which
% one is larger. 
% [PROBLEM]: Could be improved
w_mean = zeros(1,num_of_clusters);
for k = 1:num_of_clusters
    t_end = t(k*Tsub);
    ind_end = k*Tsub;
    w_prev = t(end);
    while (w_mean(k) == 0 || w_mean(k) >= t_end || w_mean(k) <= w_mean(max(k-1,double(k==1)))) && t_end < t(end) && abs(w_prev-w_mean(k)) > dt
        w_prev = w_mean(k);
        ind = ((k-1)*Tsub + 1):ind_end;
        [~,p_ind] = maxk(reconstruction(ind),3);
        w_mean(k) = sum(reconstruction(ind(p_ind)).*t(ind(p_ind)))/sum(reconstruction(ind(p_ind)));

        ind_end = min(max(floor(ind_end+0.1*Tsub),ind_end+1),length(t));
        t_end = t(ind_end);
    end
    if k == num_of_clusters && w_mean(k)==0
        w_mean(k) = t(end);
    end
end

peaking_times = zeros(1,num_of_clusters);
cluster_order = zeros(3,num_of_clusters);   %we think that to choose from three is enought to find unique order
cluster_val = cluster_order;
for k = 1:num_of_clusters
    [~,ind] = min(abs(t-w_mean(k)));
    ind = max(ind-2,1):min(ind+2,T);
    [~,ind2] = max(abs(reconstruction(ind)));
    peaking_times(k) = t(ind(ind2));
    [val,ind] = maxk(clustered_recs(:,ind(ind2)),min(3,size(clustered_recs,1)));
    cluster_order(:,k) = ind;
    cluster_val(:,k) = val;
end

% set the alternative order if there happens to be dublicate explanators in
% the primary order list "cluster_order(1,:)"
% [PROBLEM]: Could be improved
[~,idx,idc] = unique(cluster_order(1,:));
if length(idx) == num_of_clusters
    cluster_order = cluster_order(1,:);
else
    j = 1;
    while length(idx) ~= num_of_clusters && j < 3
        j = j+1;
    [count,~,idxc] = histcounts(idc,numel(idx));
    non_unique_order = cluster_order(1,count(idxc)>1);
    flavor = unique(non_unique_order);
    for n = 1:length(flavor)
        %indices of the dublicates with equal value
        ind = find(cluster_order(1,:) == flavor(n));
        %the one with largest value is assumed to be correct
        [~,m_ind] = max(cluster_val(1,ind));
        m_ind = setdiff(ind,ind(m_ind));
        % set jth best cluster to explain the spikes with dublicates
        cluster_order(1,m_ind)=cluster_order(j,m_ind);
    end
    end
    cluster_order = cluster_order(1,:);
end

end