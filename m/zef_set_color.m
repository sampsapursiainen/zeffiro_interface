function zef_set_color

color_vec = uisetcolor;
item_ind = evalin('base','zef.h_compartment_color.Value');
item_ind = length(evalin('base','zef.compartment_tags')) - item_ind + 1;
compartment_tag = evalin('base',['zef.compartment_tags{' num2str(item_ind) '}']);
evalin('base',['zef.' compartment_tag '_color = [' num2str(color_vec) '];']);

end
