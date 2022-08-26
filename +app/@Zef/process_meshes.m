function self = process_meshes(self)

    % process_meshes
    %
    % Processes a contained finite element mesh.

    arguments
        self app.Zef
    end

    reuna_p_inf = [];

    output_mode = 'compact';

    explode_param = self.explode_everything;

    i = 0;
    sensors = [];
    reuna_p = cell(0);
    reuna_t = cell(0);
    reuna_p_inf = cell(0);
    reuna_submesh_ind = cell(0);
    reuna_type = cell(0);

    compartment_tags = self.compartment_tags;

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

    on_val = evalin('base',var_0);

    if on_val

        i = i + 1;
        reuna_p_inf{i} = evalin('base',var_8);
        reuna_p{i} = evalin('base',var_9);
        reuna_t{i} = evalin('base',var_10);
        reuna_type{i,1} = evalin('base',var_12);
        reuna_type{i,2} = evalin('base',['zef.compartment_activity{' var_12 '+2' '}']);
        reuna_type{i,3} = k;
        reuna_type{i,4} = compartment_tags{k};
        reuna_submesh_ind{i} = evalin('base',var_11);
        mean_vec = repmat(mean(reuna_p{i},1),size(reuna_p{i},1),1);

        for t_ind = 1 : length(evalin('base',var_1))

            scaling_val = evalin('base',[var_1 '(' num2str(t_ind) ')']);
            translation_vec(1) = evalin('base',[var_2 '(' num2str(t_ind) ')']);
            translation_vec(2) = evalin('base',[var_3 '(' num2str(t_ind) ')']);
            translation_vec(3) = evalin('base',[var_4 '(' num2str(t_ind) ')']);
            theta_angle_vec(1) =  evalin('base',[var_5 '(' num2str(t_ind) ')']);
            theta_angle_vec(2) =  evalin('base',[var_6 '(' num2str(t_ind) ')']);
            theta_angle_vec(3) =  evalin('base',[var_7 '(' num2str(t_ind) ')']);

            if evalin('base',['isfield(zef,''' var_14 ''')'])

                if evalin('base',['length(' var_13 ')']) >= t_ind
                    affine_transform =  cell2mat(evalin('base',[var_13 '(' num2str(t_ind) ')']));
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
                    reuna_p_inf{i} = scaling_val*reuna_p_inf{i};
                end

                for j = 1 : 3

                    switch j
                        case 1
                            axes_ind = [1 2];
                        case 2
                            axes_ind = [2 3];
                        case 3
                            axes_ind = [3 1];
                    end % switch

                    if theta_angle_vec(j) ~= 0

                        theta_angle = theta_angle_vec(j)*pi/180;
                        R_mat = [cos(theta_angle) -sin(theta_angle); sin(theta_angle) cos(theta_angle)];
                        reuna_p{i}(:,axes_ind) = (reuna_p{i}(:,axes_ind)-mean_vec(:,axes_ind))*R_mat' + mean_vec(:,axes_ind);
                        reuna_p_inf{i}(:,axes_ind) = (reuna_p_inf{i}(:,axes_ind)-mean_vec(:,axes_ind))*R_mat' + mean_vec(:,axes_ind);

                    end % if

                end % for

                for j = 1 : 3

                    if translation_vec(j) ~= 0
                        reuna_p{i}(:,j) = reuna_p{i}(:,j) + translation_vec(j);
                        reuna_p_inf{i}(:,j) = reuna_p_inf{i}(:,j) + translation_vec(j);
                    end

                end % for

            end % if

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

                end % for

            end % if

        end % for

    end % if

    sensor_tag = evalin('base','zef.current_sensors');

    s_points = evalin('base',['zef.' sensor_tag '_points']);
    s_data_aux = [];

    if ismember(evalin('base','zef.imaging_method'),1)

        f_handle = evalin('base','zef.create_patch_sensor');

        if not(isempty(f_handle))
            s_points = f_handle(s_points);
        end

    end % if

    if ismember(evalin('base','zef.imaging_method'),[2 3])

        s_directions = evalin('base',['zef.' sensor_tag '_directions(:,1:3)']);
        s_directions_g = [];

        if size(evalin('base',['zef.' sensor_tag '_directions']),2) == 6
            s_directions_g = evalin('base',['zef.' sensor_tag '_directions(:,4:6)']);
        end

    else

        if size(s_points,2)==6
            s_data_aux = s_points(:,4:6);
            s_points = s_points(:,1:3);
        end

        s_directions = [];
        s_directions_g = [];

    end % if

    s_scaling = evalin('base',['zef.' sensor_tag '_scaling']);
    s_x_correction = evalin('base',['zef.' sensor_tag '_x_correction']);
    s_y_correction = evalin('base',['zef.' sensor_tag '_y_correction']);
    s_z_correction = evalin('base',['zef.' sensor_tag '_z_correction']);
    s_xy_rotation = evalin('base',['zef.' sensor_tag '_xy_rotation']);
    s_yz_rotation = evalin('base',['zef.' sensor_tag '_yz_rotation']);
    s_zx_rotation = evalin('base',['zef.' sensor_tag '_zx_rotation']);

    if evalin('base',['isfield(zef,''' sensor_tag '_affine_transform'')']);
        s_affine_transform = evalin('base',['zef.' sensor_tag '_affine_transform']);
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

    end % if

    use_pem = 0;

    if ismember(evalin('base','zef.imaging_method'),[1 5])
        use_pem = evalin('base','zef.use_pem');
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

                if size(sensors_aux,2) >= 6 && ismember(evalin('base','zef.imaging_method'),[2 3])
                    sensors(:,4:6) = sensors(:,4:6)*s_affine_transform{t_ind}(1:3,1:3)';
                end

                if size(sensors_aux,2) >= 9 && ismember(evalin('base','zef.imaging_method'),[3])
                    sensors(:,7:9) = sensors(:,7:9)*s_affine_transform{t_ind}(1:3,1:3)';
                end

            end % if

            if scaling_val ~= 1
                sensors(:,1:3) = scaling_val * sensors(:,1:3);
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
                end % switch

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

                end % if

            end % for

            for j = 1 : 3

                if translation_vec(j) ~= 0

                    sensors(:,j) = sensors(:,j) + translation_vec(j);

                end

            end % for

        end % if

    end % for

    if not(isempty(sensors))

        for j = 1 : 3
            sensors(:,j) = sensors(:,j)  +  (explode_param-1)*(sensors(:,j) - mean(sensors(:,j),1));
        end

        if not(isempty(s_data_aux))
            sensors = [sensors s_data_aux];
        end

    else

        sensors = [NaN NaN NaN];

    end % if

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

    end % for

    if not(isequal(box_ind,0))

        pml_outer_radius_unit = evalin('base','zef.pml_outer_radius_unit');
        pml_outer_radius = evalin('base','zef.pml_outer_radius');

        if pml_outer_radius_unit == 1
            box_outer_radius = pml_outer_radius*max_val;
        elseif pml_outer_radius_unit == 2
            box_outer_radius = pml_outer_radius;
        end

        reuna_p{box_ind} = [
            -box_outer_radius   -box_outer_radius   -box_outer_radius;
            box_outer_radius    -box_outer_radius   -box_outer_radius;
            box_outer_radius    box_outer_radius    -box_outer_radius;
            -box_outer_radius   box_outer_radius    -box_outer_radius;
            -box_outer_radius   -box_outer_radius   box_outer_radius ;
            box_outer_radius    -box_outer_radius   box_outer_radius;
            box_outer_radius    box_outer_radius    box_outer_radius;
            -box_outer_radius   box_outer_radius    box_outer_radius;
        ];

        reuna_t{box_ind} = [
            1  2  6;
            6  5  1;
            3  4  7;
            8  7  4;
            2  3  7;
            2  7  6;
            5  1  8;
            4  1  8;
            2  1  4;
            4  3  2;
            5  6  8;
            7  8  6;
        ];

        assignin('base','zef_data',reuna_p{box_ind});
        evalin('base',['zef.' compartment_tags{reuna_type{box_ind,3}} '_points = zef_data;']);
        assignin('base','zef_data',reuna_t{box_ind});
        evalin('base',['zef.' compartment_tags{reuna_type{box_ind,3}} '_triangles = zef_data;']);
        evalin('base',['zef.' compartment_tags{reuna_type{box_ind,3}} '_submesh_ind = size(zef_data,1);']);
        evalin('base','clear zef_data;');

    end % if

    if nargout == 0
        zef_data.sensors = sensors;
        zef_data.reuna_p = reuna_p;
        zef_data.reuna_t = reuna_t;
        zef_data.reuna_p_inf = reuna_p_inf;
        zef_data.reuna_submesh_ind = reuna_submesh_ind;
        zef_data.reuna_type = reuna_type;
        assignin('base', 'zef_data', zef_data);
        evalin('base', 'zef_assign_data;');
    end % if

end % function
