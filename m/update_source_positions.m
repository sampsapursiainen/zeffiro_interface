%Copyright © 2018, Sampsa Pursiainen
function [source_positions] = update_source_positions(void)

location_unit_current = evalin('base','zef.location_unit_current');
location_unit = evalin('base','zef.location_unit');
source_positions = evalin('base','zef.source_positions');

switch location_unit_current
case 1
b = 1000;
case 2 
b = 100;
case 3
b = 1;
end
switch location_unit
case 1
a = 1000;
case 2 
a = 100;
case 3
a = 1;
end

if not(isempty(source_positions))
source_positions = (a/b)*source_positions;
end