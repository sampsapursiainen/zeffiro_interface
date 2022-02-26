%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
zef_data = zeffiro_interface_lf_bank_tool;
zef.fieldnames = fieldnames(zef_data);
for zef_i = 1:length(zef.fieldnames)
zef.(zef.fieldnames{zef_i}) = zef_data.(zef.fieldnames{zef_i});
end
clear zef_i zef_data;
set(zef.h_lf_bank_tool,'Name','ZEFFIRO Interface: Multi lead field tool');
set(findobj(zef.h_lf_bank_tool.Children,'-property','FontUnits'),'FontUnits','pixels')
set(findobj(zef.h_lf_bank_tool.Children,'-property','FontSize'),'FontSize',9);
zef.h_lf_item_list.ValueChangedFcn = 'zef.lf_item_selected = get(zef.h_lf_item_list,''value'');';
zef.h_lf_item_list.ItemsData=1;
zef.h_add_lf_item.ButtonPushedFcn = 'zef_add_lf_item;';
zef.h_lf_tag.ValueChangedFcn = 'zef.lf_tag = get(zef.h_lf_tag, ''Value'');';
zef.h_lf_bank_scaling_factor.ValueChangedFcn = 'zef.lf_bank_scaling_factor = str2num(get(zef.h_lf_bank_scaling_factor, ''Value''));';
zef.h_merge_lead_fields.ButtonPushedFcn = '[zef.yesno] = questdlg(''Merge selected lead fields?'',''Yes'',''No''); if isequal(zef.yesno,''Yes''); zef_combine_lead_fields; end;';
zef.h_delete_selected.ButtonPushedFcn = '[zef.yesno] = questdlg(''Delete selected lead field items?'',''Yes'',''No''); if isequal(zef.yesno,''Yes''); zef_delete_lf_item; end;';
zef.h_lf_normalization.ValueChangedFcn = 'zef.lf_normalization = find(ismember(get(zef.h_lf_normalization,''items''),get(zef.h_lf_normalization,''value'')));';
zef.h_lf_bank_compute_lead_fields.ButtonPushedFcn = '[zef.yesno] = questdlg(''Re-calculate the lead field matrices for the selected items?'',''Yes'',''No''); if isequal(zef.yesno,''Yes''); zef_lf_bank_compute_lead_fields; end;';
zef.h_lf_bank_update_measurements.ButtonPushedFcn = '[zef.yesno] = questdlg(''Substitute the measurement data of the selected lead field items with the current measurement data?'',''Yes'',''No''); if isequal(zef.yesno,''Yes''); zef_lf_bank_update_measurements; end;';
zef.h_lf_bank_update_noise_data.ButtonPushedFcn = '[zef.yesno] = questdlg(''Substitute the noise data of the selected lead field items with the current noise data?'',''Yes'',''No''); if isequal(zef.yesno,''Yes''); zef_lf_bank_update_noise_data; end;';
zef.h_lf_bank_make_all.ButtonPushedFcn = '[zef.yesno] = questdlg(''Create a mesh and calculate the lead field matrices for the selected items?'',''Yes'',''No''); if isequal(zef.yesno,''Yes''); zef.source_interpolation_on = 1; if isfield(zef,''h_source_interpolation_on''); if isvalid(''zef.h_source_interpolation_on''); set(zef.h_source_interpolation_on,''value'',1); end; end; zef_process_meshes; zef_create_fem_mesh; zef_postprocess_fem_mesh; zef.n_sources_mod = 1; zef.source_ind = []; zef_update_fig_details;zef_lf_bank_compute_lead_fields; end;';
zef_init_lf_bank_tool;

set(zef.h_lf_bank_tool,'AutoResizeChildren','off');
zef.lf_bank_tool_current_size = get(zef.h_lf_bank_tool,'Position');
set(zef.h_lf_bank_tool,'SizeChangedFcn','zef.lf_bank_tool_current_size = zef_change_size_function(zef.h_lf_bank_tool,zef.lf_bank_tool_current_size);');
