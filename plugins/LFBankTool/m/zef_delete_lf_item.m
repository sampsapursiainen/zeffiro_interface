%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface

zef.lf_item_selected = get(zef.h_lf_item_list,'value');

zef_j = 0;
for zef_i = 1 : length(zef.lf_bank_storage)
    if not(ismember(zef_i,zef.lf_item_selected))
zef_j = zef_j + 1;
zef.lf_bank_storage{zef_j} =  zef.lf_bank_storage{zef_i};
zef.lf_item_list{zef_j} = zef.lf_item_list{zef_i};
    end
end

zef.lf_item_list = zef.lf_item_list(1:zef_j);
zef.lf_bank_storage = zef.lf_bank_storage(1:zef_j);
zef.lf_item_selected = [];

clear zef_i zef_j;

zef_update_lf_bank_tool;
zef_update;

zef.lf_item_selected = get(zef.h_lf_item_list,'value');