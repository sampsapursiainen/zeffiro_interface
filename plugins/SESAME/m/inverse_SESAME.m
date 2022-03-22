function [result] = inverse_SESAME(full_data, leadfield, sourcespace, cfg)

% inverse_SESAME samples the posterior distribution of a
% multi-dipole Bayesian model and provides an estimate of the number of
% dipoles and of the dipole locations and time courses; in addition, it
% provides uncertainty quantification in terms of a posterior probability
% map. Dipoles are assumed to have fixed location during the analyzed time
% window.
%
%
% Use as
%  posterior = inverse_SESAME(data, leadfield, sourcespace, cfg)
%
% where
%  data        = data matrix,
%                 number of sensors X number of time points
%  leadfield   = leadfield matrix,
%                  number of sensors X ncomp*number of points in the source space
%                   where ncomp is 3 for free orientation, 1 for strictly
%                   constrained orientation
%  sourcespace = coordinates of points in source space,
%                 number of points in the source space X 3
% and
%  posterior   = structure containing the estimated source parameters, a
%                 posterior probability map and all the Monte Carlo samples
%
%  relevant fields of posterior:
%
%         mod_sel = model selection function (in fact, a collection of)
%                   a 2D array
%                   max number of dipoles X number of iterations;
%                   at a selected iteration, it provides the posterior distribution over
%                     the number of dipoles
%                   default use:
%                   - fix the second index to the last iteration (posterior.final_it)
%                   - take the argmax of the resulting array as an estimate of the
%                       number of dipoles
%
%
%         pmap	= posterior probability map (in fact, a collection of)
%                 a 3D array
%                 number of source points  X number of iterations X max number of dipoles;
%                 default use:
%                 - set the second index to the last iteration (posterior.final_it)
%                 - set the third index to the estimated number of dipoles
%                 - plot the resulting array as a color-coded posterior map
%                   on the set of vertices
%
%         estimated_dipoles = vertex indices of estimated dipoles in the source space
%
%         est_dip = all estimated dipoles *across all iterations*
%                   a 2D array
%                   number of ALL estimated dipoles X 5
%                   in every line we have one estimated dipole as follows:
%                   x location, y location, z location, iteration number, vertex index
%
%
%         Q_estimated = source amplitudes (positive scalar) of estimated dipoles
%                       a 2D array
%                       number of estimated dipoles X number of time points
%
%         QV_estimated = estimated vector dipole moments across time
%                        a 2D array
%                        ncomp*number of estimated dipoles X number of time points
%
%         MCsamples = all Monte Carlo samples, at all iterations
%                     stored for any other type of inference
%
%         AllWeights = all weights of the corresponding Monte Carlo samples

%
% optional input, passed as field inside cfg:
%
%  noise_std  = noise standard deviation
%  dipmom_std = expected strength of dipole moment (formally: standard
%               deviation of Gaussian prior on dipole moment components)
%  n_samples  = number of Monte Carlo samples (default: 100)
%  t_start  = first time point of analyzed window
%  t_stop   = last time point of analyzed window
%
%
%  The algorithm contained in this file is described in
%  Sommariva S and Sorrentino A
%  Sequential Monte Carlo samplers for semi-linear inverse problems and
%  application to Magnetoencephalography
%  Inverse Problems (2014)

% Copyright (C) 2019 Gianvittorio Luria, Sara Sommariva, Alberto Sorrentino

noise_std = [];
dipmom_std = [];
n_samples = [];
neighbours = [];
neighboursp = [];
t_start = [];
t_stop = [];

if isfield(cfg,'noise_std')
  noise_std = cfg.noise_std;
end
if isfield(cfg,'dipmom_std')
  dipmom_std = cfg.dipmom_std;
end
if isfield(cfg,'n_samples')
  n_samples = cfg.n_samples;
end
if isfield(cfg,'neighbours')
  neighbours = cfg.neighbours;
end
if isfield(cfg,'neighboursp')
  neighboursp = cfg.neighboursp;
