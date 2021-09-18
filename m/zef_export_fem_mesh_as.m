function zef_export_fem_mesh_as


[file path] = uiputfile('*.mat','Export FEM mesh as...',evalin('base','zef.save_file_path'));

if not(isequal(file,0)); 

tetrahedra = evalin('base','zef.tetra');
nodes = evalin('base','zef.nodes');
sigma = evalin('base','zef.sigma');
sigma = sigma(:,[2 1]); 
labels = sigma(:,1);
labels_conductivity = unique(sigma,'rows');
name_tags = zef.name_tags;

save([path '/' file],'-v7.3','nodes','tetrahedra','labels','labels_conductivity','name_tags');

end
