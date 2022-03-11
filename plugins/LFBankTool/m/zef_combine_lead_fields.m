%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface

zef.lf_item_selected = get(zef.h_lf_item_list,'value');
zef.L = [];
zef.measurements = [];
zef.source_positions = [];
zef.source_directions = [];
zef_delete_original_field;

zef.lf_n_aux = 0;
zef.lf_size_aux = 0;
zef_jj = 0;
for zef_ii = sort(zef.lf_item_selected)
    zef_jj = zef_jj + 1;
    zef.lf_n_aux = zef.lf_n_aux + norm(zef.lf_bank_storage{zef_ii}.L,'fro').^2;
    zef.aux_field = str2func(zef.lf_normalization_functions_file_list{zef.lf_normalization});
    [zef.L_aux, zef.measurements_aux] = zef.aux_field(zef_ii);
    zef.measurements = [zef.measurements ; zef.measurements_aux];
    zef.L = [zef.L ; zef.L_aux];

    if zef_jj == 1
        zef.source_positions = [zef.lf_bank_storage{zef_ii}.source_positions];
        zef.source_directions = [zef.lf_bank_storage{zef_ii}.source_directions];
        zef.source_interpolation_ind = [zef.lf_bank_storage{zef_ii}.source_interpolation_ind];
        zef.parcellation_interp_ind = [zef.lf_bank_storage{zef_ii}.parcellation_interp_ind];

        zef.imaging_method = find(ismember(zef.imaging_method_cell, zef.lf_bank_storage{zef_ii}.imaging_method),1);
        zef.sensors = zef.lf_bank_storage{zef_ii}.sensors;
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
        zef_update;

    end
end

if zef.lf_normalization == 2
    zef.aux_field = norm(zef.L,'fro');
    zef.measurements = sqrt(zef.lf_n_aux)*zef.measurements/norm(zef.L,'fro');
    zef.L = sqrt(zef.lf_n_aux)*zef.L/norm(zef.L,'fro');
end
zef = rmfield(zef,'lf_n_aux');
zef = rmfield(zef,'measurements_aux');
zef = rmfield(zef,'L_aux');

clear zef_i zef_jj;

zef_update;
