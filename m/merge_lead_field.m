%Copyright © 2018, Sampsa Pursiainen
if not(isempty(zef.save_file_path)) & not(zef.save_file_path==0) 
[zef.file zef.file_path] = uigetfile('*.mat','Merge lead field with...',zef.save_file_path);
else
[zef.file zef.file_path] = uigetfile('*.mat','Merge lead field with...');
end
if not(isequal(zef.file,0));
zef.aux = load([zef.file_path zef.file], 'L');
if size(zef.aux.L,2) == size(zef.L,2) || isempty(zef.L)
zef.L = [zef.L ; zef.aux.L];
end
zef = rmfield(zef,'aux');
end