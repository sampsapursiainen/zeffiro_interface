if not(isfield(zef,'parcellation_name')); 
    zef.parcellation_name = ''; 
end;

if not(isfield(zef,'parcellation_colortable')); 
    zef.parcellation_colortable = cell(0); 
end;

if not(isfield(zef,'parcellation_segment')); 
    zef.parcellation_segment = 'LH'; 
end;

if not(isfield(zef,'parcellation_points')); 
    zef.parcellation_points = cell(0); 
end;

if not(isfield(zef,'parcellation_merge')); 
    zef.parcellation_merge = 1; 
end;

if not(isfield(zef,'use_parcellation')); 
    zef.use_parcellation = 0; 
end;

zef_update_parcellation;