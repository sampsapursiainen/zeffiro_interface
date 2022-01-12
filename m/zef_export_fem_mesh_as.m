function zef_export_fem_mesh_as


[file path] = uiputfile('*.mat','Export FEM mesh as...',evalin('base','zef.save_file_path'));

if not(isequal(file,0)); 

tetra = evalin('base','zef.tetra');
nodes = evalin('base','zef.nodes');
domain_labels = evalin('base','zef.domain_labels');
name_tags = evalin('base','zef.name_tags');
save([path '/' file],'-v7.3','nodes','tetra','domain_labels','name_tags');

end