end
if isfield(cfg,'t_start')
  t_start = cfg.t_start;
end
if isfield(cfg,'t_stop')
  t_stop = cfg.t_stop;
end

data = full_data;

if isempty(noise_std)
  noise_std = 0.1 * max(max(abs(data)))*sqrt(cfg.t_stop-cfg.t_start+1);
  disp(strcat(['Noise std set automatically to: ', num2str(noise_std)]));
end
if isempty(dipmom_std)
  dipmom_std = 15*max(max(abs(data)))/max(max(abs(leadfield)));
  disp(strcat(['Dipmom std set automatically to: ', num2str(dipmom_std)]));
end
if isempty(n_samples)
  n_samples = 100;
end
if isempty(t_start)
  t_start = 1;
end
if isempty(t_stop)
  t_stop = size(full_data,2);
end

if (size(full_data,2)>1)
  data = full_data(:, t_start:t_stop);
end

% pre-compute factorials
fact=zeros(1,40);
for i = 1:40
  fact(i) = factorial(i);
end

V = sourcespace;

% if there are no neighbours/neighbour probabilities, those are computed
% here:

if isempty(neighbours)
  radius = 1.5 * ((max(V(:,1))-min(V(:,1))) * (max(V(:,2))-min(V(:,2))) * (max(V(:,3))-min(V(:,3)))/ size(V,1) ) ^(1/3) ;
  neighbours = compute_neighbours(V, radius);
  disp(strcat(['neighbours matrix computed, max neighbours ', ...
    num2str(size(neighbours,2))]));
  neighboursp = compute_neigh_prob(V, neighbours, radius);
end
if isempty(neighboursp)
  radius = 1.5 * ((max(V(:,1))-min(V(:,1))) * (max(V(:,2))-min(V(:,2))) * (max(V(:,3))-min(V(:,3)))/ size(V,1) ) ^(1/3) ;
  neighboursp = compute_neigh_prob(V, neighbours, radius);
end

% set parameters
n_ist = size(data, 2);
N = 1000;           % initial max number of iterations, determines array size
C = size(V,1);      % number of voxels
nsens = size(leadfield,1);  % number of sensors
ncomp = size(leadfield,2)/size(sourcespace,1); % 3 if free orientation, 1 if cortically constrained
NDIP = 8;           % maximum number of dipoles
lambda_prior = .25; % mean of the Poisson prior
mean_Qin = zeros(3,1); % mean of the Gaussian prior on the dipole moment
cov_Qin = dipmom_std^2 * eye(3); % covariance of Gaussian prior on the dipole moment
cov_noise = noise_std^2 * eye(nsens); % covariance of the likelihood function
delta_min = 1/100000; delta_max = 1/10; % min/max increment of the exponent in a single iteration
gamma_high = 0.99; gamma_low = 0.9; % acceptable interval for the drop in the Effective Sample Size
Q_birth = 1/3; Q_death = 1/20; % probability of proposing a birth/death

exponent_likelihood(1) = 0;
exponent_likelihood(2) = 0;

% define structures
for j = 1:NDIP
  dipole(j) = struct('c', 0, 'qmean', zeros(3,1), 'qvar', zeros(3));
end
for i = 1:n_samples
  particle(i) = struct('nu',0,'dipole',dipole, 'prior', 1, 'log_like', 0, 'like_det',1);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%% Sampling from the prior %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
