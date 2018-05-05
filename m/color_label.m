%Copyright © 2018, Sampsa Pursiainen
function [void] = color_label(tag_str_1,tag_str_2,tag_str_3)

void = [];

switch_val_1 = get(evalin('base',['zef.h_' tag_str_1]),'value');
switch_val_2 = get(evalin('base',['zef.h_' tag_str_2]),'value');
if switch_val_1 & switch_val_2 
set(evalin('base',['zef.h_' tag_str_3]),'visible','on');
else
set(evalin('base',['zef.h_' tag_str_3]),'visible','off');    
end
    
