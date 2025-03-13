function [q] = find_evolution_prior(L, theta0, number_of_frames, evolution_prior_db, prior_over_measurement_db, snr)

% q to evolution prior
q = (1./number_of_frames)*10^(evolution_prior_db/10) * theta0;

end

