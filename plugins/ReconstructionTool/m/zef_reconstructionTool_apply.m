
trueDex=cell2mat( zef.reconstructionTool.bankInfo(:,7));

zef_reconstructionTool_function=str2func(strcat('zef_reconstructionTool_', zef.reconstructionTool.app.FunctionDropDown.Value));

for index=1:zef.reconstructionTool.bankSize
    if trueDex(index)

         newRec=zef_reconstructionTool_function(zef.reconstructionTool.bankReconstruction{index}.reconstruction);

         clear zef_reconstructionTool_function;
        %all functions should give out a cell!

        %why did I do it like that? make new auxdata and add it

            zef.reconstructionTool.bankSize=zef.reconstructionTool.bankSize+1;
            zef.reconstructionTool.bankReconstruction{zef.reconstructionTool.bankSize,1}.reconstruction=newRec;
            zef.reconstructionTool.bankReconstruction{zef.reconstructionTool.bankSize,1}.reconstruction_information=zef.reconstructionTool.bankReconstruction{index,1}.reconstruction_information;
            zef.reconstructionTool.bankReconstruction{zef.reconstructionTool.bankSize,1}.reconstruction_information.appliedFunction=zef.reconstructionTool.app.FunctionDropDown.Value;
            zef.reconstructionTool.bankReconstruction{zef.reconstructionTool.bankSize,1}.reconstruction_information.tag = ...
                strcat(zef.reconstructionTool.bankReconstruction{zef.reconstructionTool.bankSize,1}.reconstruction_information.tag, zef.reconstructionTool.app.FunctionDropDown.Value);

            zef.reconstructionTool.bankInfo(zef.reconstructionTool.bankSize,:)=zef.reconstructionTool.bankInfo(index,:);
            zef.reconstructionTool.bankInfo{zef.reconstructionTool.bankSize, 1}=strcat(zef.reconstructionTool.bankInfo{index, 1},'_', zef.reconstructionTool.app.FunctionDropDown.Value);

            zef.reconstructionTool.bankInfo{zef.reconstructionTool.bankSize, 4}=size(zef.reconstructionTool.bankReconstruction{zef.reconstructionTool.bankSize}.reconstruction, 1);
            zef.reconstructionTool.bankInfo{index, 5}=size(zef.reconstructionTool.bankReconstruction{zef.reconstructionTool.bankSize}.reconstruction{1}, 1);
            zef.reconstructionTool.bankInfo{index, 6}= zef.reconstructionTool.bankReconstruction{zef.reconstructionTool.bankSize,1}.reconstruction_information.lead_field_id;

    end

%zef.reconstructionTool.bankInfo{index,6}=false;
end

zef.reconstructionTool.app.BankTable.Data=zef.reconstructionTool.bankInfo;

clear index trueDex newRec nextRec

