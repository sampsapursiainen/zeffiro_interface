function zef_closereq(tool_name)

if nargin==0
    tool_name ='';
end

if not(isempty(tool_name))
  h_tool = findall(groot,'ZefTool',tool_name);
end

% if evalin('base','exist(''zef'',''var'');')
%     zef = evalin('base','zef');
%     
%     if not(isempty(tool_name)) & not(isempty(h_tool))
%         time_val = now;
%         if not(isempty(zef.matfile_object))
%     I = find(ismember(zef.zeffiro_variable_data(:,1),tool_name));
%     for i = 1 : length(I)
%     if isfield(zef,zef.zeffiro_variable_data{I(i),2})
%         zef.matfile_object.(zef.zeffiro_variable_data{I(i),2}) = zef.(zef.zeffiro_variable_data{I(i),2});
%         zef.zeffiro_variable_data{I(i),5} = time_val;
%         zef = rmfield(zef,zef.zeffiro_variable_data{I(i),2});
%     end
%     end
%         end
%     if not(isempty(h_tool))
%     zef = zef_remove_object_handles(zef,[],cat(1,cat(1,h_tool.Children)));  
%     else
%     zef = zef_remove_object_handles(zef,[],cat(1,get(gcbo,'Children')));
%     end
%     else
%     zef = zef_remove_object_handles(zef,[],cat(1,get(gcbo,'Children')));
%     end
%     
%     keyboard
%     assignin('base','zef',zef);
%     
% end


if not(isempty(tool_name))
delete(h_tool)
else
closereq;
end

end