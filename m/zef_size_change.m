set(gcf,'AutoResizeChildren','off');
zef.zeffiro_current_size{zef_fig_num} = get(gcf,'Position');
set(gcf,'Tag',num2str(zef_fig_num));
set(gcf,'SizeChangedFcn','zef.zeffiro_current_size{str2num(get(gcf,''Tag''))} = zef_change_size_function(gcf,zef.zeffiro_current_size{str2num(get(gcf,''Tag''))},[],{''Colorbar'',''image_details''});');
