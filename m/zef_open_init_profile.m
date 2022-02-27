zef_data = zef_init_profile;
zef_assign_data;

if isempty(zef.init_profile)
zef.init_profile = readcell([zef.program_path '/profile/' zef.profile_name '/zeffiro_init.ini'],'filetype','text','delimiter',',');
end
zef.h_init_profile_table.Data = zef.init_profile;

set(zef.h_init_profile_table,'CellSelectionCallback',@zef_init_profile_table_selection);

set(zef.h_init_profile_save,'ButtonPushedFcn','zef.init_profile = zef.h_init_profile_table.Data;writecell(zef.h_init_profile_table.Data,[zef.program_path ''/profile/'' zef.profile_name ''/zeffiro_init.ini''],''filetype'',''text'',''delimiter'','','');');
set(zef.h_init_profile_apply,'ButtonPushedFcn','zef.init_profile = zef.h_init_profile_table.Data;writecell(zef.h_init_profile_table.Data,[zef.program_path ''/profile/'' zef.profile_name ''/zeffiro_init.ini''],''filetype'',''text'',''delimiter'','','');zef_apply_init_profile;');

set(zef.h_init_profile_update_from_profile,'ButtonPushedFcn','zef.init_profile = readcell([zef.program_path ''/profile/'' zef.profile_name ''/zeffiro_init.ini''],''filetype'',''text'',''delimiter'','','');zef.h_init_profile_table.Data = zef.init_profile;');

set(zef.h_init_profile_table,'columnformat',{'char','char','char',{'number','string'}});

set(zef.h_menu_init_profile_add,'MenuSelectedFcn','zef.h_init_profile_table.Data{end+1,1} = []; zef.h_init_profile_table.Data = [zef.h_init_profile_table.Data(1:zef.init_profile_selected(1),:) ; zef.h_init_profile_table.Data(end,:) ; zef.h_init_profile_table.Data(zef.init_profile_selected(1)+1:end-1,:)];');

set(zef.h_menu_init_profile_delete,'MenuSelectedFcn','zef.h_init_profile_table.Data = zef.h_init_profile_table.Data(find(not(ismember([1:size(zef.h_init_profile_table.Data,1)],zef.init_profile_selected))),:);');

set(findobj(zef.h_init_profile.Children,'-property','FontSize'),'FontSize',zef.font_size);

set(zef.h_init_profile,'AutoResizeChildren','off');
zef.init_profile_current_size = get(zef.h_init_profile,'Position');
zef.init_profile_relative_size = zef_get_relative_size(zef.h_init_profile);
set(zef.h_init_profile,'SizeChangedFcn','zef.init_profile_current_size = zef_change_size_function(zef.h_init_profile,zef.init_profile_current_size,zef.init_profile_relative_size);');

zef.h_init_profile.Name = 'ZEFFIRO Interface: Initialization profile';