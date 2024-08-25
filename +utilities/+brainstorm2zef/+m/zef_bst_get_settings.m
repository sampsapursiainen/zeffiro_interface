function zef_bst = zef_bst_get_settings(settings_file_name,zef_bst)

if nargin < 2
zef_bst = struct;
end

zef_bst_aux = zef_bst;
utilities.brainstorm2zef.m.zef_bst_init;
[~, settings_file_name] = fileparts(settings_file_name);
eval(['utilities.brainstorm2zef.settings.' settings_file_name]);

fieldnames_aux = fieldnames(zef_bst_aux);
for i = 1 : length(fieldnames_aux)
zef_bst.(fieldnames_aux{i}) = zef_bst_aux.(fieldnames_aux{i});
end

if zef_bst.parallel_processes > maxNumCompThreads
    zef_bst.parallel_processes = maxNumCompThreads;
end 

end