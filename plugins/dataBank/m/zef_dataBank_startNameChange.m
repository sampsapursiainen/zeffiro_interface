function zef = zef_dataBank_startNameChange(zef)

if nargin == 0
    zef = evalin('base','zef');
end


zef.dataBank.app.Tree.Enable='off';

zef.dataBank.selectMultiple=false;
zef = zef_dataBank_getHashForMenu(zef);

zef.dataBank.nameChangeapp=zef_dataBank_nameChange_app;

zef.dataBank.nameChangeapp.Label_oldName.Text=zef.dataBank.tree.(zef.dataBank.hash).name;
zef.dataBank.nameChangeapp.Label_node.Text=zef.dataBank.hash;

zef.dataBank.nameChangeapp.OkButton.ButtonPushedFcn=strcat("zef.dataBank.tree.(zef.dataBank.hash).name=zef.dataBank.nameChangeapp.NameField.Value;", ...
    "zef.dataBank.app.Tree.SelectedNodes.Text=zef.dataBank.nameChangeapp.NameField.Value;", ...
    "zef.dataBank.app.Tree.Enable='on';", ...
    "zef.dataBank.nameChangeapp.delete;" );

zef.dataBank.nameChangeapp.CancelButton.ButtonPushedFcn=strcat("zef.dataBank.app.Tree.Enable='on';", ...
    "zef.dataBank.nameChangeapp.delete;" );

if nargout == 0
    assignin('base','zef',zef);
end

end
