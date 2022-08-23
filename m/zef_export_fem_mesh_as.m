function zef_export_fem_mesh_as(zef)

if nargin == 0
   zef = evalin('base','zef'); 
end

if eval('zef.use_display')
[file path] = uiputfile('*.mat','Export FEM mesh as...',eval('zef.save_file_path'));
else
    file = eval('zef.file');
    path = eval('zef.file_path');
end

if not(isequal(file,0))

tetra = eval('zef.tetra');
nodes = eval('zef.nodes');
domain_labels = eval('zef.domain_labels');
name_tags = eval('zef.name_tags');
save([path '/' file],'-v7.3','nodes','tetra','domain_labels','name_tags');


end
