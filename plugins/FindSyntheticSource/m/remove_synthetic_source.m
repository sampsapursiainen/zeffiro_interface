%Script for the remove method button of find_synthetic_source_app.

if isfield(zef,'synth_source_data')
zef.synth_source_data(zef.find_synth_source.selected_source) = [];
zef.find_synth_source.h_source_list.Data(zef.find_synth_source.selected_source)=[];

if isempty(zef.synth_source_data)
    zef = rmfield(zef,'synth_source_data');
    zef.find_synth_source.h_source_parameters.Data = [];
    zef.find_synth_source.h_source_list = [];
else
    zef.find_synth_source.selected_source = 1;
    zef.find_synth_source.h_source_parameters.Data=zef.synth_source_data{zef.find_synth_source.selected_source}.parameters;
end

end