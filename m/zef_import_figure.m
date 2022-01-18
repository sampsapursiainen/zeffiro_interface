%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
function zef_import_figure

[file_name folder_name] = uigetfile({'*.fig'},'Open figure file',evalin('base','zef.save_file_path'));

if not(isequal(file_name,0));   
    
h_fig = open([folder_name '/' file_name]);

set(h_fig,'MenuBar','figure');
h_fig.Units = 'pixels';
h_fig.CurrentAxes.Units = 'pixels';

set(h_fig,'SizeChangedFcn','');

scale_param = 0.94; 
figure_width = h_fig.Position(3);
figure_height = h_fig.Position(4);

h_c = h_fig.Children; 
min_x = Inf; 
max_x = 0;
min_y = Inf; 
max_y = 0;
for i = 1 : length(h_c)
    h_c(i).Units = 'pixels';
    min_x = min(h_c(i).OuterPosition(1),min_x);
    max_x = max(sum(h_c(i).OuterPosition([1 3])),max_x);
    min_y = min(h_c(i).OuterPosition(2),min_y);
    max_y = max(sum(h_c(i).OuterPosition([2 4])),max_y);
end
scale_factor_x = figure_width/(max_x-min_x);
scale_factor_y = figure_height/(max_y-min_y);
scale_factor = min(scale_factor_x, scale_factor_y);
if scale_factor_y < scale_factor_x
  h_fig.Position(3) = (scale_factor_y/scale_factor_x)*h_fig.Position(3);
else
  h_fig.Position(4) = (scale_factor_x/scale_factor_y)*h_fig.Position(4);
end
for i = 1 : length(h_c)
    h_c(i).OuterPosition = scale_param*scale_factor*h_c(i).OuterPosition; 
    h_c(i).OuterPosition(1) = h_c(i).OuterPosition(1) - scale_param*scale_factor*min_x + (1-scale_param)*figure_width/2;
    h_c(i).OuterPosition(2) = h_c(i).OuterPosition(2) - scale_param*scale_factor*min_y + (1-scale_param)*figure_height/2;
end


h_fig.Tag = '';
if contains(get(h_fig,'Name'),'ZEFFIRO Interface: Figure tool')
     set(h_fig,'Name',['ZEFFIRO Interface: Figure tool ' num2str(zef_fig_num)]);
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











