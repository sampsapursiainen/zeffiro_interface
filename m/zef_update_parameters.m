zef.aux_field_1 = zef.h_parameters_table.Data;

if isequal(zef.current_parameters,'transform')

zef.aux_field_2 = {'scaling','x_correction','y_correction','z_correction','xy_rotation','yz_rotation','zx_rotation'};

for zef_i = 1 : size(zef.aux_field_1,1)
  
   evalin('base',['zef.' zef.current_tag '_' zef.aux_field_2{zef_i} '(' num2str(zef.current_transform) ')=' num2str(zef.aux_field_1{zef_i,2}) ';']);
    
end


elseif isequal(zef.current_parameters,'sensor')
    
    if ismember(evalin('base',['zef.' zef.current_sensors '_type']),{'electrodes'})
    
        ismember(evalin('base',['zef.' zef.current_sensors '_points']),6)
        
    zef.aux_field_2 = {
        {'points','1'}
        {'points','2'}
        {'points','3'}
        {'points','4'}
        {'points','5'}
        {'points','6'}
        };

    elseif ismember(evalin('base',['zef.' zef.current_sensors '_points']),6)
        ismember(evalin('base',['zef.' zef.current_sensors '_points']),6)
    
for zef_i = 1 : size(zef.aux_field_1,1)
  
   evalin('base',['zef.' zef.current_sensors '_' zef.aux_field_2{zef_i}{1} '(' num2str(zef.current_sensor_name) ',' zef.aux_field_2{zef_i}{2} ') = ' num2str(zef.aux_field_1{zef_i,2}) ';']);
    
end
    
end 

zef = rmfield(zef,{'aux_field_1','aux_field_2'});
clear zef_i;