%Copyright © 2018, Sampsa Pursiainen
zef_init_options;
if ismac
zef.h_additional_options = open('additional_options_alt.fig');
elseif ispc 
zef.h_additional_options = open('additional_options_alt2.fig');
else
zef.h_additional_options = open('additional_options.fig');
end

if zef.cp2_on
    set(zef.h_cp2_a,'enable','on');
    set(zef.h_cp2_b,'enable','on');
    set(zef.h_cp2_c,'enable','on');
    set(zef.h_cp2_d,'enable','on');
else
    set(zef.h_cp2_a,'enable','off');
    set(zef.h_cp2_b,'enable','off');
    set(zef.h_cp2_c,'enable','off');
    set(zef.h_cp2_d,'enable','off');
end

if zef.cp3_on
    set(zef.h_cp3_a,'enable','on');
    set(zef.h_cp3_b,'enable','on');
    set(zef.h_cp3_c,'enable','on');
    set(zef.h_cp3_d,'enable','on');
else
    set(zef.h_cp3_a,'enable','off');
    set(zef.h_cp3_b,'enable','off');
    set(zef.h_cp3_c,'enable','off');
    set(zef.h_cp3_d,'enable','off');
end

uistack(flipud([zef.h_as_opt_1;zef.h_as_opt_2;zef.h_as_opt_3;zef.h_as_opt_4;zef.h_meshing_threshold;zef.h_as_opt_5;zef.h_as_opt_6;zef.h_cp2_on;zef.h_cp2_a;zef.h_cp2_b;zef.h_cp2_c;zef.h_cp2_d;zef.h_cp3_on;zef.h_cp3_a;zef.h_cp3_b;zef.h_cp3_c;zef.h_cp3_d;zef.h_cp_mode;zef.h_layer_transparency;zef.h_inv_dynamic_range;zef.h_inv_scale;zef.h_inv_colormap;zef.h_frame_start;zef.h_frame_stop;zef.h_frame_step;zef.h_orbit_1;zef.h_orbit_2;zef.h_add_cancel;zef.h_add_apply;zef.h_add_ok]),'bottom');