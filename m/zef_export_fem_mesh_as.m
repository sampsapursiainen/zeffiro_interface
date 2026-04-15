function zef_export_fem_mesh_as(zef)

if nargin == 0
    zef = evalin('base','zef');
end

if zef.use_display
    [file path] = uiputfile('*.mat','Export FEM mesh as...',zef.save_file_path);
else
    file = zef.file;
    path = zef.file_path;
end

if not(isequal(file,0))

    tetra = zef.tetra;
    nodes = zef.nodes;
    domain_labels = zef.domain_labels;
    name_tags = zef.name_tags;
    save([path '/' file],'-v7.3','nodes','tetra','domain_labels','name_tags');


end
