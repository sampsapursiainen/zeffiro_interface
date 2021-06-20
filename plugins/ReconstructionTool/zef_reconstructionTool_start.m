

%reconstructionTool_start

zef.reconstructionTool.app = zef_reconstructionTool_app;

if ~isfield(zef.reconstructionTool, 'current')
    zef.reconstructionTool.current=[];
end




%set initial values

if ~isfield(zef, 'reconstruction_information')
    zef.reconstruction_information=[];
end

if ~isfield(zef.reconstructionTool, 'bankInfo')
    zef.reconstructionTool.bankInfo=cell(0,6);
else
    zef.reconstructionTool.app.BankTable.Data=zef.reconstructionTool.bankInfo;
end


zef.reconstructionTool.bankSize=size(zef.reconstructionTool.bankInfo,1);

if ~isfield(zef, 'reconstruction')
    zef.reconstruction=cell(0);
end

if ~isfield(zef.reconstructionTool, 'currentInfo')
    zef.reconstructionTool.currentInfo=cell(1,5);
    
    if isfield(zef, 'reconstruction_information') && isfield(zef.reconstruction_information, 'tag')
        zef.reconstructionTool.currentInfo{1}=zef.reconstruction_information.tag;
    else
        zef.reconstructionTool.currentInfo{1}='';
    end
    
    if isfield(zef, 'reconstruction_information') && isfield(zef.reconstruction_information, 'type')
        zef.reconstructionTool.currentInfo{2}=zef.reconstruction_information.type;
    else
        zef.reconstructionTool.currentInfo{2}='';
    end
    
    if isfield(zef, 'reconstruction_information') && isfield(zef.reconstruction_information, 'modality')
        zef.reconstructionTool.currentInfo{3}=zef.reconstruction_information.modality;
    else
        zef.reconstructionTool.currentInfo{3}='';
    end

    
    if iscell(zef.reconstruction)
    zef.reconstructionTool.currentInfo{4}=size(zef.reconstruction, 1);
    else
        zef.reconstructionTool.currentInfo{4}=size(zef.reconstruction, 2);
    end
    
    if iscell(zef.reconstruction) && zef.reconstructionTool.currentInfo{4}>=1
        zef.reconstructionTool.currentInfo{5}=size(zef.reconstruction{1}, 1);
    else %is either empty cell or single frame
        zef.reconstructionTool.currentInfo{5}=size(zef.reconstruction,1);
    end
end

zef.reconstructionTool.app.current.Data=zef.reconstructionTool.currentInfo;

%app functions
zef.reconstructionTool.app.AddButton.ButtonPushedFcn='zef_reconstructionTool_addCurrent2bank';
 zef.reconstructionTool.app.replaceButton.ButtonPushedFcn='zef_reconstructionTool_replace';
 zef.reconstructionTool.app.RefreshButton.ButtonPushedFcn='zef_reconstructionTool_refresh';
% 
zef.reconstructionTool.app.deleteButton.ButtonPushedFcn='zef_reconstructionTool_delete';
zef.reconstructionTool.app.ApplytransformationButton.ButtonPushedFcn='zef_reconstructionTool_apply';
zef.reconstructionTool.app.ImportButton.ButtonPushedFcn='[zef.reconstruction, zef.reconstruction_information]=zef_reconstructionTool_import; zef_reconstructionTool_refresh;';

% 
zef.reconstructionTool.app.current.CellEditCallback='zef.reconstructionTool.currentInfo=zef.reconstructionTool.app.current.Data;';
zef.reconstructionTool.app.BankTable.CellEditCallback='zef.reconstructionTool.bankInfo=zef.reconstructionTool.app.BankTable.Data;';



%the content of ./m/apply_funtions is given to a dropdown field. The
%begining zef_reconstructionTool_ is cuttet for readability, .m as well
zef.reconstructionTool.funtions=dir('./plugins/ReconstructionTool/m/apply_functions/*.m');
zef.reconstructionTool.funtions=struct2cell(zef.reconstructionTool.funtions);
zef.reconstructionTool.funtions=zef.reconstructionTool.funtions(1,:);
zef.reconstructionTool.app.FunctionDropDown.Items=zef.reconstructionTool.funtions;
zef.reconstructionTool.app.FunctionDropDown.Items=extractBetween(zef.reconstructionTool.funtions, 'Tool_', '.m');


%set fonts
%set(findobj(zef.GMMclustering.UIFigure.Children,'-property','FontSize'),'FontSize',zef.font_size);




















