weights = zeros(1,n_samples);
AllWeights = zeros(N, n_samples);
log_update = weights;
n = 1;
for i = 1:n_samples
  ndip = poissrnd(lambda_prior);
  for r = 1:ndip
    particle(i) = add_dipole_location(particle(i), C);
    particle(i).dipole(r).qmean = mean_Qin;
    particle(i).dipole(r).qvar = cov_Qin;
  end

  particle(i) = prior_and_like(particle(i), leadfield, data, lambda_prior, dipmom_std, nsens, ncomp, fact, noise_std, n_ist);
  if isinf(particle(i).log_like)
    disp('Problem');
  end
  % the two following lines are currently useless because exponent_likelihood(2) = exponent_likelihood(1) = 0
  % we just let them here in case we decide to modify these values
  weights(i) = 1/sqrt(particle(i).like_det)^(n_ist*exponent_likelihood(1)) * exp(particle(i).log_like)^(exponent_likelihood(1)/(2*noise_std^2));
  log_update(i) = -0.5*n_ist*(exponent_likelihood(2)-exponent_likelihood(1))*log(particle(i).like_det)-...
    ((exponent_likelihood(2)-exponent_likelihood(1))/(2*noise_std^2))*particle(i).log_like;
end

weights = weights ./ sum(weights);

pmap = zeros(size(V,1), N, NDIP);
mod_sel = zeros(NDIP,N);
est_dip = [];
estimated_dipoles = [];
Q_estimated = [];
QV_estimated = [];
kkk = 1;
for i = 1:n_samples
  mod_sel(particle(i).nu+1,n) = mod_sel(particle(i).nu+1,n) + weights(i);
  if particle(i).nu <=NDIP
    for r = 1:particle(i).nu
      pmap(particle(i).dipole(r).c, n, particle(i).nu) =  pmap(particle(i).dipole(r).c, n, particle(i).nu) + weights(i);
    end
  end
end

