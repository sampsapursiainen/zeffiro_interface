%Copyright © 2020- Joonas Lahtinen, Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
%Script for add synthetic source button of find_synthetic_source_app.

%Display Initial parameters on the list
zef.find_synth_source.h_source_parameters.Data=zef.synth_source_init;

%Define a possible index for banked method name and add it to the list of selected inversion methods
if isfield(zef,'synth_source_data')
    zef_temp_itemnum = fields(zef.synth_source_data);
    
    if isempty(zef_temp_itemnum)
        zef_temp_itemnum = 1;
    else
        zef_temp_itemnum = erase(zef_temp_itemnum,'Source');
        zef_temp_itemnum = str2double(zef_temp_itemnum);
        if isempty(setdiff(1:max(zef_temp_itemnum),zef_temp_itemnum))
            zef_temp_itemnum = max(zef_temp_itemnum)+1;
        else
            zef_temp_itemnum = min(setdiff(1:max(zef_temp_itemnum),zef_temp_itemnum));
        end
    end
else
    zef_temp_itemnum = 1;
end
zef.find_synth_source.h_source_list.Items=flip(zef.find_synth_source.h_source_list.Items); 

zef.find_synth_source.h_source_list.Items{end+1} = ['Source(',num2str(zef_temp_itemnum),')']; 
zef.active_source=strcat('Source',num2str(zef_temp_itemnum)); 

zef.find_synth_source.h_source_list.Items=flip(zef.find_synth_source.h_source_list.Items); 
clear zef_temp_itemnum; 
zef.find_synth_source.h_source_list.Value=zef.find_synth_source.h_source_list.Items{1};

%Save the meta information to synt_data field
zef.synth_source_data.(zef.active_source).name = zef.find_synth_source.h_source_list.Items{1}; 
zef.synth_source_data.(zef.active_source).parameters = zef.find_synth_source.h_source_parameters.Data; 