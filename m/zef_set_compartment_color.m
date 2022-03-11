function zef_set_compartment_color

color_vec = uisetcolor;
item_ind = evalin('base','zef.h_compartment_visible_color.Value');
compartment_tags = evalin('base','zef.compartment_tags');

zef_j = 0;
for zef_i = length(compartment_tags) : -1 : 1
    if evalin('base',['zef.' compartment_tags{zef_i} '_on']) && evalin('base',['zef.' compartment_tags{zef_i} '_visible'])
    zef_j = zef_j + 1;

    if zef_j == item_ind
        item_ind = zef_i;
        break;
    end

    end
end

evalin('base',['zef.' compartment_tags{item_ind} '_color = [' num2str(color_vec) '];']);

end
