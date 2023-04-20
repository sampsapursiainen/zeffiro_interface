function zef = zef_dataBank_FunctionsDropDown(zef)

if nargin == 0
zef = evalin('base','zef');
end

zef.dataBank.app.combinePanel.Visible='Off';
zef.dataBank.app.importPanel.Visible='Off';
zef.dataBank.app.mag2gragPanel.Visible='Off';

switch zef.dataBank.app.FunctionsDropDown.Value

    case 'combine Lf'
        zef.dataBank.app.combinePanel.Visible='On';

    case 'Import/Export'
        zef.dataBank.app.importPanel.Position=zef.dataBank.app.combinePanel.Position;
        zef.dataBank.app.importPanel.Visible='On';

    case 'mag2grad'

end

if nargout == 0
assignin('base','zef',zef);
end

end

