%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface

for zef_i = 1:length(zef.lf_bank_storage)

    if ismember(zef_i,zef.lf_item_selected)

        zef.lf_bank_storage{zef_i}.noise_data = zef.noise_data;

    end

end

clear zef_i;

zef_update_lf_bank_tool;