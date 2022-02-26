%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
function [void] = color_label(tag_str)

void = [];

switch_val_1 = evalin('base',['zef.' tag_str '_on']);
switch_val_2 = evalin('base',['zef.' tag_str '_visible']);

if isvalid(evalin('base','zef.h_zeffiro'))
if switch_val_1 & switch_val_2
set(evalin('base',['zef.h_' tag_str '_label']),'visible','on');
set(evalin('base',['zef.h_' tag_str '_label']),'string',evalin('base',['zef.' tag_str '_name']));
else
set(evalin('base',['zef.h_' tag_str '_label']),'visible','off');
set(evalin('base',['zef.h_' tag_str '_label']),'string',evalin('base',['zef.' tag_str '_name']));
end
end

