%Script for starting exporting window for GMM.
zef_export_start_boolean = true;

%check if the app is already open (in which case bring it to top and not open new one that will crash the system)
if isfield(zef.GMM.apps,'Export')
    if isvalid(zef.GMM.apps.Export)
        zef.GMM.apps.Export.UIFigure.Visible='off';
        zef.GMM.apps.Export.UIFigure.Visible='on';
        zef_export_start_boolean = false;
    end
end
    
if zef_export_start_boolean
    
zef.GMM.apps.Export = GMMExport;

%Set position besides GMM app
zef.GMM.apps.Export.UIFigure.Position(2) = zef.GMM.apps.main.UIFigure.Position(2);
if zef.GMM.apps.main.UIFigure.Position(1)-0.75*zef.GMM.apps.Export.UIFigure.Position(3)>0
    zef.GMM.apps.Export.UIFigure.Position(1) = zef.GMM.apps.main.UIFigure.Position(1)-0.75*zef.GMM.apps.Export.UIFigure.Position(3);
else
    zef.GMM.apps.Export.UIFigure.Position(1) = zef.GMM.apps.main.UIFigure.Position(1);
end

%Set the format and editability of the table
set(zef.GMM.apps.Export.ComponentTable,'columnformat',{'char','logical'});
zef.GMM.apps.Export.ComponentTable.ColumnEditable = [false,true];

%Update saving parameters to the GMM's parameters table
if sum(strcmp(zef.GMM.parameters.Tags,'saved')) == 0
    zef.GMM.parameters=[zef.GMM.parameters;{'Saved components:',num2cell(ones(4,1)),'saved'}];
    zef.GMM.apps.Export.ComponentTable.Data=[{'Model';'Dipoles';'Parameters';'Reconstruction'},num2cell(ones(4,1))];
else
    zef.GMM.apps.Export.ComponentTable.Data=[{'Model';'Dipoles';'Parameters';'Reconstruction'},zef.GMM.parameters.Values{end}];
end
    
%functions
zef.GMM.apps.Export.ComponentTable.DisplayDataChangedFcn = 'zef.GMM.parameters{26,2}={zef.GMM.apps.Export.ComponentTable.Data(:,2)};';
zef.GMM.apps.Export.ExportButton.ButtonPushedFcn = 'zef_GMM_export(zef.save_file_path,rmfield(zef.GMM,''apps''),zef.GMM.parameters.Values{26});';
zef.GMM.apps.Export.UIFigure.CloseRequestFcn = 'delete(zef.GMM.apps.Export)';

%set fonts
set(findobj(zef.GMM.apps.Export.UIFigure.Children,'-property','FontSize'),'FontSize',zef.font_size);
end

clear zef_export_start_boolean
