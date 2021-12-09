%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
function zef_import_figure

[file_name folder_name] = uigetfile({'*.fig'},'Open figure file',evalin('base','zef.save_file_path'));

if not(isequal(file_name,0));   
    
h_fig = open([folder_name '/' file_name]);

h_fig.Units = 'pixels';
h_fig.CurrentAxes.Units = 'pixels';
axes_position = h_fig.CurrentAxes.Position;
fig_position = h_fig.Position; 
tgb = findobj(get(gcf,'Children'),'Tag','togglecontrolsbutton');
user_data = tgb.UserData;
set(h_fig,'SizeChangedFcn',''); 

if isequal(user_data,2)
    
    fig_position(3) = round(axes_position(3)/0.9);
    fig_position(4) = round(axes_position(4)/0.6);
    
else 
    
    fig_position(3) = round(axes_position(3)/0.6);
    fig_position(4) = round(axes_position(4)/0.6);
    
end

end
    
end

















