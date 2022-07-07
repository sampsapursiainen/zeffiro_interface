%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
function zef_import_parcellation_colortable(varargin)

filename = '';
compartment_tag = ''; 
parcellation_merge = evalin('base','zef.parcellation_merge');
zef_data = struct;

if not(isempty(varargin))
filename = varargin{1};
if length(varargin) > 1
parcellation_merge = varargin{2};
end
end

if isempty(filename)

save_file_path = evalin('base','zef.save_file_path');

if not(isempty(save_file_path)) & not(save_file_path==0)
 [file file_path file_type] = uigetfile({'*.asc';'*.dat'},'Import parcellation points',save_file_path);
else
 [file file_path file_type] = uigetfile({'*.asc';'*.dat'},'Import parcellation points');
end
 filename = [file_path file];
end


[~,~,file_type_aux] = fileparts(filename);

if isequal(file_type_aux,'.asc')
    file_type = 1; 
elseif isequal(file_type_aux,'.dat')
    file_type = 2; 
end

if not(isempty(filename))
if not(parcellation_merge)
    zef_data.parcellation_points = cell(0);
else
    zef_data.parcellation_points = evalin('base','zef.parcellation_points');
end

if file_type == 1
zef_i = fopen(filename);
zef_j = textscan(zef_i,'%s',1,'delimiter','\n', 'headerlines',1);
zef_j = str2num(zef_j{1}{1});
zef_j = zef_j(1);

zef_i = fopen(filename);
zef_k = textscan(zef_i,'%s',zef_j,'delimiter','\n', 'headerlines',2);

zef_k = cellfun(@(v) zef_import_asc(v,1,4),zef_k{1},'uniformoutput',false);
[zef_data.parcellation_points{length(zef_data.parcellation_points)+1}] = cell2mat(zef_k);

clear zef_i zef_j zef_k;

end

if file_type == 2
[zef_data.parcellation_points{length(zef_data.parcellation_points)+1}] = load(filename);
end

assignin('base','zef_data',zef_data);
zef_assign_data

if evalin('base','isfield(zef,''h_zef_import_parcellation_points'')')
if isvalid('base','zef.h_zef_import_parcellation_points')
if  isempty(evalin('base','zef.parcellation_points'))
set(evalin('base','zef.h_zef_import_parcellation_points'),'foregroundcolor',[1 0 0]);
else
set(evalin('base','zef.h_zef_import_parcellation_points'),'foregroundcolor',[0 0 0]);
end
end
end

end


end
