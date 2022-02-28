
for zef_LeadFieldProcessingTool_index=1:zef.LeadFieldProcessingTool.bankSize

    if zef.LeadFieldProcessingTool.app.BankTable.Data{zef_LeadFieldProcessingTool_index, 6}

        zef.LeadFieldProcessingTool.bank2auxIndex=zef_LeadFieldProcessingTool_index;

        zef_LeadfieldProcessingTool_bank2aux_bank2auxIndex;

        zef.LeadFieldProcessingTool.auxData.L = zef.LeadFieldProcessingTool.tra*zef.LeadFieldProcessingTool.auxData.L;
        zef.LeadFieldProcessingTool.auxData.sensors = zef.LeadFieldProcessingTool.auxData.sensors(1:size(zef.LeadFieldProcessingTool.tra,1),:);
        zef.LeadFieldProcessingTool.auxData.imaging_method = 3;

        [zef.lead_field_id,zef.lead_field_id_max] = zef_update_lead_field_id(zef.lead_field_id,zef.lead_field_id_max,'bank_apply');
        zef.LeadFieldProcessingTool.auxData.lead_field_id=zef.lead_field_id_max;
        zef_LeadFieldProcessingTool_aux2bank_new;

    end

end

    zef.LeadFieldProcessingTool.auxData=[];

    zef_LeadfieldProcessingTool_updateTable;

clear zef_LeadFieldProcessingTool_index;

