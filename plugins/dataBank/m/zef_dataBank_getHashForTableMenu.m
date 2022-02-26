if isempty(zef.dataBank.app.DataTable.Selection) %either no selected or no node in tree, either way start on first level

    disp('please select nodes');
    return;

else
    if size(zef.dataBank.app.DataTable.Selection,1)>1

        if ~zef.dataBank.selectMultiple
            disp('cannot select multiple nodes');
            return;
        end

        for dbi=unique(zef.dataBank.app.DataTable.Selection(:,1))'
            zef.dataBank.hash{dbi}=zef.dataBank.DataTableHashList{dbi};
        end
    else

        zef.dataBank.hash=zef.dataBank.DataTableHashList(zef.dataBank.app.DataTable.Selection(1));
    end

end

