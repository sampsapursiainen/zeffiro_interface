%Copyright © 2018, Sampsa Pursiainen
function [void] = switch_color(tag_str_1,tag_str_2,variable_name)

void = [];

switch_val = get(evalin('base',['zef.h_' tag_str_1]),'value');
h=evalin('base',['zef.h_' tag_str_2]); 
if switch_val 
if  isempty(evalin('base',['zef.' variable_name]));  
    set(h,'foregroundcolor',[1 0 0]); 
else
set(h,'foregroundcolor',[0 0 0]);    
end; 
else
set(h,'foregroundcolor',[0 0 0]); 
end
    
