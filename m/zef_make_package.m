function zef_make_package(program_path,package_name)

if nargin == 1
    package_name = 'zeffiro';
end

fprintf(['Adding the following list of files into +' package_name ' package:\n'],'%s')

package_path = [program_path filesep '+' package_name];
if exist(package_path)
rmdir(package_path,'s');
end
mkdir(package_path);

file_folder_dir = struct;
file_folder_dir(1).name = 'm';
file_folder_dir(2).name = 'plugins';
file_folder_dir(3).name = 'scripts';
for i = 1 : length(file_folder_dir)
file_folder_dir(i).folder = program_path;
end
    
zef_add_package(package_path,[],program_path,file_folder_dir)

 
end

    


