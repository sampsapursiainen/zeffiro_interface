%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
if not(isempty(zef.save_file_path)) & not(zef.save_file_path==0)
[zef.file zef.file_path zef.file_type] = uigetfile({'*.asc';'*.dat'},'Import parcellation points',zef.save_file_path);
else
[zef.file zef.file_path zef.file_type] = uigetfile({'*.asc';'*.dat'},'Import parcellation points');
end

if not(isequal(zef.file,0));
if not(zef.parcellation_merge)
    zef.parcellation_points = cell(0);
end

if zef.file_type == 1
zef_i = fopen([zef.file_path zef.file]);
zef_j = textscan(zef_i,'%s',1,'delimiter','\n', 'headerlines',1);
zef_j = str2num(zef_j{1}{1});
zef_j = zef_j(1);

zef_i = fopen([zef.file_path zef.file]);
zef_k = textscan(zef_i,'%s',zef_j,'delimiter','\n', 'headerlines',2);

zef_k = cellfun(@(v) zef_import_asc(v,1,4),zef_k{1},'uniformoutput',false);
[zef.parcellation_points{length(zef.parcellation_points)+1}] = cell2mat(zef_k);

clear zef_i zef_j zef_k;

end

if zef.file_type == 2
[zef.parcellation_points{length(zef.parcellation_points)+1}] = load([zef.file_path zef.file]);
end

if  isempty(evalin('base','zef.parcellation_points'))
set(evalin('base','zef.h_zef_import_parcellation_points'),'foregroundcolor',[1 0 0]);
else
set(evalin('base','zef.h_zef_import_parcellation_points'),'foregroundcolor',[0 0 0]);
end;

end

