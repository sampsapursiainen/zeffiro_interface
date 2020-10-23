%Copyright © 2020- Joonas Lahtinen, Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
%Script for removing the method button of find_synthetic_source_app.

if isfield(zef,'synth_source_data')
zef.synth_source_data=rmfield(zef.synth_source_data,zef.active_source);
zef.find_synth_source.h_source_list.Items = zef.find_synth_source.h_source_list.Items(not(strcmp(zef.find_synth_source.h_source_list.Items,zef.find_synth_source.h_source_list.Value)));

if isempty(fields(zef.synth_source_data))
    zef = rmfield(zef,{'synth_source_data','active_source'});
    zef.find_synth_source.h_source_parameters.Data = [];
    zef.find_synth_source.h_source_list = [];
else
    zef.active_source = zef.find_synth_source.h_source_list.Items{1}; 
    zef.active_source=erase(zef.active_source,{'(',')'});
    zef.find_synth_source.h_source_parameters.Data=zef.synth_source_data.(zef.active_source).parameters;
end

end