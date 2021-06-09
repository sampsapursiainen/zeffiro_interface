
%adds the leadfield and data in the aux field to the bank

zef.LeadFieldProcessingTool.bank{zef.LeadFieldProcessingTool.bankPosition}.source_interpolation_ind = zef.LeadFieldProcessingTool.auxData.source_interpolation_ind;
zef.LeadFieldProcessingTool.bank{zef.LeadFieldProcessingTool.bankPosition}.parcellation_interp_ind =zef.LeadFieldProcessingTool.auxData.parcellation_interp_ind;
zef.LeadFieldProcessingTool.bank{zef.LeadFieldProcessingTool.bankPosition}.source_positions = zef.LeadFieldProcessingTool.auxData.source_positions;
zef.LeadFieldProcessingTool.bank{zef.LeadFieldProcessingTool.bankPosition}.source_directions = zef.LeadFieldProcessingTool.auxData.source_directions;
zef.LeadFieldProcessingTool.bank{zef.LeadFieldProcessingTool.bankPosition}.L = zef.LeadFieldProcessingTool.auxData.L;
zef.LeadFieldProcessingTool.bank{zef.LeadFieldProcessingTool.bankPosition}.sensors = zef.LeadFieldProcessingTool.auxData.sensors;

zef.LeadFieldProcessingTool.bank{zef.LeadFieldProcessingTool.bankPosition}.imaging_method_Name = zef.imaging_method_cell{zef.LeadFieldProcessingTool.auxData.imaging_method};
zef.LeadFieldProcessingTool.bank{zef.LeadFieldProcessingTool.bankPosition}.imaging_method = zef.LeadFieldProcessingTool.auxData.imaging_method;



zef.LeadFieldProcessingTool.bank{zef.LeadFieldProcessingTool.bankPosition}.measurements = zef.LeadFieldProcessingTool.auxData.measurements;
zef.LeadFieldProcessingTool.bank{zef.LeadFieldProcessingTool.bankPosition}.noise_data = zef.LeadFieldProcessingTool.auxData.noise_data;


%zef.LeadFieldProcessingTool.bank{zef.LeadFieldProcessingTool.bankPosition}.lf_bank_scaling_factor = zef.LeadFieldProcessingTool.auxData.lf_bank_scaling_factor;
zef.LeadFieldProcessingTool.bank{zef.LeadFieldProcessingTool.bankPosition}.lf_tag = zef.LeadFieldProcessingTool.auxData.lf_tag;


zef_LeadfieldProcessingTool_updateTable;

%zef.LeadFieldProcessingTool.auxData=[];











































