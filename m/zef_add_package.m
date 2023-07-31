function zef_add_package(package_path, package_folder, file_folder, file_folder_dir)

if not(isempty(package_folder))
    mkdir([package_path filesep '+' package_folder]);
    package_path = [package_path filesep '+' package_folder];
end

if nargin == 3
    file_folder_dir = dir(file_folder);
end

for k = 1 : length(file_folder_dir)

    fnc_str = '';
    fnc_name = '';
    fnc_call = '';
    if   not(ismember(file_folder_dir(k).name,{'.','..'})) && not(isempty(file_folder_dir(k).name))
        [~,file_name,file_ext] = fileparts(file_folder_dir(k).name);

        if isequal(file_ext,'.m')

            [fnc_call,fnc_str,fnc_name] = zef_read_function_call([file_folder_dir(k).folder filesep file_folder_dir(k).name]);

            if  not(isempty(fnc_name)) && not(isempty(fnc_call))

                fid = fopen([package_path filesep fnc_name '.m'],'w');
                if not(isempty(fnc_str))
                    fprintf(fid,[fnc_str '\n' fnc_call ';' '\n' 'end']);
                else
                    fprintf(fid,[fnc_call ';\n']);
                end
                fclose(fid);
                fprintf([file_name file_ext '\n'],'%s')

            end

        elseif isfolder([file_folder filesep file_folder_dir(k).name]) &&  not(ismember('+',file_folder_dir(k).name))

            zef_add_package(package_path, file_folder_dir(k).name, [file_folder filesep file_folder_dir(k).name]);

        end

    end
end
end
