
zef.aux_data_1 = cell(0);
zef_i = evalin('base','zef.current_sensor_name');

if ismember(evalin('base',['zef.'  zef.current_sensors '_imaging_method_name']),{'EEG','EIT','tES'})
zef.aux_data_2 = {
    {'X-coordinate','points','1'}
    {'Y-coordinate','points','2'}
    {'Z-coordinate','points','3'}
    {'Outer radius','points','4'}
    {'Inner radius','points','5'}
    {'Impedance','points','6'}};

elseif ismember(evalin('base',['zef.'  zef.current_sensors '_imaging_method_name']),{'MEG magnetometers'})

zef.aux_data_2 = {
    {'X-coordinate','points','1'}
    {'Y-coordinate','points','2'}
    {'Z-coordinate','points','3'}
    {'X-direction','directions','1'}
    {'Y-direction','directions','2'}
    {'Z-direction','directions','3'}};

elseif ismember(evalin('base',['zef.'  zef.current_sensors '_imaging_method_name']),{'MEG gradiometers'})

zef.aux_data_2 = {
    {'X-coordinate','points','1'}
    {'Y-coordinate','points','2'}
    {'Z-coordinate','points','3'}
    {'X-direction','directions','1'}
    {'Y-direction','directions','2'}
    {'Z-direction','directions','3'}
    {'X-gradient','directions','4'}
    {'Y-gradient','directions','5'}
    {'Z-gradient','directions','6'}};
end


for zef_j = 1 : length(zef.aux_data_2)

zef.aux_data_1{zef_j,1} = zef.aux_data_2{zef_j}{1};
zef.aux_data_1{zef_j,2} = evalin('base',['zef.' zef.current_sensors '_' zef.aux_data_2{zef_j}{2} '(' num2str(zef_i) ',' zef.aux_data_2{zef_j}{3} ')']);
  
end 

zef.h_parameters_table.Data = zef.aux_data_1;

zef.current_parameters = 'sensor';

zef = rmfield(zef,{'aux_data_1','aux_data_2'});
clear zef_i zef_j;