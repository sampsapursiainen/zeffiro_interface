
[~, indexOfMinimumTrueElement]=max(cell2mat( zef.reconstructionTool.bankInfo(:,7)));

zef.reconstruction=zef.reconstructionTool.bankReconstruction{indexOfMinimumTrueElement,1}.reconstruction;

zef.reconstructionTool.currentInfo=zef.reconstructionTool.bankInfo(indexOfMinimumTrueElement,1:6);

%set every checkbox to false
for indexOfMinimumTrueElement=1:zef.reconstructionTool.bankSize
zef.reconstructionTool.bankInfo{indexOfMinimumTrueElement,7}=false;
end

zef.reconstructionTool.app.BankTable.Data=zef.reconstructionTool.bankInfo;
zef.reconstructionTool.app.current.Data=zef.reconstructionTool.currentInfo;

zef.reconstruction_information=zef.reconstructionTool.bankReconstruction{indexOfMinimumTrueElement,1}.reconstruction_information;

clear indexOfMinimumTrueElement;

%% copy the information to the zef file

if isfield(zef.reconstruction_information, 'inv_time_1') && isfield(zef.reconstruction_information, 'inv_time_2') ...
        && isfield(zef.reconstruction_information, 'inv_time_3') && isfield(zef.reconstruction_information, 'inv_sampling_frequency')
    zef.inv_time_1=zef.reconstruction_information.inv_time_1;
    zef.inv_time_2=zef.reconstruction_information.inv_time_2;
    zef.inv_time_3=zef.reconstruction_information.inv_time_3;
    zef.inv_sampling_frequency=zef.reconstruction_information.inv_sampling_frequency;

end
