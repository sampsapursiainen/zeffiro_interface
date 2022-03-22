
zef.LeadFieldProcessingTool.app.currentLeadfield.Data={zef.lf_tag, zef.imaging_method_cell{zef.imaging_method}, size(zef.sensors, 1), size(zef.source_positions, 1), zef.lead_field_id};

if zef.LeadFieldProcessingTool.bankSize>=1

    for zef_LeadfieldProcessingTool_startIndex=1:zef.LeadFieldProcessingTool.bankSize
         zef.LeadFieldProcessingTool.bankPosition=zef_LeadfieldProcessingTool_startIndex;

          if ~isfield(zef.LeadFieldProcessingTool.bank{zef_LeadfieldProcessingTool_startIndex}, 'lead_field_id')
            warning('old project data. IDs are set sequentially');
            [zef.lead_field_id,zef.lead_field_id_max] = zef_update_lead_field_id(zef.lead_field_id,zef.lead_field_id_max,'bank_oldData');
            zef.LeadFieldProcessingTool.bank{zef_LeadfieldProcessingTool_startIndex}.lead_field_id=zef.lead_field_id_max;
          end

        zef_LeadfieldProcessingTool_updateTable;
    end
    clear zef_LeadfieldProcessingTool_startIndex;
end
