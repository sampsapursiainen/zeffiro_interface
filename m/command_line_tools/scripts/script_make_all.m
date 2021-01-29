home_folder = ['../../../'];

run([home_folder 'zeffiro_interface_nodisplay;']);


load(project_file_name);
zef = zef_data;
clear zef_data;

zef_make_all_nodisplay;

zef_data = zef;
zef_data.fieldnames = fieldnames(zef);
zef_data = rmfield(zef_data,zef_data.fieldnames(find(startsWith(zef_data.fieldnames, 'h_'))));
%zef_data = rmfield(zef_data,{'fieldnames','h'});
save([file_name],'zef_data','-v7.3');
clear zef_data;

exit;
