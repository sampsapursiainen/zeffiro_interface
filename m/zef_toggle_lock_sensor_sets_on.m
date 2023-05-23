if isequal(zef.lock_sensor_sets_on,0)
    zef.h_sensors_table.ColumnEditable = logical(ones(1,size(zef.h_sensors_table.Data,2)));
    zef.h_menu_lock_sensor_sets_on.Text = 'Toggle ''On'' unlocked';
    zef.h_menu_lock_sensor_sets_on.ForegroundColor = [0 0 0];
elseif isequal(zef.lock_sensor_sets_on,1)
    zef.h_sensors_table.ColumnEditable = logical(ones(1,size(zef.h_sensors_table.Data,2)));
    zef.h_sensors_table.ColumnEditable(4) = logical(0);
    zef.h_menu_lock_sensor_sets_on.Text = 'Toggle ''On'' locked';
    zef.h_menu_lock_sensor_sets_on.ForegroundColor = [1 0 0];
end
