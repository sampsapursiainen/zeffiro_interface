%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
function zef = zef_import_parcellation_colortable(zef,varargin)

if isempty(zef)
    zef = evalin('base','zef');
end

filename = '';
compartment_tag = ''; 

parcellation_merge = zef.parcellation_merge;

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

save_file_path = zef.save_file_path;

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
    zef.parcellation_interp_ind = cell(0);
    zef.parcellation_colortable = cell(0);
    parcellation_segment = 1;
else 
   zef.parcellation_colortable = zef.parcellation_colortable;
   parcellation_segment = zef.parcellation_segment;
end

zef.parcellation_colortable{length(zef.parcellation_colortable)+1} = {parcellation_segment,parcellation_aux{1}{3},parcellation_aux{1}{4},parcellation_aux{2}};

if not(isempty(compartment_tag))

    zef.parcellation_colortable{length(zef.parcellation_colortable)}{5} = cell(0);
    for p_ind = 1 : size(parcellation_aux{1}{4},1)
    
        zef.parcellation_colortable{length(zef.parcellation_colortable)}{5}{p_ind,1} = compartment_tag;
        zef.parcellation_colortable{length(zef.parcellation_colortable)}{5}{p_ind,2} = 1;
        
    end

        zef.parcellation_colortable{length(zef.parcellation_colortable)}{6} = ones(size(parcellation_aux{1}{4},1),1);
    
end


zef.parcellation_selected = [];
%assignin('base','zef_data',zef_data);
%zef_assign_data

if eval('isfield(zef,''h_parcellation_list'')')
if isvalid('base','zef.h_parcellation_list')
h_parcellation_list = zef.h_parcellation_list;
set(h_parcellation_list,'value',[]);
zef = zef_update_parcellation(zef);
end
end


end

if nargout == 0
assignin('base','zef',zef);
end
end
