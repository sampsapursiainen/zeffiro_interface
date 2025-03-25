%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
function zef = zef_process_meshes(zef,varargin)

explode_param = 1;

if nargin == 0
    zef = evalin('base','zef');
end

reuna_p_inf = [];
output_mode = 'compact'; 

if not(isempty(varargin))
    explode_param = varargin{1};
end

i = 0;
sensors = [];
reuna_p = cell(0);
reuna_t = cell(0);
reuna_p_inf = cell(0);
reuna_submesh_ind = cell(0);
reuna_type = cell(0);
reuna_mesh_ind = [];

compartment_tags = eval('zef.compartment_tags');
for k = 1 : length(compartment_tags)

    var_0 = ['zef.' compartment_tags{k} '_on'];
    var_1 = ['zef.' compartment_tags{k} '_scaling'];
    var_2 = ['zef.' compartment_tags{k} '_x_correction'];
    var_3 = ['zef.' compartment_tags{k} '_y_correction'];
    var_4 = ['zef.' compartment_tags{k} '_z_correction'];
    var_5 = ['zef.' compartment_tags{k} '_xy_rotation'];
    var_6 = ['zef.' compartment_tags{k} '_yz_rotation'];
    var_7 = ['zef.' compartment_tags{k} '_zx_rotation'];
    var_8 = ['zef.' compartment_tags{k} '_points_inf'];
    var_9 = ['zef.' compartment_tags{k} '_points'];
    var_10 = ['zef.' compartment_tags{k} '_triangles'];
    var_11 = ['zef.' compartment_tags{k} '_submesh_ind'];
    var_12 = ['zef.' compartment_tags{k} '_sources'];
    var_13 = ['zef.' compartment_tags{k} '_affine_transform'];
    var_14 = [compartment_tags{k} '_affine_transform'];

    on_val = eval(var_0);

    if on_val
        i = i + 1;
        reuna_p_inf{i} = eval(var_8);
        reuna_p{i} = eval(var_9);
        reuna_t{i} = eval(var_10);
        reuna_type{i,1} = eval(var_12);
        reuna_type{i,2} = eval(['zef.compartment_activity{' var_12 '+2' '}']);
        reuna_type{i,3} = k;
        reuna_type{i,4} = compartment_tags{k};
        reuna_submesh_ind{i} = eval(var_11);
        mean_vec = repmat(mean(reuna_p{i},1),size(reuna_p{i},1),1);
