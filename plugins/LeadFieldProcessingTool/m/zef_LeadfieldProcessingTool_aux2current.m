


for zef_LeadFieldProcessingTool_index=1:zef.LeadFieldProcessingTool.bankSize
    
    if zef.LeadFieldProcessingTool.app.BankTable.Data{zef_LeadFieldProcessingTool_index, 5}
        
        
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
        
zef.LeadFieldProcessingTool.app.currentLeadfield.Data={zef.lf_tag, zef.imaging_method_cell{zef.imaging_method}, size(zef.sensors, 1), size(zef.source_positions, 1)};

        
        
        break;
    end
end


zef_update;





















