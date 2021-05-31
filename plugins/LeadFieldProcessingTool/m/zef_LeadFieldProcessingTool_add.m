

%reads the current data into the aux field and adds it to the bank
zef.LeadFieldProcessingTool.auxData.source_interpolation_ind = zef.source_interpolation_ind;
zef.LeadFieldProcessingTool.auxData.parcellation_interp_ind = zef.parcellation_interp_ind;
zef.LeadFieldProcessingTool.auxData.source_positions = zef.source_positions;
zef.LeadFieldProcessingTool.auxData.source_directions = zef.source_directions;
zef.LeadFieldProcessingTool.auxData.L = zef.L;
zef.LeadFieldProcessingTool.auxData.sensors = zef.sensors;
zef.LeadFieldProcessingTool.auxData.imaging_method = zef.imaging_method_cell{zef.imaging_method};
zef.LeadFieldProcessingTool.auxData.measurements = zef.measurements;
zef.LeadFieldProcessingTool.auxData.noise_data = zef.noise_data;
zef.LeadFieldProcessingTool.auxData.scaling_factor = zef.lf_bank_scaling_factor;
zef.LeadFieldProcessingTool.auxData.lf_tag = zef.lf_tag;

zef_LeadFieldProcessingTool_aux2bank; %aux data is deleted in aux2bank






