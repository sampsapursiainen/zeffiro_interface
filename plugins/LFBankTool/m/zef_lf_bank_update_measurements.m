%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface

zef.lf_item_selected = get(zef.h_lf_item_list,'value');

for zef_i = 1:length(zef.lf_bank_storage)

    if ismember(zef_i,zef.lf_item_selected)

        zef.lf_bank_storage{zef_i}.measurements = zef.measurements;

    end

end

clear zef_i;

zef_update_lf_bank_tool;
