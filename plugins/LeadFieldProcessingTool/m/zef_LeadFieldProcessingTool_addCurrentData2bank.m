
%reads the current data into the aux field and adds it to the bank
zef.LeadFieldProcessingTool.auxData.source_interpolation_ind = zef.source_interpolation_ind;
zef.LeadFieldProcessingTool.auxData.parcellation_interp_ind = zef.parcellation_interp_ind;
zef.LeadFieldProcessingTool.auxData.source_positions = zef.source_positions;
zef.LeadFieldProcessingTool.auxData.source_directions = zef.source_directions;
zef.LeadFieldProcessingTool.auxData.L = zef.L;
zef.LeadFieldProcessingTool.auxData.sensors = zef.sensors;

zef.LeadFieldProcessingTool.auxData.imaging_method_Name = zef.imaging_method_cell{zef.imaging_method};
zef.LeadFieldProcessingTool.auxData.imaging_method=zef.imaging_method;

zef.LeadFieldProcessingTool.auxData.measurements = zef.measurements;
zef.LeadFieldProcessingTool.auxData.noise_data = zef.noise_data;
%zef.LeadFieldProcessingTool.auxData.lf_bank_scaling_factor = zef.lf_bank_scaling_factor;
zef.LeadFieldProcessingTool.auxData.lf_tag = zef.lf_tag;

[zef.lead_field_id,zef.lead_field_id_max] = zef_update_lead_field_id(zef.lead_field_id,zef.lead_field_id_max,'bank_add');
zef.LeadFieldProcessingTool.auxData.lead_field_id=zef.lead_field_id;

zef.LeadFieldProcessingTool.auxData.source_structure=cell(0,0);
zef.LeadFieldProcessingTool.auxData.compartment_tags=zef.compartment_tags;

for zef_ind=1:length(zef.compartment_tags)

    zef_name=strcat(zef.compartment_tags{zef_ind}, '_sources');

    zef.LeadFieldProcessingTool.auxData.source_structure{zef_ind}=zef.(zef_name);
    %evalin('base', ['zef.' zef.compartment_tags{zef_ind} '_sources']);

end
        clear zef_ind zef_name;

zef_LeadFieldProcessingTool_aux2bank_new;
zef_LeadfieldProcessingTool_updateTable;

