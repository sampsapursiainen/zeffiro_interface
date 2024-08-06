%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
function  [sensors_attached_volume] = zef_attach_sensors_volume(zef,sensors,varargin)

if isempty(zef)
    zef = evalin('base','zef');
end

attach_type = 'mesh';
bypass_functions = 0;

if not(isempty(varargin))
    if length(varargin) > 0
        attach_type = varargin{1};
        if length(varargin) > 1
            if not(isempty(varargin{2}))
            zef.nodes = varargin{2};
            end
        end
        if length(varargin) > 2
            if not(isempty(varargin{3}))
            zef.tetra = varargin{3};
            end
        end
        if length(varargin) > 3
            if not(isempty(varargin{4}))
            zef.surface_triangles = varargin{4};
            end
        end
        if length(varargin) > 4
            if not(isempty(varargin{5}))
            bypass_functions = varargin{5};
            end
        end
    end
end

if not(iscell(zef.surface_triangles))
zef.surface_triangles = {zef.surface_triangles};
end

%*****************************
if not(bypass_functions)
I_get_functions = [];
sensors_attached_volume_functions = cell(0);
if isfield(zef,[zef.current_sensors '_get_functions'])
    I_get_functions = find(cellfun(@isempty,zef.([zef.current_sensors '_get_functions']))==0);
    for i_ind = 1 : length(I_get_functions)
      sensors_attached_volume_functions{i_ind} = feval(zef.([zef.current_sensors '_get_functions']){I_get_functions(i_ind)},attach_type);
    end
end
end
%*****************************

if ismember(zef.imaging_method,[1,4,5])

    %if ismember(attach_type,{'geometry','points'});
    if not(isequal(zef.reuna_type{end,1},-1))
        geometry_triangles = zef.reuna_t{end};
        geometry_nodes = zef.reuna_p{end};
    else
        geometry_triangles = zef.reuna_t{end-1};
        geometry_nodes = zef.reuna_p{end-1};
    end

    if not(iscell(zef.surface_triangles))
            zef.surface_triangles = {zef.surface_triangles};
        end
    use_depth_electrodes =zef.use_depth_electrodes;

    %if eval('zef.use_gpu')
    %    nodes = gpuArray(nodes);
    %    sensors = gpuArray(sensors);
    %end

    if size(sensors,2) == 6
        electrode_model = 2;
    else
        electrode_model = 1;
    end

    if electrode_model == 1 || isequal(attach_type,'points')

        if electrode_model == 1 && use_depth_electrodes == 1
            surface_ind = [];
            deep_ind = [1:size(sensors,1)]';
        elseif electrode_model == 1 && use_depth_electrodes == 0
            surface_ind = [1:size(sensors,1)]';
            deep_ind = [];
        else
            surface_ind = find(not(ismember(sensors(:,5),0)));
            deep_ind = setdiff(find(ismember(sensors(:,4),0)),surface_ind);
        end
        sensors_attached_volume = sensors;
        for i = 1 : length(deep_ind)
            [min_val, min_ind] = min(sqrt(sum((zef.nodes - repmat(sensors(deep_ind(i),1:3),size(zef.nodes,1),1)).^2,2)));
            sensors_attached_volume(deep_ind(i),1:3) = zef.nodes(min_ind,:);
        end
        for i = 1 : length(surface_ind)
            [min_val, min_ind] = min(sqrt(sum((geometry_nodes - repmat(sensors(surface_ind(i),1:3),size(geometry_nodes,1),1)).^2,2)));
            sensors_attached_volume(surface_ind(i),1:3) = geometry_nodes(min_ind,:);
        end

    else

        if (isequal(attach_type,'geometry'))
            geometry_center_points_aux = (1/3)*(geometry_nodes(geometry_triangles(:,1),:) + ...
                geometry_nodes(geometry_triangles(:,2),:) + ...
                geometry_nodes(geometry_triangles(:,3),:));
        else
            center_points_aux = (1/3)*(zef.nodes(zef.surface_triangles{end}(:,1),:) + ...
                zef.nodes(zef.surface_triangles{end}(:,2),:) + ...
                zef.nodes(zef.surface_triangles{end}(:,3),:));

            unique_surface_triangles = unique(zef.surface_triangles{end});
            ele_nodes = zef.nodes(unique_surface_triangles,:);

            if not(isempty(find(sensors(:,4) == 0)))
                diff_vec_1 = (zef.nodes(zef.tetra(:,2),:) - zef.nodes(zef.tetra(:,1),:));
                diff_vec_2 = (zef.nodes(zef.tetra(:,3),:) - zef.nodes(zef.tetra(:,1),:));
                diff_vec_3 = (zef.nodes(zef.tetra(:,4),:) - zef.nodes(zef.tetra(:,1),:));
                det_system = zef_determinant(diff_vec_1,diff_vec_2,diff_vec_3);
            end

        end

        sensors_aux = [];
