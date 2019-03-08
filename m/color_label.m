%Copyright © 2018, Sampsa Pursiainen
function [void] = color_label(tag_str)

void = [];

switch_val_1 = get(evalin('base',['zef.h_' tag_str '_on']),'value');
switch_val_2 = get(evalin('base',['zef.h_' tag_str '_visible']),'value');

if isvalid(evalin('base','zef.h_zeffiro'))
if switch_val_1 & switch_val_2 
set(evalin('base',['zef.h_' tag_str '_label']),'visible','on');
set(evalin('base',['zef.h_' tag_str '_label']),'string',evalin('base',['zef.' tag_str '_name']));
else
set(evalin('base',['zef.h_' tag_str '_label']),'visible','off');    
set(evalin('base',['zef.h_' tag_str '_label']),'string',evalin('base',['zef.' tag_str '_name']));
end
end
    
