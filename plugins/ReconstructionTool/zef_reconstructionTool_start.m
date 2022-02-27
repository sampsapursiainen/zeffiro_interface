
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
    zef.reconstructionTool.bankInfo=cell(0,7);
else
    %TODO check for old data format
    if size(zef.reconstructionTool.bankInfo, 2)==6
        zef.reconstructionTool.app.BankTable.Data=zef.reconstructionTool.bankInfo(:,1:5);
        for zef_index=1:size(zef.reconstructionTool.bankInfo, 1)

            if isfield(zef.reconstructionTool.bankReconstruction{zef_index}, 'reconstruction_information') && isfield(zef.reconstructionTool.bankReconstruction{zef_index}.reconstruction_information, 'lead_field_id')
                zef.reconstructionTool.app.BankTable.Data{zef_index,6}=zef.reconstructionTool.bankReconstruction{zef_index}.reconstruction_information.lead_field_id;
            else
                zef.reconstructionTool.app.BankTable.Data{zef_index,6}='noID';
                zef.reconstructionTool.bankReconstruction{zef_index}.reconstruction_information.lead_field_id='noID';
            end

            zef.reconstructionTool.app.BankTable.Data{zef_index,7}=false;
        end
        clear zef_index;
        zef.reconstructionTool.bankInfo=zef.reconstructionTool.app.BankTable.Data;
    else
        zef.reconstructionTool.app.BankTable.Data=zef.reconstructionTool.bankInfo;
    end
end

zef.reconstructionTool.bankSize=size(zef.reconstructionTool.bankInfo,1);

if ~isfield(zef, 'reconstruction')
    zef.reconstruction=cell(0);
end

zef_reconstructionTool_refresh;

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