reuna_mesh_ind(i) = k;

        for t_ind = 1 : length(eval(var_1))

            scaling_val = eval([var_1 '(' num2str(t_ind) ')']);
            translation_vec(1) = eval([var_2 '(' num2str(t_ind) ')']);
            translation_vec(2) = eval([var_3 '(' num2str(t_ind) ')']);
            translation_vec(3) = eval([var_4 '(' num2str(t_ind) ')']);
            theta_angle_vec(1) =  eval([var_5 '(' num2str(t_ind) ')']);
            theta_angle_vec(2) =  eval([var_6 '(' num2str(t_ind) ')']);
            theta_angle_vec(3) =  eval([var_7 '(' num2str(t_ind) ')']);
            if eval(['isfield(zef,''' var_14 ''')'])
                if eval(['length(' var_13 ')']) >= t_ind
                    affine_transform =  cell2mat(eval([var_13 '(' num2str(t_ind) ')']));
                else
                    affine_transform = eye(4);
                end

                reuna_aux = [reuna_p{i} ones(size(reuna_p{i},1),1)];
                if not(isempty(reuna_aux)) && not(isempty(affine_transform))
                    reuna_aux = reuna_aux*affine_transform';
                    reuna_p{i} = reuna_aux(:,1:3);
                else
                    reuna_p{i} = [];
                end


                if scaling_val ~= 1
                    reuna_p{i} = scaling_val*reuna_p{i};
                    if not(isempty(reuna_p_inf{i}))
                        reuna_p_inf{i} = scaling_val*reuna_p_inf{i};
                    end
                end
                for j = 1 : 3
                    switch j
                        case 1
                            axes_ind = [1 2];
                        case 2
                            axes_ind = [2 3];
                        case 3
                            axes_ind = [3 1];
                    end

                    if theta_angle_vec(j) ~= 0
                        theta_angle = theta_angle_vec(j)*pi/180;
                        R_mat = [cos(theta_angle) -sin(theta_angle); sin(theta_angle) cos(theta_angle)];
                        reuna_p{i}(:,axes_ind) = (reuna_p{i}(:,axes_ind)-mean_vec(:,axes_ind))*R_mat' + mean_vec(:,axes_ind);
                        if not(isempty(reuna_p_inf{i}))
                            reuna_p_inf{i}(:,axes_ind) = (reuna_p_inf{i}(:,axes_ind)-mean_vec(:,axes_ind))*R_mat' + mean_vec(:,axes_ind);
                        end

                    end
                end
                for j = 1 : 3
                    if translation_vec(j) ~= 0
                        reuna_p{i}(:,j) = reuna_p{i}(:,j) + translation_vec(j);
                        if not(isempty(reuna_p_inf{i}))
                            reuna_p_inf{i}(:,j) = reuna_p_inf{i}(:,j) + translation_vec(j);
                        end
                    end
                end

            end

            if explode_param ~= 1
                for s_ind = 1 : length(reuna_submesh_ind{i})
                    if s_ind == 1
                        t_ind_1 = 1;
                    else
                        t_ind_1 = reuna_submesh_ind{i}(s_ind-1)+1;
                    end
                    t_ind_2 = reuna_submesh_ind{i}(s_ind);
                    p_ind = unique(reuna_t{i}(t_ind_1:t_ind_2,:));
                    mean_aux = mean(reuna_p{i}(p_ind,:),1);
                    reuna_p{i}(p_ind,:) = reuna_p{i}(p_ind,:) + (explode_param-1)*repmat(mean_aux,length(p_ind),1);
                    if not(isempty(reuna_p_inf{i}))
                        mean_aux = mean(reuna_p_inf{i}(p_ind,:),1);
                        reuna_p_inf{i}(p_ind,:) = reuna_p_inf{i}(p_ind,:) + (explode_param-1)*repmat(mean_aux,length(p_ind),1);
                    end
                end
            end
        end
    end

    sensor_tag = eval('zef.current_sensors');

    s_points = eval(['zef.' sensor_tag '_points']);
    s_data_aux = [];

    if ismember(eval('zef.imaging_method'),1)
        f_handle = zef.create_patch_sensor;
        if not(isempty(f_handle))
            s_points = f_handle(zef,s_points);
        end
    end

    if ismember(eval('zef.imaging_method'),[2 3])
        s_directions = eval(['zef.' sensor_tag '_directions(:,1:3)']);
        s_directions_g = [];
        if size(eval(['zef.' sensor_tag '_directions']),2) == 6
            s_directions_g = eval(['zef.' sensor_tag '_directions(:,4:6)']);
        end
    else
        if size(s_points,2)==6
            s_data_aux = s_points(:,4:6);
            s_points = s_points(:,1:3);
        end
        s_directions = [];
        s_directions_g = [];
    end
    s_scaling = eval(['zef.' sensor_tag '_scaling']);
    s_x_correction = eval(['zef.' sensor_tag '_x_correction']);
    s_y_correction = eval(['zef.' sensor_tag '_y_correction']);
    s_z_correction = eval(['zef.' sensor_tag '_z_correction']);
    s_xy_rotation = eval(['zef.' sensor_tag '_xy_rotation']);
    s_yz_rotation = eval(['zef.' sensor_tag '_yz_rotation']);
    s_zx_rotation = eval(['zef.' sensor_tag '_zx_rotation']);

    if eval(['isfield(zef,''' sensor_tag '_affine_transform'')']);
        s_affine_transform = eval(['zef.' sensor_tag '_affine_transform']);
    else
        s_affine_transform = cell(0);
    end

    if isempty(s_directions)
        sensors = [s_points];
    else
        if isempty(s_directions_g)
            sensors = [s_points s_directions./repmat(sqrt(sum(s_directions.^2,2)),1,3)];
        else
            sensors = [s_points s_directions./repmat(sqrt(sum(s_directions.^2,2)),1,3) s_directions_g./repmat(sqrt(sum(s_directions_g.^2,2)),1,3)];
        end
    end
    use_pem = 0;
    if ismember(eval('zef.imaging_method'),[1 5])
        use_pem = eval('zef.use_pem');
    end

    for t_ind = 1 : length(s_scaling)

        scaling_val = s_scaling(t_ind);
        translation_vec = [s_x_correction(t_ind) s_y_correction(t_ind) s_z_correction(t_ind)];
        theta_angle_vec = [s_xy_rotation(t_ind) s_yz_rotation(t_ind) s_zx_rotation(t_ind)];
        if not(isempty(sensors))
            mean_vec = repmat(mean(sensors(:,1:3),1),size(sensors(:,1:3),1),1);

            if length(s_affine_transform) >= t_ind
                sensors_aux = [sensors(:,1:3) ones(size(sensors,1),1)];
                sensors_aux = sensors_aux*s_affine_transform{t_ind}';
                sensors(:,1: 3) = sensors_aux(:,1:3);
                if size(sensors_aux,2) >= 6 && ismember(eval('zef.imaging_method'),[2 3])
                    sensors(:,4:6) = sensors(:,4:6)*s_affine_transform{t_ind}(1:3,1:3)';
                end
                if size(sensors_aux,2) >= 9 && ismember(eval('zef.imaging_method'),[3])
                    sensors(:,7:9) = sensors(:,7:9)*s_affine_transform{t_ind}(1:3,1:3)';
                end

            end



            if scaling_val ~= 1
                sensors(:,1:3) = scaling_val*sensors(:,1:3);
            end
            for j = 1 : 3
                switch j
                    case 1
                        axes_ind_1 = [1 2];
                        axes_ind_2 = [4 5];
                        axes_ind_3 = [7 8];
                    case 2
                        axes_ind_1 = [2 3];
                        axes_ind_2 = [5 6];
                        axes_ind_3 = [8 9];
                    case 3
                        axes_ind_1 = [3 1];
                        axes_ind_2 = [6 4];
                        axes_ind_3 = [9 7];
                end
                if theta_angle_vec(j) ~= 0
                    theta_angle = theta_angle_vec(j)*pi/180;
                    R_mat = [cos(theta_angle) -sin(theta_angle); sin(theta_angle) cos(theta_angle)];
                    sensors(:,axes_ind_1) = (sensors(:,axes_ind_1) - mean_vec(:,axes_ind_1))*R_mat' + mean_vec(:,axes_ind_1);
                    if not(isempty(s_directions))
                        sensors(:,axes_ind_2) = sensors(:,axes_ind_2)*R_mat';
                    end
                    if not(isempty(s_directions_g))
                        sensors(:,axes_ind_3) = sensors(:,axes_ind_3)*R_mat';
                    end
                end
            end
            for j = 1 : 3

                if translation_vec(j) ~= 0
                    sensors(:,j) = sensors(:,j) + translation_vec(j);
                end

            end
        end
    end

    if not(isempty(sensors))
        for j = 1 : 3
            sensors(:,j) = sensors(:,j)  +  (explode_param-1)*(sensors(:,j) - mean(sensors(:,j),1));
        end

        if not(isempty(s_data_aux))
            sensors = [sensors s_data_aux];
        end

    else
        sensors = [NaN NaN NaN];
    end

    if use_pem
        sensors = sensors(:,1:3);
    end

    max_val = 0;
    box_ind = 0;
    for i_aux = 1 : length(reuna_p)
        if not(isequal(reuna_type{i_aux,1}, -1))
            max_val = max([abs(reuna_p{i_aux}(:)) ; max_val]);
        elseif isequal(reuna_type{i_aux,1}, -1)
            box_ind = i_aux;
        end
    end

    if not(isequal(box_ind,0))

        pml_outer_radius_unit = eval('zef.pml_outer_radius_unit');
        pml_outer_radius = eval('zef.pml_outer_radius');
        if pml_outer_radius_unit == 1
            box_outer_radius = pml_outer_radius*max_val;
        elseif pml_outer_radius_unit == 2
            box_outer_radius = pml_outer_radius;
        end

    reuna_p{box_ind} = [
        -box_outer_radius  -box_outer_radius  -box_outer_radius;
        box_outer_radius  -box_outer_radius -box_outer_radius;
        box_outer_radius  box_outer_radius -box_outer_radius;
        -box_outer_radius  box_outer_radius -box_outer_radius;
               -box_outer_radius  -box_outer_radius box_outer_radius ;
        box_outer_radius  -box_outer_radius box_outer_radius;
        box_outer_radius  box_outer_radius box_outer_radius;
        -box_outer_radius  box_outer_radius box_outer_radius;
        ];
    reuna_t{box_ind} = [1 2 6;
                  6  5  1;
                  3  4  7;
                  8  7  4;
                  2  3  7;
                  2  7  6;
                  1  5  8;
                  4  1  8;
                  2  1  4;
                  4  3  2;
                  5  6  8;
                  7  8  6;
                  ];

    eval(['zef.' compartment_tags{reuna_type{box_ind,3}} '_points = reuna_p{box_ind};']);
    eval(['zef.' compartment_tags{reuna_type{box_ind,3}} '_triangles = reuna_t{box_ind};']);
    eval(['zef.' compartment_tags{reuna_type{box_ind,3}} '_submesh_ind = size(reuna_t{box_ind},1);']);
    reuna_submesh_ind{box_ind} = size(reuna_t{box_ind},1);
end

end

zef.sensors = sensors;
zef.reuna_p = reuna_p;
zef.reuna_t = reuna_t;
zef.reuna_p_inf = reuna_p_inf;
zef.reuna_submesh_ind = reuna_submesh_ind;
zef.reuna_type = reuna_type;
zef.reuna_mesh_ind = reuna_mesh_ind;

if nargout == 0
    assignin('base','zef',zef);
end


end