i_ind = 0;
        for i = 1 : size(sensors,1)
            if ismember(i,I_get_functions)
                i_ind = i_ind + 1; 
                sensors_aux = [sensors_aux; sensors_attached_volume_functions{i_ind}];
            else
            if sensors(i,4) == 0 && sensors(i,5) == 0

                if isequal(attach_type,'mesh')

                    diff_vec_sensor = (repmat(sensors(i,1:3),size(zef.tetra,1),1)- zef.nodes(zef.tetra(:,1),:));
                    lambda_2 = zef_determinant(diff_vec_sensor,diff_vec_2,diff_vec_3);
                    lambda_3 = zef_determinant(diff_vec_1,diff_vec_sensor,diff_vec_3);
                    lambda_4 = zef_determinant(diff_vec_1,diff_vec_2,diff_vec_sensor);
                    lambda_2 = lambda_2./det_system;
                    lambda_3 = lambda_3./det_system;
                    lambda_4 = lambda_4./det_system;
                    lambda_1 = 1 - lambda_2 - lambda_3 - lambda_4;
                    sensor_index = find(lambda_1 <= 1 & lambda_2 <= 1 & lambda_3 <= 1  & lambda_4 <= 1 ...
                        &  lambda_1 >= 0 & lambda_2 >= 0 & lambda_3 >= 0  & lambda_4 >= 0,1);
                    lambda_vec = [lambda_1(sensor_index) ; lambda_2(sensor_index) ; lambda_3(sensor_index) ; lambda_4(sensor_index)];
                    sensors_aux = [sensors_aux ; i*ones(4,1)  zef.tetra(sensor_index,:)' lambda_vec zeros(4,1)];

                end

                if isequal(attach_type,'geometry')

                    [min_val, min_ind] = min(sqrt(sum((geometry_nodes - repmat(sensors(i,1:3),size(geometry_nodes,1),1)).^2,2)));
                    sensors_aux = [sensors_aux ; i 0 1 0];

                end

            elseif sensors(i,4) == 0 && sensors(i,5) == 1

                if isequal(attach_type,'mesh')

                    [min_val, min_ind] = min(sqrt(sum((ele_nodes - repmat(sensors(i,1:3),size(ele_nodes,1),1)).^2,2)));
                    min_ind = unique_surface_triangles(min_ind);
                    sensors_aux = [sensors_aux ; i min_ind 1 0];

                end

                if isequal(attach_type,'geometry')

                    [min_val, min_ind] = min(sqrt(sum((geometry_nodes - repmat(sensors(i,1:3),size(geometry_nodes,1),1)).^2,2)));
                    sensors_aux = [sensors_aux ; i min_ind 1 0];

                end

            else

                if isequal(attach_type,'mesh')

                    [min_val, min_ind] = min(sqrt(sum((ele_nodes - repmat(sensors(i,1:3),size(ele_nodes,1),1)).^2,2)));
                    sensors(i,1:3) = ele_nodes(min_ind,:);
                    [dist_val] = (sqrt(sum((center_points_aux - repmat(sensors(i,1:3),size(center_points_aux,1),1)).^2,2)));
                    dist_ind = find(dist_val < sensors(i,4) & dist_val >= sensors(i,5));
                    sensors_aux = [sensors_aux ; i*ones(length(dist_ind),1) zef.surface_triangles{end}(dist_ind,:)];

                elseif isequal(attach_type,'geometry')

                    [min_val, min_ind] = min(sqrt(sum((geometry_nodes - repmat(sensors(i,1:3),size(geometry_nodes,1),1)).^2,2)));
                    sensors(i,1:3) = geometry_nodes(min_ind,:);
                    [dist_val] = (sqrt(sum((geometry_center_points_aux - repmat(sensors(i,1:3),size(geometry_center_points_aux,1),1)).^2,2)));
                    dist_ind = find(dist_val < sensors(i,4) & dist_val >= sensors(i,5));
                    sensors_aux = [sensors_aux ; i*ones(length(dist_ind),1) geometry_triangles(dist_ind,:)];

                end
            end
            end
        end

        sensors_attached_volume = sensors_aux;

    end

else
    sensors_attached_volume = [];
end

sensors_attached_volume = gather(sensors_attached_volume);

if nargout == 0
    assignin('base','zef_data',struct('sensors_attached_volume',sensors_attached_volume));
    eval('zef_assign_data;');
end

end
