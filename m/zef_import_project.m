%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
function zef_import_project(file_name, folder_name)

void = [];

if nargin < 2
[file_name folder_name] = uigetfile({'*.zef'},'Project ASCII data file and folder',evalin('base','zef.save_file_path'));
end

if not(isequal(file_name,0));

h_import = fopen([folder_name file_name]);
ini_cell = textscan(h_import,'%s','HeaderLines',22,'Delimiter',',');
n_columns = 3;

compartment_cell = {evalin('base','zef.imaging_method_cell{1}'), evalin('base','zef.imaging_method_cell{2}'), evalin('base','zef.imaging_method_cell{3}'), 'none'};

name_cell = {'d1','d2','d3','d4','d5','d6','d7','d8','d9','d10','d11','d12','d13','d14','d15','d16','d17','d18','d19','d20','d21','d22','w','g','c','sk','sc'};

compartment_count_vec = zeros(length(compartment_cell), 1);

n_project = length(ini_cell{:})/n_columns;

for i = 1 : n_project

if i == 1
h_waitbar = waitbar(1/n_project,['Item ' int2str(1) ' of ' int2str(n_project) '.']);
else
waitbar(i/n_project,h_waitbar,['Item ' int2str(i) ' of ' int2str(n_project) '.']);
end

if isequal(ini_cell{1}{n_columns*(i-1)+2},compartment_cell{1})

file_name = [ini_cell{1}{n_columns*(i-1)+1} '.zef'];

evalin('base',['zef.lf_tag = ''' ini_cell{1}{n_columns*(i-1)+3} ''';']);
evalin('base',['zef.imaging_method = 1;']);

zef_import_segmentation(file_name, folder_name);

if exist('zef_lf_bank_tool.m')
evalin('base','zef_init_lf_bank_tool;')
evalin('base','zef_add_lf_item;')
end

evalin('base','zef_update;');

if isvalid(evalin('base','zef.h_mesh_tool'))
evalin('base','zef_update_mesh_tool;');
end

elseif isequal(ini_cell{1}{n_columns*(i-1)+2},compartment_cell{2})

file_name = [ini_cell{1}{n_columns*(i-1)+1} '.zef'];

evalin('base',['zef.lf_tag = ''' ini_cell{1}{n_columns*(i-1)+3} ''';']);
evalin('base',['zef.imaging_method = 2;']);

zef_import_segmentation(file_name, folder_name);

if exist('zef_lf_bank_tool.m')
evalin('base','zef_init_lf_bank_tool;')
evalin('base','zef_add_lf_item;')
end

if isvalid(evalin('base','zef.h_mesh_tool'))
evalin('base','zef_update_mesh_tool;');
end

evalin('base','zef_update;');

elseif isequal(ini_cell{1}{n_columns*(i-1)+2},compartment_cell{3})

file_name = [ini_cell{1}{n_columns*(i-1)+1} '.zef'];

evalin('base',['zef.lf_tag = ''' ini_cell{1}{n_columns*(i-1)+3} ''';']);
evalin('base',['zef.imaging_method = 3;']);

zef_import_segmentation(file_name, folder_name);

if exist('zef_lf_bank_tool.m')
evalin('base','zef_init_lf_bank_tool;')
evalin('base','zef_add_lf_item;')
end

if isvalid(evalin('base','zef.h_mesh_tool'))
evalin('base','zef_update_mesh_tool;');
end

evalin('base','zef_update;');

% elseif isequal(ini_cell{1}{n_columns*(i-1)+2},'eit')
%
% file_name = [ini_cell{1}{n_columns*(i-1)+1} '.zef'];
%
% evalin('base',['zef.lf_tag = ''' ini_cell{1}{n_columns*(i-1)+3} ''';']);
% evalin('base',['zef.imaging_method = 4;']);

zef_import_segmentation(file_name, folder_name);

if exist('zef_lf_bank_tool.m')
evalin('base','zef_init_lf_bank_tool;')
evalin('base','zef_add_lf_item;')
end

if isvalid(evalin('base','zef.h_mesh_tool'))
evalin('base','zef_update_mesh_tool;');
end

evalin('base','zef_update;');

elseif isequal(ini_cell{1}{n_columns*(i-1)+2},'none')

file_name = [ini_cell{1}{n_columns*(i-1)+1} '.zef'];

evalin('base',['zef.lf_tag = ''' ini_cell{1}{n_columns*(i-1)+3} ''';']);

zef_import_segmentation(file_name, folder_name);

evalin('base','zef_update;');

if isvalid(evalin('base','zef.h_mesh_tool'))
evalin('base','zef_update_mesh_tool;');
end

end

end

close(h_waitbar);

end

end

