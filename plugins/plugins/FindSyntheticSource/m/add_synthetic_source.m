%Script for add synthetic source button of find_synthetic_source_app.

%Display Initial parameters on the list
zef.find_synth_source.h_source_parameters.Data=zef.synth_source_init;

%Define a possible index for banked method name and add it to the list of selected inversion methods
if isfield(zef,'synth_source_data')
    zef_temp_itemnum  = str2double(erase(zef.find_synth_source.h_source_list.Data,{'Source','(',')'}));
    zef_temp_itemnum = setdiff(1:(length(zef.synth_source_data)+1),zef_temp_itemnum);
    zef_temp_itemnum = min(zef_temp_itemnum);
else
    zef_temp_itemnum = 1;
end
zef.find_synth_source.h_source_list.Data=flip(zef.find_synth_source.h_source_list.Data);

zef.find_synth_source.h_source_list.Data{end+1,1} = ['Source(',num2str(zef_temp_itemnum),')'];
zef.find_synth_source.selected_source=1;

zef.find_synth_source.h_source_list.Data=flip(zef.find_synth_source.h_source_list.Data);
clear zef_temp_itemnum;
%zef.find_synth_source.h_source_list.Value=zef.find_synth_source.h_source_list.Data{1};

%Save the meta information to synt_data field
zef.synth_source_data = flip(zef.synth_source_data);
zef.synth_source_data{end+1}.name = zef.find_synth_source.h_source_list.Data{1};
zef.synth_source_data{end}.parameters = zef.find_synth_source.h_source_parameters.Data;
zef.synth_source_data = flip(zef.synth_source_data);
