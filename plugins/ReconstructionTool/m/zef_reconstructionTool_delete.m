
zef.reconstructionTool.bankReconstruction = zef.reconstructionTool.bankReconstruction(~cell2mat( zef.reconstructionTool.bankInfo(:,7)), :);
zef.reconstructionTool.bankInfo=zef.reconstructionTool.bankInfo(~cell2mat( zef.reconstructionTool.bankInfo(:,7)),:);

zef.reconstructionTool.bankSize=size(zef.reconstructionTool.bankInfo,1);

zef.reconstructionTool.app.BankTable.Data=zef.reconstructionTool.bankInfo;

