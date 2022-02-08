zef_data = zef_github_updater;
zef_assign_data;
zef.h_github_updater.Name = 'ZEFFIRO Interface: GitHub pusher tool';
zef.h_github_message.Value = 'A regular push adding the changes made in the current local repository to the remote origin. Contents of the folders ./data/ and ./profile/ are ignored. The update necessitates creating a personal access token.';
zef.h_github_author.Value = zef.user_tag;

zef.h_github_updater_button.ButtonPushedFcn = 'zef_githup_updater_script;';

set(findobj(zef.h_github_updater.Children,'-property','FontSize'),'FontSize',zef.font_size);

set(zef.h_github_updater,'AutoResizeChildren','off');
zef.github_updater_current_size = get(zef.h_github_updater,'Position');
set(zef.h_github_updater,'SizeChangedFcn','zef.github_updater_current_size = zef_change_size_function(zef.h_github_updater,zef.github_updater_current_size);');