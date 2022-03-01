%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface

% These are parameters from the initialization file.

if isfield(zef_data,'matlab_release')
zef_data = rmfield(zef_data,'matlab_release');
end

if isfield(zef_data,'code_path')
zef_data = rmfield(zef_data,'code_path');
end

if isfield(zef_data,'program_path')
zef_data = rmfield(zef_data,'program_path');
end

zef.ini_cell = readcell([zef.program_path '/profile/zeffiro_interface.ini'],'FileType','text');
for zef_i = 1 : size(zef.ini_cell,1)
evalin('base',['zef_data = rmfield(zef_data''' zef.ini_cell{zef_i,3} ''');']);
end
zef = rmfield(zef,'ini_cell');

% Other version specific parameters.
if isfield(zef_data,'imaging_method_cell')
zef_data = rmfield(zef_data,'imaging_method_cell');
end
