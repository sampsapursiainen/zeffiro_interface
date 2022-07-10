function [sensor_positions, sensor_orientations, sensor_ind, sensor_tag_cell] = zef_bst_2_zef_sensors(varargin)

sensor_counter = 0; 
sensor_num = 0; 
istudy = [];
sensor_type = [];

if not(isempty(varargin))
sensor_type = varargin{1};
if length(varargin) > 1
istudy = varargin{2};
end
end

if not(isempty(istudy))
file_name = [bst_get('ProtocolInfo').STUDIES filesep bst_get('Study',istudy).Channel.FileName];
else
file_name = [bst_get('ProtocolInfo').STUDIES filesep bst_get('Study').Channel.FileName];
end

channel_data = load(file_name);

sensor_orientations = [];
for i = 1 : length(channel_data.Channel)

    if ismember(channel_data.Channel(i).Type,sensor_type) | isempty(sensor_type)  
        
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