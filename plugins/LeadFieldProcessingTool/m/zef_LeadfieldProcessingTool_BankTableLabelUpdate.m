
for zef_LeadFieldProcessingTool_TableUpdate_index2=1:size(zef.LeadFieldProcessingTool.app.BankTable.Data,1)

    zef.LeadFieldProcessingTool.bank{zef_LeadFieldProcessingTool_TableUpdate_index2}.lf_tag=zef.LeadFieldProcessingTool.app.BankTable.Data{zef_LeadFieldProcessingTool_TableUpdate_index2,1};

end

clear zef_LeadFieldProcessingTool_TableUpdate_index2;