tic
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%% Main cycle %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
n = 2;
resampling_done = zeros(1,N);
while exponent_likelihood(n) <= 1
  if n>3
    disp('----------------------------------------------------------------')
    disp(strcat(['Iteration ', num2str(n), ...
      ' (Expected: ', ...
      num2str(ceil((-log(exponent_likelihood(3)))/...
      (log(exponent_likelihood(n)) - log(exponent_likelihood(3))) * n )),')',...
      ' -- Exponent = ', num2str(exponent_likelihood(n))]))
  end
  [max_weight, ind_max_weight] = max(weights);
  best_particle(n-1) = particle(ind_max_weight);
  log_weight_unnorm = log(weights) + log_update;
  w = max(log_weight_unnorm);
  log_cost_norm = w + log(sum(exp(log_weight_unnorm - w)));
  weight_resampling = exp(log_weight_unnorm - log_cost_norm);
  if max(isinf(log_weight_unnorm-log_cost_norm)==1)
    disp('warning: some weigths are inf');
  end
  if min(weight_resampling)==0
    disp('warning: some weights are zero');
  end
  ESS(n) = (sum(weight_resampling.^2))^-1;
  if isnan(ESS(n))
    disp('Got a NaN in the effective sample size: try setting a larger ''noise_std'' or a smaller ''dipmom_std''');
  end
  % Resample particles if ESS too low
  if ESS(n) < n_samples/2
    disp(' ---------- ');
    disp('Resampling');
    disp(' ---------- ');
    resampling_done(n) = 1;
    ESS(n) = n_samples;
    partition_weights = cumsum(weight_resampling);
    partition_weights(n_samples+1) = 1;
    partition_uniform = zeros(1,n_samples);
    partition_uniform(1) = 1/n_samples * rand;
    particle_auxiliary = particle;
    for j = 1:n_samples
      partition_uniform(j) = partition_uniform(1) + (j-1)/n_samples;
      stepbystep = 1;
      while partition_uniform(j) >= partition_weights(stepbystep)
        stepbystep = stepbystep + 1;
      end
      if stepbystep == n_samples+1;
        particle(j) = particle_auxiliary(n_samples);
      else
        particle(j) = particle_auxiliary(stepbystep);
      end
    end
    for i = 1:n_samples
      weights(i) = 1/n_samples;
    end
  else
    log_weight_unnorm = log(weights)+log_update;
    w = max(log_weight_unnorm);
    log_cost_norm = w + log(sum(exp(log_weight_unnorm-w)));
    weights = exp(log_weight_unnorm-log_cost_norm);
  end
  AllWeights(n,:) = weights;
  % MCMC step
  for i = 1:n_samples
    particle_proposed = particle(i);

    % Add/Remove dipole (RJ step)
    BirthOrDeath = rand;
    if BirthOrDeath < Q_birth && particle_proposed.nu < NDIP
      particle_proposed = add_dipole_location(particle_proposed, C);
      r = particle_proposed.nu;
      particle_proposed.dipole(r).qmean = mean_Qin;
      particle_proposed.dipole(r).qvar = cov_Qin;
    elseif BirthOrDeath > 1-Q_death
      [DipoleDying, particle_proposed] = remove_dipole(particle_proposed);
    end

    if particle_proposed.nu ~= particle(i).nu
      particle_proposed = prior_and_like(particle_proposed, leadfield, data, lambda_prior, dipmom_std, nsens, ncomp, fact, noise_std, n_ist);
      log_rapp_like = 0.5*exponent_likelihood(n)*n_ist*(log(particle(i).like_det)-log(particle_proposed.like_det))+...
        (exponent_likelihood(n)/(2*noise_std^2))*(particle(i).log_like-particle_proposed.log_like);
      rapp_like = exp(log_rapp_like);
      if particle_proposed.nu > particle(i).nu
        alpha = ((particle_proposed.prior*Q_death)/(particle(i).prior*Q_birth))*rapp_like;
      else
        alpha = ((particle_proposed.prior*Q_birth)/(particle(i).prior*Q_death))*rapp_like;
      end
      alpha = min([1,alpha]);
      if rand < alpha
        particle(i) = particle_proposed;
      end
      particle_proposed = particle(i);
    end

    % Update dipole locations, starting from the last one
    for r = particle_proposed.nu:-1:1
      n_neighbours = length(find(neighbours(particle_proposed.dipole(r).c,:)>0));
      is_location_new = 0;
      while is_location_new == 0
        randnum = rand;
        indP = 1;
        while randnum > sum(neighboursp(particle_proposed.dipole(r).c,1:indP)) && indP < n_neighbours
          indP = indP + 1;
        end
        location_proposed = neighbours(particle_proposed.dipole(r).c,indP);
        is_location_new = 1;
        for k = [particle_proposed.nu:-1:r+1, r-1:-1:1]
          if location_proposed == particle_proposed.dipole(k).c
            is_location_new = 0;
          end
        end
      end
      prob_move = neighboursp(particle_proposed.dipole(r).c,indP);
      n_neighbours = length(find(neighboursp(location_proposed,:)>0));
      indP = 1;
      while particle_proposed.dipole(r).c ~= neighbours(location_proposed,indP) && indP < n_neighbours
        indP = indP + 1;
      end
      prob_move_reverse = neighboursp(location_proposed, indP);
      particle_proposed.dipole(r).c = location_proposed;
      particle_proposed = prior_and_like(particle_proposed, leadfield, data, lambda_prior, dipmom_std, nsens, ncomp, fact, noise_std, n_ist);
      log_rapp_like = 0.5*exponent_likelihood(n)*n_ist*(log(particle(i).like_det)-log(particle_proposed.like_det))+...
        (exponent_likelihood(n)/(2*noise_std^2))*(particle(i).log_like-particle_proposed.log_like);
      rapp_like = exp(log_rapp_like);
      alpha = rapp_like*((particle_proposed.prior*prob_move_reverse) / (particle(i).prior*prob_move));
      alpha = min([1,alpha]);
      if rand < alpha
        particle(i) = particle_proposed;
      end
    end
  end

  % on-line estimates
  for i = 1:n_samples
    mod_sel(particle(i).nu+1,n) = mod_sel(particle(i).nu+1,n) + weights(i);
    if particle(i).nu <=NDIP
      for r = 1:particle(i).nu
        pmap(particle(i).dipole(r).c,n, particle(i).nu) =  pmap(particle(i).dipole(r).c,n, particle(i).nu) + weights(i);
      end
    end
  end
  [max_mod, ind_mod] = max(mod_sel(:,n));
  disp(strcat(['Estimated number of dipoles: ', num2str(ind_mod-1)]))
  [~, eee] = point_estimation(particle, weights, V, NDIP);
  for i = 1:numel(eee)
    est_dip(kkk,:) = [V(eee(i),:) n eee(i)];
    kkk=kkk+1;
    disp(strcat(['Estimated location of dipole ', num2str(i), ': vertex number ' num2str(eee(i))]));
  end
  MCsamples{n}.all_particles = particle;

  % Adaptive choice of the next exponent
  is_last_operation_increment = 0;
  if exponent_likelihood(n) == 1
    exponent_likelihood(n+1) = 1.01;
  else
    delta_a = delta_min;
    delta_b = delta_max;
    delta(n+1) = delta_max;
    exponent_likelihood(n+1) = exponent_likelihood(n) + delta(n+1);
    log_ESS(n+1) = -Inf;
    iterations = 1;
    while (log_ESS(n+1) - log(ESS(n))) > log(gamma_high) || (log_ESS(n+1) - log(ESS(n))) < log(gamma_low)
      for i=1:n_samples
        if n < N
          log_update(i) = -0.5*n_ist*(exponent_likelihood(n+1)-exponent_likelihood(n))*log(particle(i).like_det)-...
            ((exponent_likelihood(n+1)-exponent_likelihood(n))/(2*noise_std^2))*particle(i).log_like;
        end
      end
      log_weight_unnorm = log(weights) + log_update;
      w = max(log_weight_unnorm);
      log_cost_norm = w + log(sum(exp(log_weight_unnorm - w)));
      log_weight_aux = log_weight_unnorm - log_cost_norm;
      if max(isinf(log_weight_unnorm - log_cost_norm))==1
        disp('log inf within bisection');
      end
      W = max(log_weight_aux);
      log_ESS(n+1) = -2*W - log( sum( exp( 2*(log_weight_aux - W) ) ) );
      if log_ESS(n+1) - log(ESS(n)) > log(gamma_high)
        delta_a = delta(n+1);
        delta(n+1) = min([(delta_a+delta_b)/2 delta_max]);
        is_last_operation_increment = 1;
        if (delta_max-delta(n+1)) < delta_max/100
          exponent_likelihood(n+1) = exponent_likelihood(n) + delta(n+1);
          for i=1:n_samples
            if n < N
              log_update(i) = -0.5*n_ist*(exponent_likelihood(n+1)-exponent_likelihood(n))*log(particle(i).like_det)-...
                ((exponent_likelihood(n+1)-exponent_likelihood(n))/(2*noise_std^2))*particle(i).log_like;
            end
          end
          if exponent_likelihood(n+1)>=1
            exponent_likelihood(n+1) = 1;
            log_ESS(n+1) = log(ESS(n)) + log( (gamma_high+gamma_low)/2 );
          end
          break;
        end
      elseif log_ESS(n+1) - log(ESS(n)) < log(gamma_low)
        delta_b = delta(n+1);
        delta(n+1) = max([(delta_a+delta_b)/2 delta_min]);
        if (delta(n+1)-delta_min)<delta_min/10 ||(iterations>1 && is_last_operation_increment)
          exponent_likelihood(n+1) = exponent_likelihood(n) + delta(n+1);
          for i=1:n_samples
            if n < N
              log_update(i) = -0.5*n_ist*(exponent_likelihood(n+1)-exponent_likelihood(n))*log(particle(i).like_det)-...
                ((exponent_likelihood(n+1)-exponent_likelihood(n))/(2*noise_std^2))*particle(i).log_like;
            end
          end
          if exponent_likelihood(n+1)>=1
            exponent_likelihood(n+1) = 1;
            log_ESS(n+1) = log(ESS(n)) + log((gamma_high+gamma_low)/2);
          end
          break;
        end
        is_last_operation_increment = 0;
      end
      exponent_likelihood(n+1) = exponent_likelihood(n) + delta(n+1);
      if exponent_likelihood(n+1)>=1
        exponent_likelihood(n+1) = 1;
        log_ESS(n+1) = log(ESS(n)) + log((gamma_high+gamma_low)/2);
      end
      iterations = iterations+1;
    end
  end
  n = n + 1;
