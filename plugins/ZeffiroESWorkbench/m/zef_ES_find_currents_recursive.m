function zef = zef_ES_find_currents_recursive(varargin)
switch nargin
case {0,1}
if nargin == 0
zef = evalin('base','zef');
else
zef = varargin{1};
end

% UnFixing Electrodes
zef.h_ES_fixed_active_electrodes.Value = 0;
zef_ES_optimization_update;
zef.ES_active_electrodes    = zef_ES_fix_active_electrodes(zef);

% 1st stage
zef                         = zef_ES_recursive_search(zef, zef.ES_step_size, zef.ES_HPO_recursive_instances);
zef.adapted_y_ES_interval_1 = zef.adapted_y_ES;

% Fixing Electrodes
zef.y_ES_interval           = zef.adapted_y_ES_interval_1{end};

zef.h_ES_fixed_active_electrodes.Value = 1;
zef_ES_optimization_update;
zef.ES_active_electrodes    = zef_ES_fix_active_electrodes(zef);

% 2nd stage
zef.y_ES_interval           = zef.adapted_y_ES_interval_1{1};

zef                         = zef_ES_recursive_search(zef, zef.ES_step_size, zef.ES_HPO_recursive_instances);
zef.adapted_y_ES_interval_2 = zef.adapted_y_ES;


zef = rmfield(zef, 'adapted_y_ES');

if nargout == 0
assignin('caller','zef',zef);
end

end