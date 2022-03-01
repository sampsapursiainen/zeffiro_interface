function [name_cell, variable_cell] = zef_get_profile_parameters(varargin)

parameter_index = [];
if not(isempty(varargin))
    parameter_index = varargin{1};
end

parameter_profile = evalin('base','zef.parameter_profile');

zef_n = 0;
for zef_k =  1  : size(parameter_profile,1)
     if isequal(parameter_profile{zef_k,8},'Segmentation') && isequal(parameter_profile{zef_k,6},'On') && isequal(parameter_profile{zef_k,3},'Scalar')
  zef_n = zef_n + 1;
     name_cell{zef_n} = parameter_profile{zef_k,1};
    variable_cell{zef_n} = ['zef.' parameter_profile{zef_k,2}];
    end
end

if not(isempty(parameter_index))
name_cell = name_cell{parameter_index};
variable_cell = variable_cell{parameter_index};
end

end