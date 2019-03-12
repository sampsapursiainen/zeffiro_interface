if not(isempty(zef.save_file_path)) & not(zef.save_file_path==0)  
[zef.file zef.file_path zef.file_type] = uigetfile({'*.mat'},'Import parcellation colortable',zef.save_file_path);
else
[zef.file zef.file_path zef.file_type] = uigetfile({'*.mat'},'Import parcellation colortable');
end

if not(isequal(zef.file,0));
[zef.parcellation_aux] = struct2cell(load([zef.file_path zef.file]));
zef.parcellation_aux = {struct2cell(zef.parcellation_aux{1}),zef.parcellation_aux{2:end}};
if not(zef.parcellation_merge)
    zef.parcellation_colortable = cell(0);
end

zef.parcellation_colortable{length(zef.parcellation_colortable)+1} = {zef.parcellation_segment,zef.parcellation_aux{1}{3},zef.parcellation_aux{1}{4},zef.parcellation_aux{2}};
    
rmfield(zef,'parcellation_aux');
zef_update_parcellation;
end


