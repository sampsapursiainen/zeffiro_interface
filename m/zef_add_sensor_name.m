if not(evalin('base','zef.lock_sensor_names_on'))

if ismember(evalin('base',['size(zef.' zef.current_sensors '_points,2)']),[6,0])
evalin('base',['zef.' zef.current_sensors '_points = [zef.' zef.current_sensors '_points; [0 0 0 0 1 ' num2str(evalin('base','zef.default_impedance_value')) ' ]];']);
else
evalin('base',['zef.' zef.current_sensors '_points = [zef.' zef.current_sensors '_points; [0 0 0]];']);
end

if ismember(evalin('base',['zef.' zef.current_sensors '_imaging_method_name']),{evalin('base',['zef.imaging_method_cell{2}']),evalin('base',['zef.imaging_method_cell{3}'])})

if evalin('base',['size(zef.' zef.current_sensors '_directions,2)']) == 6
evalin('base',['zef.' zef.current_sensors '_directions = [zef.' zef.current_sensors '_directions; [0 0 0 0 0 0]];']);
else
evalin('base',['zef.' zef.current_sensors '_directions = [zef.' zef.current_sensors '_directions; [0 0 0]];']);
end

end

for zef_i = 1 : size(zef.parameter_profile,1)

    if isequal(zef.parameter_profile{zef_i,8},'Sensors') && isequal(zef.parameter_profile{zef_i,6},'On') && isequal(zef.parameter_profile{zef_i,7},'On')
        if isequal(zef.parameter_profile{zef_i,3},'Scalar')
        evalin('base',['zef.' zef.current_sensors '_' zef.parameter_profile{zef_i,2} '(size(zef.' zef.current_sensors '_' zef.parameter_profile{zef_i,2} ',1)+1) =' num2str(zef.parameter_profile{zef_i,4}) ';']);
        elseif isequal(zef.parameter_profile{zef_i,3},'String')
        evalin('base',['zef.' zef.current_sensors '_' zef.parameter_profile{zef_i,2} '(size(zef.' zef.current_sensors '_' zef.parameter_profile{zef_i,2} ',1)+1) =' zef.parameter_profile{zef_i,4} ';']);
        end
    end

end

    clear zef_i;

zef_init_sensors_name_table;

end