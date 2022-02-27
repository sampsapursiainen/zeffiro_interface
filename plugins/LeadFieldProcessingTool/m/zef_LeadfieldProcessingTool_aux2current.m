
for zef_LeadFieldProcessingTool_index=1:zef.LeadFieldProcessingTool.bankSize

    if zef.LeadFieldProcessingTool.app.BankTable.Data{zef_LeadFieldProcessingTool_index, 6}

        zef.LeadFieldProcessingTool.bank2auxIndex=zef_LeadFieldProcessingTool_index;
        zef_LeadfieldProcessingTool_bank2aux_bank2auxIndex;

        zef.source_interpolation_ind=zef.LeadFieldProcessingTool.auxData.source_interpolation_ind;
        zef.parcellation_interp_ind= zef.LeadFieldProcessingTool.auxData.parcellation_interp_ind;
        zef.source_positions= zef.LeadFieldProcessingTool.auxData.source_positions;
        zef.source_directions=zef.LeadFieldProcessingTool.auxData.source_directions;
        zef.L=zef.LeadFieldProcessingTool.auxData.L;
        zef.sensors=zef.LeadFieldProcessingTool.auxData.sensors;

        %zef.LeadFieldProcessingTool.auxData.imaging_method_Name = zef.imaging_method_cell{zef.imaging_method};
        zef.imaging_method=zef.LeadFieldProcessingTool.auxData.imaging_method;

        zef.measurements=zef.LeadFieldProcessingTool.auxData.measurements;
        zef.noise_data=zef.LeadFieldProcessingTool.auxData.noise_data;
        %zef.lf_bank_scaling_factor=zef.LeadFieldProcessingTool.auxData.lf_bank_scaling_factor;
        zef.lf_tag=zef.LeadFieldProcessingTool.auxData.lf_tag;

        [zef.lead_field_id,zef.lead_field_id_max] = zef_update_lead_field_id(zef.LeadFieldProcessingTool.auxData.lead_field_id,zef.lead_field_id_max,'bank_replace');

        zef.LeadFieldProcessingTool.app.currentLeadfield.Data={zef.lf_tag, zef.imaging_method_cell{zef.imaging_method}, size(zef.sensors, 1), size(zef.source_positions, 1),zef.lead_field_id};

        if isfield(zef.LeadFieldProcessingTool.auxData, 'compartment_tags')
            zef.compartment_tags=zef.LeadFieldProcessingTool.auxData.compartment_tags;
            for zef_ind=1:length(zef.LeadFieldProcessingTool.auxData.compartment_tags)

                zef_name=strcat(zef.LeadFieldProcessingTool.auxData.compartment_tags{zef_ind}, '_sources');

                zef.(zef_name)=zef.LeadFieldProcessingTool.auxData.source_structure{zef_ind};

                %evalin('base', ['zef.' zef.compartment_tags{zef_ind} '_sources']);

            end
            clear zef_ind zef_name;
        end

        break;
    end
end

clear zef_LeadFieldProcessingTool_index;

zef_update;

