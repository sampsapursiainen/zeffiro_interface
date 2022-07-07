%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
function zef_import_parcellation_colortable(varargin)

filename = '';
compartment_tag = ''; 

parcellation_merge = evalin('base','zef.parcellation_merge');

if not(isempty(varargin))
filename = varargin{1};
if length(varargin) > 1
    compartment_tag = varargin{2};
end
if length(varargin) > 2
    parcellation_merge = varargin{3};
end
end


if isempty(filename)

save_file_path = evalin('base','zef.save_file_path');

if not(isempty(save_file_path)) && not(save_file_path==0)
[file file_path file_type] = uigetfile({'*.mat'},'Import parcellation colortable',save_file_path);
else
[file file_path file_type] = uigetfile({'*.mat'},'Import parcellation colortable');
end
filename = [file_path file];
end

if not(isempty(filename))
[parcellation_aux] = struct2cell(load(filename));
parcellation_aux = {struct2cell(parcellation_aux{1}),parcellation_aux{2:end}};
if not(parcellation_merge)
    zef_data.parcellation_interp_ind = cell(0);
    zef_data.parcellation_colortable = cell(0);
    parcellation_segment = 1;
else 
   zef_data.parcellation_colortable = evalin('base','zef.parcellation_colortable');
   parcellation_segment = evalin('base','zef.parcellation_segment');
end

zef_data.parcellation_colortable{length(zef_data.parcellation_colortable)+1} = {parcellation_segment,parcellation_aux{1}{3},parcellation_aux{1}{4},parcellation_aux{2}};

if not(isempty(compartment_tag))

    zef_data.parcellation_colortable{length(zef_data.parcellation_colortable)}{5} = cell(0);
    for p_ind = 1 : size(parcellation_aux{1}{4},1)
    
        zef_data.parcellation_colortable{length(zef_data.parcellation_colortable)}{5}{p_ind,1} = compartment_tag;
        zef_data.parcellation_colortable{length(zef_data.parcellation_colortable)}{5}{p_ind,2} = 1;
        
    end

        zef_data.parcellation_colortable{length(zef_data.parcellation_colortable)}{6} = ones(size(parcellation_aux{1}{4},1),1);
    
end


zef_data.parcellation_selected = [];
assignin('base','zef_data',zef_data);
zef_assign_data

if evalin('base','isfield(zef,''h_parcellation_list'')')
if isvalid('base','zef.h_parcellation_list')
h_parcellation_list = evalin('base','zef.h_parcellation_list');
set(h_parcellation_list,'value',[]);
evalin('base','zef_update_parcellation;');
end
end


end
end
