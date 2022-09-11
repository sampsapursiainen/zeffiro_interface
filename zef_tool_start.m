function [zef] = zef_tool_start(zef,tool_script)

visible_val = get(0,'DefaultFigureVisible');
set(0,'DefaultFigureVisible','off');
h_groot = groot;
h_groot_children_1 = findall(groot,'-regexp','Name','ZEFFIRO Interface*');
J = [];
if not(isempty(zef.zeffiro_variable_data)) & not(isempty(zef.project_matfile))
I = find(ismember(zef.zeffiro_variable_data(:,1),tool_script));
time_val = now;
for i = 1 : length(I) 
try
aux_var = load(zef.project_matfile,zeffiro_variable_data{I(i),2});
zef.(zeffiro_variable_data{I(i),2}) = aux_var.(zeffiro_variable_data{I(i),2});
zef.zeffiro_variable_data{I(i),3} = time_val;
catch
J(end+1) = I(i);
end
end
end
if not(isempty(J))
I = [1 : size(zef.zeffiro_variable_data,1)]';
I = setdiff(I,J);
zef.zeffiro_variable_data = zef.zeffiro_variable_data(I,:);
end
variable_list_1 = fieldnames(zef);

eval(tool_script);

variable_list_2 = fieldnames(zef);
h_groot_children_2 = findall(groot,'-regexp','Name','ZEFFIRO Interface*');
h_groot_children = setdiff(h_groot_children_2,h_groot_children_1);
set(h_groot_children,'Visible',zef.use_display);
variable_list = setdiff(variable_list_2,variable_list_1);
I = [];
for i = 1 : length(variable_list)
if not(any(ishandle(zef.(variable_list{i})))) | isnumeric(zef.(variable_list{i}))
I(end+1) = i;
end
end
variable_list = variable_list(I);
time_val = now;
variable_cell = [repmat({tool_script},length(variable_list),1) variable_list repmat({time_val},length(variable_list),1) repmat({time_val},length(variable_list),1) repmat({0},length(variable_list),1)];
if not(isempty(zef.zeffiro_variable_data))
variable_data_ind = [];
for j = 1 : size(variable_cell,1)
K = find(ismember(zef.zeffiro_variable_data(:,2),variable_cell(j,2)));
zef.zeffiro_variable_data(K,2:3) = variable_cell(j,2:3);
if not(isempty(K))
variable_data_ind(end+1) = j;
end
end
I = [1:size(variable_cell,1)]';
variable_data_ind = variable_data_ind(:);
variable_data_ind = setdiff(I,variable_data_ind);
variable_cell = variable_cell(variable_data_ind,:);
end
zef.zeffiro_variable_data = [zef.zeffiro_variable_data; variable_cell];
set(0,'DefaultFigureVisible',visible_val);

for i = 1 : length(h_groot_children)
    
if isempty(findobj(h_groot_children(i).Children,'Type','uitable'));
    zef_set_size_change_function(h_groot_children(i),1);
else
    zef_set_size_change_function(h_groot_children(i),2);
end
set(findobj(h_groot_children(i).Children,'-property','FontUnits'),'FontUnits','pixels')
set(findobj(h_groot_children(i).Children,'-property','FontSize'),'FontSize',zef.font_size);

if not(isempty(findobj(h_groot_children(i),'-property','Resize')))
h_groot_children(i).Resize = 'on';
end

if not(ismember('ZefTool',properties(h_groot_children(i))))
addprop(h_groot_children(i),'ZefTool');
end
h_groot_children(i).ZefTool = tool_script;

set(h_groot_children(i),'DeleteFcn',['zef_closereq(''' tool_script ''');'])

end

end