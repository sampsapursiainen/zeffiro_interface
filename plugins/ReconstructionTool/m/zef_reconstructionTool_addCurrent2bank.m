

zef.reconstructionTool.bankSize=zef.reconstructionTool.bankSize+1;

zef.reconstructionTool.bankInfo(zef.reconstructionTool.bankSize, 1:5)=zef.reconstructionTool.currentInfo;

if iscell(zef.reconstruction)
    zef.reconstructionTool.bankReconstruction{zef.reconstructionTool.bankSize,1}.reconstruction=zef.reconstruction;
else
    zef.reconstructionTool.bankReconstruction{zef.reconstructionTool.bankSize,1}.reconstruction={zef.reconstruction};
end

zef.reconstructionTool.bankReconstruction{zef.reconstructionTool.bankSize,1}.reconstruction_information=zef.reconstruction_information;

zef.reconstructionTool.bankInfo{zef.reconstructionTool.bankSize,6}=false;

zef.reconstructionTool.app.BankTable.Data=zef.reconstructionTool.bankInfo;










