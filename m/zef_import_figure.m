%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
function zef_import_figure

evalin('base','zef.zeffiro_current_size_aux = zef.zeffiro_current_size;');
evalin('base','zef.zeffiro_current_size = cell(0);');

if evalin('base','zef.use_display')
[file_name folder_name] = uigetfile({'*.fig'},'Open figure file',evalin('base','zef.save_file_path'));
else
    file_name = evalin('base','zef.file');
    folder_name = evalin('base','zef.file_path');
end

if not(isequal(file_name,0));

h_fig = open([folder_name '/' file_name]);
set(h_fig,'Tag','');
set(h_fig,'SizeChangedFcn','');

evalin('base','zef.zeffiro_current_size = zef.zeffiro_current_size_aux;');

set(h_fig,'MenuBar','figure');
h_fig.Units = 'normalized';
set(h_fig,'AutoResizeChildren','off');
h_fig.Units = 'normalized';
h_c = h_fig.Children;
for i = 1 : length(h_c)
    if find(ismember(properties(h_c(i)),'Units'))
h_c(i).Units = 'normalized';
    end
        if find(ismember(properties(h_c(i)),'FontUnits'))
h_c(i).FontUnits = 'normalized';
    end
end
h_fig.Position = [0.25 0.25 0.4 0.5];

scale_param = 0.9;
figure_width = 1;
figure_height = 1;

min_x = Inf;
max_x = 0;
min_y = Inf;
max_y = 0;
for i = 1 : length(h_c)

       if find(ismember(properties(h_c(i)),'Position'))
           if not(isequal(get(h_c(i),'Type'),'colorbar')) && not(isequal(get(h_c(i),'Visible'),false))
    min_x = min(h_c(i).Position(1),min_x);
    max_x = max(sum(h_c(i).Position([1 3])),max_x);
    min_y = min(h_c(i).Position(2),min_y);
    max_y = max(sum(h_c(i).Position([2 4])),max_y);
           end
       end
end
scale_factor_x = figure_width/(max_x-min_x)
scale_factor_y = figure_height/(max_y-min_y)
scale_factor = min(scale_factor_x, scale_factor_y)
%if scale_factor_y < scale_factor_x
%  h_fig.Position(3) = (scale_factor_y/scale_factor_x)*h_fig.Position(3);
%else
%  h_fig.Position(4) = (scale_factor_x/scale_factor_y)*h_fig.Position(4);
%end

for i = 1 : length(h_c)
    % if find(ismember(properties(h_c(i)),'OuterPosition'))
    %h_c(i).OuterPosition = scale_param*scale_factor*h_c(i).OuterPosition;
    %h_c(i).OuterPosition(1) = h_c(i).OuterPosition(1) - scale_param*scale_factor*min_x + (1-scale_param*scale_factor*(max_x-min_x))/2;
    %h_c(i).OuterPosition(2) = h_c(i).OuterPosition(2) - scale_param*scale_factor*min_y + (1-scale_param*scale_factor*(max_y-min_y))/2;
    if find(ismember(properties(h_c(i)),'Position'))
            if not(isequal(get(h_c(i),'Type'),'colorbar'))
    h_c(i).Position = scale_param*scale_factor*h_c(i).Position;
    h_c(i).Position(1) = h_c(i).Position(1) - scale_param*scale_factor*min_x + (1-scale_param*scale_factor*(max_x-min_x))/2;
    h_c(i).Position(2) = h_c(i).Position(2) - scale_param*scale_factor*min_y + (1-scale_param*scale_factor*(max_y-min_y))/2;
            end
     end
    if find(ismember(properties(h_c(i)),'FontSize'))
    h_c(i).FontSize = scale_param*scale_factor*h_c(i).FontSize;
end
end
% h_fig.Position(4) = h_fig.Position(4) - (1-scale_param)*figure_width/8;

h_fig.Units = 'normalized';
for i = 1 : length(h_c)
    if find(ismember(properties(h_c(i)),'Units'))
        if not(isequal(h_c(i).Type,'colorbar'))
h_c(i).Units = 'pixels';
        end
    end
        if find(ismember(properties(h_c(i)),'FontUnits'))
        if not(isequal(h_c(i).Type,'colorbar'))
h_c(i).FontUnits = 'pixels';
        end
    end
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

set(h_fig,'SizeChangedFcn','zef_set_figure_current_size;');

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

evalin('base','zef = rmfield(zef,''zeffiro_current_size_aux'');');

end

