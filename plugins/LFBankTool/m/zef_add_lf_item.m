%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface

if not(isempty(zef.s_points))
zef_process_meshes;
end

zef_i = length(zef.lf_bank_storage)+1;

zef.lf_bank_storage{zef_i}.source_interpolation_ind = zef.source_interpolation_ind;
zef.lf_bank_storage{zef_i}.parcellation_interp_ind = zef.parcellation_interp_ind;
zef.lf_bank_storage{zef_i}.source_positions = zef.source_positions;
zef.lf_bank_storage{zef_i}.source_directions = zef.source_directions;
zef.lf_bank_storage{zef_i}.L = zef.L;
zef.lf_bank_storage{zef_i}.sensors = zef.sensors;
zef.lf_bank_storage{zef_i}.imaging_method = zef.imaging_method_cell{zef.imaging_method};
zef.lf_bank_storage{zef_i}.measurements = zef.measurements;
zef.lf_bank_storage{zef_i}.noise_data = zef.noise_data;
zef.lf_bank_storage{zef_i}.scaling_factor = zef.lf_bank_scaling_factor;
zef.lf_bank_storage{zef_i}.lf_tag = zef.lf_tag;

clear zef_i;

zef_update_lf_bank_tool;
zef_update;

