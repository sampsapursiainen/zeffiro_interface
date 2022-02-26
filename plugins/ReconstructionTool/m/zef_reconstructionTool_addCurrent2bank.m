
zef.reconstructionTool.bankSize=zef.reconstructionTool.bankSize+1;

zef.reconstructionTool.bankInfo(zef.reconstructionTool.bankSize, 1:6)=zef.reconstructionTool.currentInfo;

if iscell(zef.reconstruction)
    zef.reconstructionTool.bankReconstruction{zef.reconstructionTool.bankSize,1}.reconstruction=zef.reconstruction;
else
    zef.reconstructionTool.bankReconstruction{zef.reconstructionTool.bankSize,1}.reconstruction={zef.reconstruction};
end

zef.reconstructionTool.bankReconstruction{zef.reconstructionTool.bankSize,1}.reconstruction_information=zef.reconstruction_information;

if ~isfield(zef.reconstructionTool.bankReconstruction{zef.reconstructionTool.bankSize,1}.reconstruction_information, 'tag')
    zef.reconstructionTool.bankReconstruction{zef.reconstructionTool.bankSize,1}.reconstruction_information.tag=zef.reconstructionTool.currentInfo{1};
end

if ~isfield(zef.reconstructionTool.bankReconstruction{zef.reconstructionTool.bankSize,1}.reconstruction_information, 'lead_field_id')
    zef.reconstructionTool.bankReconstruction{zef.reconstructionTool.bankSize,1}.reconstruction_information.lead_field_id=zef.reconstructionTool.currentInfo{6};
end

zef.reconstructionTool.bankInfo{zef.reconstructionTool.bankSize,7}=false;

zef.reconstructionTool.app.BankTable.Data=zef.reconstructionTool.bankInfo;

