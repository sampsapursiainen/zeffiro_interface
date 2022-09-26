function zef_set_size_change_function(h_window,type,scale_positions)

if nargin < 2
    type = 2; 
end

if nargin < 3
    scale_positions = 1;
end

if isprop(h_window,'AutoResizeChildren')
set(h_window,'AutoResizeChildren','off');
end
warning off; 
    
if type == 1
h_window.UserData = struct; 
h_window.UserData.CurrentSize = get(h_window,'Position');
set(h_window,'SizeChangedFcn',['zef.h_aux = get(gcbo,''UserData''); zef.h_aux.CurrentSize = zef_change_size_function(gcbo,getfield(get(gcbo,''UserData''),''CurrentSize''),[],cell(0),' num2str(scale_positions) ');set(gcbo,''UserData'',zef.h_aux);']);
end

if type == 2
h_window.UserData = struct; 
h_window.UserData.CurrentSize = get(h_window,'Position');
h_window.UserData.RelativeSize = zef_get_relative_size(h_window);
set(h_window,'SizeChangedFcn',['zef.h_aux = get(gcbo,''UserData''); zef.h_aux.CurrentSize = zef_change_size_function(gcbo,getfield(get(gcbo,''UserData''),''CurrentSize''),getfield(get(gcbo,''UserData''),''RelativeSize''),cell(0),' num2str(scale_positions) ');set(gcbo,''UserData'',zef.h_aux);']);
end 

warning on;

end