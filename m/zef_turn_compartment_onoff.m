function [zef] = zef_turn_compartment_onoff(zef,compartment_onoff_vec)

c_t = zef.compartment_tags;
n_c_t = length(c_t);

% if isempty(compartment_onoff_vec)
    compartment_onoff_vec = ones(1,n_c_t);
% end

for i = 1 : n_c_t

    zef.([c_t{i} '_on']) = compartment_onoff_vec(i);

end

end
