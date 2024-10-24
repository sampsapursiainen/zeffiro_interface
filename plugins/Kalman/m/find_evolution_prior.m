function [q] = find_evolution_prior(L, theta0, time_step, evolution_prior_db)

% q to evolution prior
% db(q/time_step/(svds(L,1)^2 * theta0))

%q = time_step*svds(L,1).^(2)*10^(evolution_prior_db/20) * sqrt(theta0);
q = time_step*10^(evolution_prior_db/20) * theta0;

end

