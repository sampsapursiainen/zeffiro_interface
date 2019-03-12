if not(isempty(zef.save_file_path)) & not(zef.save_file_path==0)  
[zef.file zef.file_path zef.file_type] = uigetfile({'*.dat'},'Import parcellation points',zef.save_file_path);
else
[zef.file zef.file_path zef.file_type] = uigetfile({'*.dat'},'Import parcellation points');
end

if not(zef.parcellation_merge)
    zef.parcellation_points = cell(0);
end

if not(isequal(zef.file,0));
[zef.parcellation_points{length(zef.parcellation_points)+1}] = load([zef.file_path zef.file]);
end



