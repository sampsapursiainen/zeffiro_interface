



for zef_LeadFieldProcessingTool_index=1:zef.LeadFieldProcessingTool.bankSize
    
    if zef.LeadFieldProcessingTool.app.BankTable.Data{zef_LeadFieldProcessingTool_index, 5}
        
        zef.LeadFieldProcessingTool.bank2auxIndex=zef_LeadFieldProcessingTool_index;
        
        zef_LeadfieldProcessingTool_bank2aux_bank2auxIndex;
        
        zef.LeadFieldProcessingTool.auxData.L = zef.LeadFieldProcessingTool.tra*zef.LeadFieldProcessingTool.auxData.L;
        zef.LeadFieldProcessingTool.auxData.sensors = zef.LeadFieldProcessingTool.auxData.sensors(1:size(zef.LeadFieldProcessingTool.tra,1),:);
        zef.LeadFieldProcessingTool.auxData.imaging_method = 3;
        
        if zef.LeadFieldProcessingTool.app.DeleteoriginalCheckBox.Value  %delete the original
            zef.LeadFieldProcessingTool.bankPosition=zef.LeadFieldProcessingTool.bank2auxIndex;
            zef_LeadFieldProcessingTool_aux2bank_bankPosition;
        else %add as new
            zef_LeadFieldProcessingTool_aux2bank_new;
        end
            
      

    end
    
  

end

    zef.LeadFieldProcessingTool.auxData=[];
    
    zef_LeadfieldProcessingTool_updateTable;



clear zef_LeadFieldProcessingTool_index;