end
n = n-1;

% Final estimates:
% Estimating dipole moments
if numel(est_dip)>0
  estimated_dipoles = est_dip(find(est_dip(:,4)==n),5);
  G_r = zeros(nsens,ncomp*numel(estimated_dipoles));
  for kk = 1:numel(estimated_dipoles)
    G_r(:,ncomp*(kk-1)+1:ncomp*kk) = leadfield(:,ncomp*(estimated_dipoles(kk)-1)+1:ncomp*estimated_dipoles(kk));
  end
  cov_Qincomplex = dipmom_std^2 * eye(ncomp*numel(estimated_dipoles));
  K_matrix = cov_Qincomplex * G_r' * inv(G_r * cov_Qincomplex * G_r' + cov_noise);
  for t = 1:n_ist
    qmean_comp = K_matrix * data(:,t);
    qvar_complex = (eye(ncomp*numel(estimated_dipoles)) - K_matrix * G_r) * cov_Qincomplex;
    for kk = 1:numel(estimated_dipoles)
      Q_estimated(kk,t) = norm(qmean_comp(ncomp*(kk-1)+1:ncomp*kk));
      QV_estimated(ncomp*(kk-1)+1:ncomp*kk,t) = qmean_comp(ncomp*(kk-1)+1:ncomp*kk);
    end
  end
