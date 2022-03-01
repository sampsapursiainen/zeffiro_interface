
zef.LeadFieldProcessingTool.bank=zef.LeadFieldProcessingTool.bank(~cell2mat( zef.LeadFieldProcessingTool.app.BankTable.Data(:,6)));

zef.LeadFieldProcessingTool.app.BankTable.Data=zef.LeadFieldProcessingTool.app.BankTable.Data(~cell2mat( zef.LeadFieldProcessingTool.app.BankTable.Data(:,6)),:);

zef.LeadFieldProcessingTool.bankSize=size(zef.LeadFieldProcessingTool.bank,2);

% for zef_LeadFieldProcessingTool_deleteIndex=1:zef.LeadFieldProcessingTool.bankSize
% zef.LeadFieldProcessingTool.bankPosition=zef_LeadFieldProcessingTool_deleteIndex;
% zef_LeadfieldProcessingTool_BankTableLabelUpdate;
% end
%
% clear zef_LeadFieldProcessingTool_deleteIndex;

