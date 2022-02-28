%Copyright © 2018- Joonas Lahtinen, Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface

%Script for starting exporting window for GMM.

%don't allow to open multiple app window because it cause ether App
%Designer or app's functionalities to crash or both of them
if isfield(zef.GMM.apps,'Export')
    if isvalid(zef.GMM.apps.Export)
        eval(zef.GMM.apps.Export.UIFigure.CloseRequestFcn);
    end
end

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

if sum(strcmp(zef.GMM.parameters.Tags,'saved')) == 0
    zef.GMM.parameters=[zef.GMM.parameters;{'Saved components:',num2cell(ones(6,1)),'saved'}];
    zef.GMM.apps.Export.ComponentTable.Data=[{'Model';'Dipoles';'Amplitudes';'Time variables';'Parameters';'Reconstruction'},num2cell(ones(6,1))];
else
    zef.GMM.apps.Export.ComponentTable.Data=[{'Model';'Dipoles';'Amplitudes';'Time variables';'Parameters';'Reconstruction'},zef.GMM.parameters.Values{end}];
end

zef.GMM.apps.Export.ComponentTable.DisplayDataChangedFcn = 'zef_ind = find(strcmp(zef.GMM.parameters.Tags,''saved'')); zef.GMM.parameters{zef_ind,2}={zef.GMM.apps.Export.ComponentTable.Data(:,2)}; clear zef_ind';
zef.GMM.apps.Export.ExportButton.ButtonPushedFcn = 'zef_GMM_export(zef.save_file_path,rmfield(zef.GMM,''apps''),zef.GMM.parameters.Values{find(strcmp(zef.GMM.parameters.Tags,''saved''))});';
zef.GMM.apps.Export.UIFigure.CloseRequestFcn = 'delete(zef.GMM.apps.Export)';

%set fonts
set(findobj(zef.GMM.apps.Export.UIFigure.Children,'-property','FontSize'),'FontSize',zef.font_size);
