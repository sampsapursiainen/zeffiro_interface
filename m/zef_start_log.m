function zef = zef_start_log(zef)

if zef.use_log
    if not(exist([zef.program_path filesep 'data' filesep 'log'],'dir'))
        mkdir([zef.program_path filesep 'data' filesep 'log']);
    end

        zef.current_log_file = [zef.program_path filesep 'data' filesep 'log' filesep zef.zeffiro_log_file_name '_' num2str(length(dir([zef.program_path filesep 'data' filesep 'log']))-1) '.log'];
log_dir = dir([zef.program_path filesep 'data' filesep 'log']);
n_files = length(log_dir)-2;
if n_files > zef.max_n_log_files
date_info_cell = {log_dir(3:end).date}';
date_info_array = zeros(n_files,6);
for i = 1 : n_files
date_info_array(i,:) = datevec(date_info_cell{i});
end
[~,I] = sortrows(date_info_array);
for i = 1 : n_files - zef.max_n_log_files
delete([zef.program_path filesep 'data' filesep 'log' filesep log_dir(2+I(i)).name]) 
end
end
    fid = fopen(zef.current_log_file,'a'); 
fprintf(fid,'%s',['**************************************************************************' newline]);
fprintf(fid,'%s',['ZEFFIRO Interface ' num2str(zef.current_version) ', Date: ' datestr(now) newline]);
fprintf(fid,'%s',['**************************************************************************' newline] );
fprintf(fid,'%s',['Path: ' zef.program_path newline]);
fprintf(fid,'%s',['**************************************************************************' newline]);
fclose(fid); 
end

if not(ismember('ZefCurrentLogFile',properties(zef.h_zeffiro_menu)))
addprop(zef.h_zeffiro_menu,'ZefCurrentLogFile');
end
zef.h_zeffiro_menu.ZefCurrentLogFile = zef.current_log_file;
    
end