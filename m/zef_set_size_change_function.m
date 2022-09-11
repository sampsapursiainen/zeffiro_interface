function zef_set_size_change_function(h_window,type)

if nargin == 1
    type = 2; 
end

%if ismember('AutoResizeChildren',properties(h_window))
%h_window.AutoResizeChildren = 'off';
%end
warning off; 
    
if type == 1
h_window.UserData = struct; 
h_window.UserData.CurrentSize = get(h_window,'Position');
set(h_window,'SizeChangedFcn','set(gcbo,''UserData'',cell2struct({zef_change_size_function(gcbo,getfield(get(gcbo,''UserData''),''CurrentSize''))},{''CurrentSize''},1));');
end

if type == 2
h_window.UserData = struct; 
h_window.UserData.CurrentSize = get(h_window,'Position');
h_window.UserData.RelativeSize = zef_get_relative_size(h_window);
set(h_window,'SizeChangedFcn','set(gcbo,''UserData'',cell2struct({zef_change_size_function(gcbo,getfield(get(gcbo,''UserData''),''CurrentSize''),getfield(get(gcbo,''UserData''),''RelativeSize'')),getfield(get(gcbo,''UserData''),''RelativeSize'')},{''CurrentSize'',''RelativeSize''},2));');
end 

warning on;

end