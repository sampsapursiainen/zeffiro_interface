[zef.file,zef.file_path] = uigetfile('*.dat');

if not(isequal(zef.file,0))

    zef.h_aux = fopen([zef.file_path '/' zef.file]);
    zef.aux_field = textscan(zef.h_aux,'%s');

    for zef_i = 1 : length(zef.aux_field{1})
        evalin('base',['zef.' zef.current_sensors '_name_list{' num2str(zef_i) '} = ''' zef.aux_field{1}{zef_i} ''';']);
    end

    zef_init_sensors_name_table;

end

zef = rmfield(zef,{'h_aux','aux_field'});

clear zef_i;
