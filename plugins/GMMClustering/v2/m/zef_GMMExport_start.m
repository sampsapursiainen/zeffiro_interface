%Script for starting exporting window for GMM.
zef_export_start_boolean = true;

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

set(zef.GMM.apps.Export.ComponentTable,'columnformat',{'char','logical'});
zef.GMM.apps.Export.ComponentTable.ColumnEditable = [false,true];

if length(zef.GMM.parameters.Values)<26
    zef.GMM.parameters=[zef.GMM.parameters;{'Saved components:',num2cell(ones(3,1))}];
    zef.GMM.apps.Export.ComponentTable.Data=[{'model';'dipoles';'parameters'},num2cell(ones(3,1))];
else
    zef.GMM.apps.Export.ComponentTable.Data=[{'model';'dipoles';'parameters'},zef.GMM.parameters.Values{26}];
end
    

zef.GMM.apps.Export.ComponentTable.DisplayDataChangedFcn = 'zef.GMM.parameters{26,2}={zef.GMM.apps.Export.ComponentTable.Data(:,2)};';
zef.GMM.apps.Export.ExportButton.ButtonPushedFcn = 'zef_GMM_export(zef.save_file_path,rmfield(zef.GMM,''apps''),zef.GMM.parameters.Values{26});';
zef.GMM.apps.Export.UIFigure.CloseRequestFcn = 'delete(zef.GMM.apps.Export)';

%set fonts
set(findobj(zef.GMM.apps.Export.UIFigure.Children,'-property','FontSize'),'FontSize',zef.font_size);
end

clear zef_export_start_boolean