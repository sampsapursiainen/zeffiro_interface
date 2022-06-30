function [sensor_positions, sensor_orientations, sensor_ind, sensor_tag_cell] = zef_bst_2_zef_sensors(file_name,sensor_type)

channel_data = load(file_name);

sensor_counter = 0; 
sensor_num = 0; 

sensor_orientations = [];
for i = 1 : length(channel_data.Channel)

    if isequal(channel_data.Channel(i).Type,sensor_type) 
        
        sensor_num = sensor_num + 1;
     
    sensor_positions(sensor_counter+1:sensor_counter + size(channel_data.Channel(i).Loc',1),:) = channel_data.Channel(i).Loc';
    if not(isempty(sensor_orientations))
    sensor_orientations(sensor_counter+1:sensor_counter + size(channel_data.Channel(i).Loc',1),:) = channel_data.Channel(i).Orient';
    end
    sensor_ind(sensor_counter+1:sensor_counter + size(channel_data.Channel(i).Loc',1)) = sensor_num;
    sensor_tag_cell(sensor_counter+1:sensor_counter + size(channel_data.Channel(i).Loc',1)) = {channel_data.Channel(i).Type};
    
    sensor_counter = sensor_counter + size(channel_data.Channel(i).Loc',1);
    
    end
    
end

sensor_ind = sensor_ind(:);
sensor_tag_cell = sensor_tag_cell(:);

end