end
[max_weight, ind_max_weight] = max(weights);
best_particle(N) = particle(ind_max_weight);

% output relevant data:

% input parameters:

result.Q_birth = Q_birth;
result.Q_death = Q_death;
result.dipmom_std = dipmom_std;
result.noise_std = noise_std;
result.n_samples = n_samples;

result.t_start = t_start;
result.t_stop = t_stop;
result.data = full_data;

result.sourcespace = sourcespace;
result.neighbours = neighbours;
result.neighboursp = neighboursp;

% actual results:
result.pmap = pmap(1:size(V,1),1:n,1:NDIP);
result.mod_sel = mod_sel(:,1:n);
result.estimated_dipoles = estimated_dipoles;
result.Q_estimated = Q_estimated;
result.MCsamples = MCsamples;
result.AllWeights = AllWeights(1:n,:);
result.est_dip = est_dip;
result.QV_estimated = QV_estimated;

% algorithm diagnostics
result.final_it = n;
result.exponent_likelihood = exponent_likelihood;
result.resampling_done = resampling_done(1:n);
result.ESS = ESS;
result.best_particle = best_particle;
result.TODAY = date;
toc
end

function particle = add_dipole_location(particle, Nvert)
particle.nu = particle.nu+1;
r = particle.nu;
is_location_new = 0;
while is_location_new == 0
  location_proposed = randi(Nvert);
  is_location_new = 1;
  for k = 1:r-1
    if location_proposed == particle.dipole(k).c
      is_location_new = 0;
    end
  end
end
particle.dipole(r).c = location_proposed;
end

function [est_num, est_c] = point_estimation(particles, weigths, V, NDIP)
n_samples = length(weigths);
mod_sel = zeros(NDIP*10, 1);
for i = 1:n_samples
  mod_sel(particles(i).nu+1) = mod_sel(particles(i).nu+1) + weigths(i);
end
[~, est_num] = max(mod_sel);
est_num = est_num - 1;
if est_num > NDIP
  warning('Estimated number of dipoles higher than the allowed one.')
end
if est_num == 0
  est_c = [];
