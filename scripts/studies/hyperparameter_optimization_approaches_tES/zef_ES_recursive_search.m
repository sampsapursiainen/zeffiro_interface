function zef = zef_ES_recursive_search(zef, num_lattice)
zef.ES_step_size = num_lattice;
zef_ES_find_currents;
adapted_y_ES{1} = zef.y_ES_interval;
original_window = zef.ES_step_size;
adapt_instances = zef.ES_step_size; % M = Number of adaptive instances
adapt_window    = 40;               % K = Size of the adaptive window
[alpha, epsilon] = zef_ES_find_parameters(zef, original_window);

s_alpha  =  (min(alpha)/max(alpha))^((adapt_window-1)/(adapt_window*adapt_instances));
s_epsilon=  (min(epsilon)/max(epsilon))^((adapt_window-1)/(adapt_window*adapt_instances));

for adapt_instances_ind = 2:adapt_instances
    [sr, sc] = zef_ES_objective_function(zef);
    
    [alpha_psi, epsilon_psi] = zef_ES_centralize_recursive_search(alpha, epsilon, sr, sc, original_window, s_alpha, s_epsilon, 0);
    
    zef_ES_find_currents(zef, alpha_psi, epsilon_psi, original_window)
    adapted_y_ES{adapt_instances_ind} = zef.y_ES_interval;
    
    alpha = alpha_psi;
    epsilon = epsilon_psi;
end

zef.adapted_y_ES = adapted_y_ES;
end