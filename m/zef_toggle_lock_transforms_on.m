if isequal(zef.lock_transforms_on,0)
zef.h_transform_table.ColumnEditable = logical(ones(1,size(zef.h_transform_table.Data,2)));
zef.h_menu_lock_transforms_on.Text = 'Toggle ''On'' unlocked';
zef.h_menu_lock_transforms_on.ForegroundColor = [0 0 0];
elseif isequal(zef.lock_transforms_on,1)
    zef.h_transform_table.ColumnEditable = logical(zeros(1,size(zef.h_transform_table.Data,2)));
    zef.h_menu_lock_transforms_on.Text = 'Toggle ''On'' locked';
zef.h_menu_lock_transforms_on.ForegroundColor = [1 0 0];
end
