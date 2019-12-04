%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
zef_data = zeffiro_interface_lf_bank_tool; 
zef.fieldnames = fieldnames(zef_data);
for zef_i = 1:length(zef.fieldnames)
zef.(zef.fieldnames{zef_i}) = zef_data.(zef.fieldnames{zef_i});
end        
clear zef_i zef_data;
set(zef.h_lf_bank_tool,'Name','ZEFFIRO Interface: LF bank tool');
zef.h_lf_item_list.ValueChangedFcn = 'zef.lf_item_selected = get(zef.h_lf_item_list,''value'');';
zef.h_add_lf_item.ButtonPushedFcn = '[zef.yesno] = questdlg(''Add current lead field?'',''Yes'',''No''); if isequal(zef.yesno,''Yes''); zef_add_lf_item; end;';
zef.h_lf_tag.ValueChangedFcn = 'zef.lf_tag = get(zef.h_lf_tag, ''Value'');';
zef.merge_lead_fields.ButtonPushedFcn = '[zef.yesno] = questdlg(''Merge selected lead fields?'',''Yes'',''No''); if isequal(zef.yesno,''Yes''); zef_combine_lead_fields; end;';
zef.delete_selected.ButtonPushedFcn = '[zef.yesno] = questdlg(''Delete selected lead field items?'',''Yes'',''No''); if isequal(zef.yesno,''Yes''); zef_delete_lf_item; end;';
zef.h_lf_normalization.ValueChangedFcn = 'zef.lf_normalization = find(ismember(get(zef.h_lf_normalization,''items''),get(zef.h_lf_normalization,''value'')));';
zef_init_lf_bank_tool;
