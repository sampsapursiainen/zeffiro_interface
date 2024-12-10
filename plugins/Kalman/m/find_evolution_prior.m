function [q] = find_evolution_prior(L, theta0, number_of_frames, evolution_prior_db)

% q to evolution prior
q = (1./number_of_frames)*10^(evolution_prior_db/20) * theta0;

end

