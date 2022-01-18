%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
function zef_import_figure

[file_name folder_name] = uigetfile({'*.fig'},'Open figure file',evalin('base','zef.save_file_path'));

if not(isequal(file_name,0));   
    
h_fig = open([folder_name '/' file_name]);

set(h_fig,'MenuBar','figure');
h_fig.Units = 'pixels';
h_fig.CurrentAxes.Units = 'pixels';
axes_position = h_fig.CurrentAxes.Position;
fig_position = h_fig.Position; 
tgb = findobj(get(h_fig,'Children'),'Tag','togglecontrolsbutton');
if not(isempty(tgb))
user_data = tgb.UserData;
%set(h_fig,'SizeChangedFcn',''); 

if isequal(user_data,2)
    
    fig_position(3) = round(axes_position(3)/0.9);
    fig_position(4) = round(axes_position(4)/0.6);
    
else 
    
    fig_position(3) = round(axes_position(3)/0.6);
    fig_position(4) = round(axes_position(4)/0.6);
    
end
end


h_fig.Tag = '';
if contains(get(h_fig,'Name'),'ZEFFIRO Interface: Figure tool')
     set(h_fig,'Name',[get(h_fig,'Name') ' ' num2str(zef_fig_num)]);
else
    set(h_fig,'Name',['ZEFFIRO Interface: Figure tool ' num2str(zef_fig_num)]);
end
set(h_fig,'AutoResizeChildren','off');
assignin('base','zef_data',get(h_fig,'Position'));
evalin('base','zef.zeffiro_current_size{zef_fig_num} = zef_data; clear zef_data;');
set(h_fig,'Tag',num2str(zef_fig_num));
set(h_fig,'SizeChangedFcn','zef.zeffiro_current_size{str2num(get(gcf,''Tag''))} = zef_change_size_function(gcf,zef.zeffiro_current_size{str2num(get(gcf,''Tag''))},[],{''Colorbar'',''image_details''});');

h_fig.Name = [h_fig.Name ' ' '{' file_name '}'];
h_aux_1 = findobj(h_fig.Children,'Style','listbox');
h_aux_2 = findobj(h_aux_1,'Tag','system_information');
if not(isempty(h_aux_1))
if isempty(h_aux_2)
h_aux_2 = h_aux_1(1);
end
h_aux_2.String{length(h_aux_2.String)+1} = ['File name: ' file_name];
h_aux_2.String{length(h_aux_2.String)+1} = ['Folder name: ' folder_name];
end

end
    
end











