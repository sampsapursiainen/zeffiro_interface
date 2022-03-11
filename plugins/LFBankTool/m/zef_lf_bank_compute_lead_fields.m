%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface

zef.lf_item_selected = get(zef.h_lf_item_list,'value');
zef.aux_field = get(zef.h_source_interpolation_on,'value');

for zef_i = 1:length(zef.lf_bank_storage)

    if ismember(zef.lf_item_list{zef_i},zef.lf_item_selected)
        zef.imaging_method = find(ismember(zef.imaging_method_cell, zef.lf_bank_storage{zef_i}.imaging_method),1);
        zef.sensors = zef.lf_bank_storage{zef_i}.sensors;
        if isvalid(zef.h_mesh_tool)
        zef_update_mesh_tool;
        end
        if size(zef.sensors,2) >= 3
        zef.s_points = zef.sensors(:,1:3);
        end
        if size(zef.sensors,2) > 3
        zef.s_directions = zef.sensors(:,4:end);
        end
        zef.s_scaling = 1;
        zef.s_x_correction = 0;
        zef.s_y_correction = 0;
        zef.s_z_correction = 0;
        zef.s_xy_rotation = 0;
        zef.s_yz_rotation = 0;
        zef.s_zx_rotation = 0;

        if zef.source_interpolation_on == 1 && zef_i > 1
        zef.source_interpolation_on = 0;
        if isfield(zef,'h_source_interpolation_on')
        if isvalid('zef.h_source_interpolation_on')
        set(zef.h_source_interpolation_on,'value',0);
        end
        end
        end

        if isfield(zef,'h_mesh_tool')
        if isvalid('zef.h_mesh_tool')
        zef_update_mesh_tool;
        end
        end
        zef_update;

        zef_process_meshes;
        zef_attach_sensors_volume(zef.sensors);
        lead_field_matrix;

        zef.lf_bank_storage{zef_i}.source_interpolation_ind = zef.source_interpolation_ind;
        zef.lf_bank_storage{zef_i}.parcellation_interp_ind = zef.parcellation_interp_ind;
        zef.lf_bank_storage{zef_i}.source_positions = zef.source_positions;
        zef.lf_bank_storage{zef_i}.source_directions = zef.source_directions;
        zef.lf_bank_storage{zef_i}.L = zef.L;

        zef_update_lf_bank_tool;
        zef_update;

        end

        end

        zef.source_interpolation_on = zef.aux_field;
        if isfield(zef,'h_source_interpolation_on')
        if isvalid('zef.h_source_interpolation_on')
        set(zef.h_source_interpolation_on,'value',zef.source_interpolation_on);
        end
        end

        if isfield(zef,'h_mesh_tool')
        if isvalid('zef.h_mesh_tool')
        zef_update_mesh_tool;
        end
        end

clear zef_i;

zef_update_lf_bank_tool;
zef_update;
