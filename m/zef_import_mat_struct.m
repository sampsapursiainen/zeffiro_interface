function zef_import_mat_struct(varargin)

mat_struct = [];

if not(isempty(varargin{1}))
mat_struct = varargin{1};
end

if isempty(mat_struct)

[file_name folder_name] = uigetfile({'*.fig'},'Import MAT struct',evalin('base','zef.save_file_path'));

if not(isequal(file_name,0));

mat_struct = load([folder_name '/' file_name]);

end

end

if isfield(mat_struct,'tetra')
    [mat_struct.surface_triangles] = zef_surface_mesh(mat_struct.tetra);
    [mat_struct.tetra_aux] = mat_struct.tetra;
end

if isfield(mat_struct,'nodes')
    [mat_struct.nodes_aux] = mat_struct.nodes;
end

f_names = fieldnames(mat_struct);
for i = 1 : length(f_names)
    assignin('base','zef_data', mat_struct.(f_names{i}));
    evalin('base',['zef.' f_names{i} '= zef_data;']);
end

end