else
  N_sel_part = 0;
  for i = 1:n_samples
    if particles(i).nu == est_num
      N_sel_part = N_sel_part + 1;
      sel_particles(N_sel_part) = i;
    end
  end
  particles = particles(sel_particles);
  weigths = weigths(sel_particles);
  dipoles = zeros(N_sel_part, est_num);
  for i_part = 1:N_sel_part
    for j_dip = 1:est_num
      dipoles(i_part,j_dip) = particles(i_part).dipole(j_dip).c;
    end
  end
  [~ , max_part] = max(weigths);
  c_max_part = zeros(1, est_num);
  for i_dip = 1:est_num
    c_max_part(i_dip) = particles(max_part).dipole(i_dip).c;
  end
  for i_part = 1:N_sel_part
    c_i = dipoles(i_part,:);
    all_perm = perms(c_i);
    N_perms = factorial(est_num);
    OSPA = zeros(N_perms, 1);
    for i_perm = 1:N_perms
      diff = V(all_perm(i_perm,:),:) - V(c_max_part,:);
      norm_diff = sqrt(sum(diff.^2, 2));
      OSPA(i_perm) = sum(norm_diff)/est_num;
    end
    [~, sel_perm] = min(OSPA);
    dipoles(i_part,:) = all_perm(sel_perm,:);
  end
  pmap_sing_dip = zeros(size(V,1), est_num);
  for i_dip = 1:est_num

    for i_part = 1:N_sel_part
      pmap_sing_dip(dipoles(i_part,i_dip), i_dip) =  pmap_sing_dip(dipoles(i_part,i_dip), i_dip) + weigths(i_part);
    end

  end
  [~, est_c] = max(pmap_sing_dip);
end
end

function [particle] = prior_and_like(particle, leadfield, data, lambda_prior, dipmom_std, nsens, ncomp, fact, noise_std, n_ist)
  particle.prior = 1/fact(particle.nu+1) * exp(-lambda_prior) * lambda_prior^particle.nu;
  G_r = zeros(nsens,ncomp*particle.nu);
  for kk = 1:particle.nu
  G_r(:,ncomp*(kk-1)+1:ncomp*kk) = leadfield(:,ncomp*(particle.dipole(kk).c-1)+1:ncomp*particle.dipole(kk).c);
  end

  cov_likelihood_risc = (dipmom_std/noise_std)^2 *G_r*G_r' + eye(nsens);
  cov_likelihood_risc_inv = inv(cov_likelihood_risc);
  particle.like_det = det(cov_likelihood_risc);
  particle.log_like = 0;
  for t = 1:n_ist
  particle.log_like =  particle.log_like + data(:,t)'*cov_likelihood_risc_inv*data(:,t);
  end
end

function [DipoleDying, particle] = remove_dipole(particle)
if particle.nu >0
  DipoleDying = randi(particle.nu);
  for r = DipoleDying+1:particle.nu
    particle.dipole(r-1) = particle.dipole(r);
  end
  particle.dipole(particle.nu) = struct('c', 0, 'qmean', zeros(3,1), 'qvar', zeros(3));
  particle.nu = particle.nu - 1;
else
  DipoleDying = -1;
end
end

function [ NProb] = compute_neigh_prob(V,neighbours,sigmar)
NProb = zeros(size(neighbours));
for i = 1:size(neighbours,1)
  j = 1;
  while j <= size(neighbours,2) && neighbours(i,j)>0
    NProb(i,j) = exp(-norm(V(i,:) - V(neighbours(i,j),:))^2/sigmar^2);
    j=j+1;
  end
  NProb(i,:) = NProb(i,:)/sum(NProb(i,:));
end
end

function[neighbours]=compute_neighbours(vertices, radius)
neighbours=[];
for i = 1 : size(vertices,1);
   clear aux3
   aux1 = vertices(i,:);
   aux2 = repmat(aux1,size(vertices,1),1);
   diff = vertices-aux2;
   diff = diff.^2;
   somma = sum(diff');
   somma = somma';
   dist = sqrt(somma);
   [dist_riord,ind_riord] = sort(dist,'ascend');
   aux3 = find(dist_riord<radius);
   neighbours(i,1:size(aux3,1)) = ind_riord(aux3)';
end
end
