
%zef_LeadFieldProcessingTool_TableUpdate_index has to be set

zef_LeadFieldProcessingTool_TableUpdate_index=zef.LeadFieldProcessingTool.bankPosition;


if zef_LeadFieldProcessingTool_TableUpdate_index > size(zef.LeadFieldProcessingTool.app.BankTable.Data,1) %new data
    zef.LeadFieldProcessingTool.TableData={'', '', '', '', false};
else
    zef.LeadFieldProcessingTool.TableData=zef.LeadFieldProcessingTool.app.BankTable.Data(zef_LeadFieldProcessingTool_TableUpdate_index,:);
end

if isempty(zef.LeadFieldProcessingTool.app.BankTable.Data)
    zef.LeadFieldProcessingTool.app.BankTable.Data=cell(1,5);
end


zef.LeadFieldProcessingTool.app.BankTable.Data(zef_LeadFieldProcessingTool_TableUpdate_index,:) = {...
    zef.LeadFieldProcessingTool.TableData{1},...
    zef.LeadFieldProcessingTool.bank{zef_LeadFieldProcessingTool_TableUpdate_index}.imaging_method_Name,...
    size(zef.LeadFieldProcessingTool.bank{zef_LeadFieldProcessingTool_TableUpdate_index}.sensors, 1),...
    size(zef.LeadFieldProcessingTool.bank{zef_LeadFieldProcessingTool_TableUpdate_index}.source_positions, 1),...
    zef.LeadFieldProcessingTool.TableData{5}   };


clear zef_LeadFieldProcessingTool_TableUpdate_index;



