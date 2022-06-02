function [folder_list] = zef_add_path(import_path,varargin)

folder_list_aux = [];
subfolder_status = 0;
d = dir(import_path);
folder_list = cell(0);
if not(isempty(varargin))
if isequal(varargin{1},1) || isequal(varargin{1},'recursive') 
subfolder_status = 1; 
end

if length(varargin) > 1
folder_list_aux = varargin{2}; 
folder_list = folder_list_aux;
end
end

for i = 1 : length(d)
   
[a, b, c] = fileparts(d(i).name);
if not(isempty(b)) 
if not(isequal(b(1),'+')) && not(isequal(b(1),'@'))
if isequal(b,'.')
b = '';
end
if length(dir([import_path filesep b])) > 1 
folder_list = [folder_list ; {[import_path filesep b]}];
end
if subfolder_status
folder_list = [folder_list ; zef_add_path([import_path filesep b])];
end
end
end
    
end


folder_list = unique(folder_list);


folder_list_aux = setdiff(folder_list,folder_list_aux);
for i = 1 : length(folder_list_aux)
addpath(folder_list_aux{i});
end

end