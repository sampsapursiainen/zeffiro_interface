%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
function [void] = switch_color(tag_str_1,tag_str_2,variable_name)

void = [];

mlapp_flag = evalin('base','zef.mlapp');
if mlapp_flag == 1
   color_str = 'fontcolor';
else
color_str = 'foregroundcolor';
end

switch_val = get(evalin('base',['zef.h_' tag_str_1]),'value');
h=evalin('base',['zef.h_' tag_str_2]);
if switch_val
if  isempty(evalin('base',['zef.' variable_name]));
    set(h,color_str,[1 0 0]);
else
set(h,color_str,[0 0 0]);
end;
else
set(h,color_str,[0 0 0]);
end

