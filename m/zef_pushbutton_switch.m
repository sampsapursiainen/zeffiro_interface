%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
zef_switch_color('s_on','pushbutton16','s_points');
if zef.imaging_method==2
    zef_switch_color('s_on','pushbutton17','s_directions');
end

zef_switch_color('w_on','pushbutton1','w_points');

zef_color_label('w');

zef_switch_color('g_on','pushbutton3','g_points');

zef_color_label('g');

zef_switch_color('c_on','pushbutton5','c_points');

zef_color_label('c');

zef_switch_color('sk_on','pushbutton7','sk_points');

zef_color_label('sk');

zef_switch_color('sc_on','pushbutton9','sc_points');

zef_color_label('sc');

zef_switch_color('d1_on','pushbutton101','d1_points');

zef_color_label('d1');

zef_switch_color('d2_on','pushbutton201','d2_points');
zef_color_label('d2');

zef_switch_color('d3_on','pushbutton301','d3_points');

zef_color_label('d3');

zef_switch_color('d4_on','pushbutton401','d4_points');

zef_color_label('d4');
zef_switch_onoff;

zef_switch_color('d5_on','d5_button_1','d5_points');

zef_color_label('d5');

zef_switch_color('d6_on','d6_button_1','d6_points');
zef_color_label('d6');

zef_switch_onoff;

zef_switch_color('d7_on','d7_button_1','d7_points');
zef_color_label('d7');

zef_switch_color('d8_on','d8_button_1','d8_points');
zef_color_label('d8');

zef_switch_color('d9_on','d9_button_1','d9_points');
zef_color_label('d9');

zef_switch_color('d10_on','d10_button_1','d10_points');
zef_color_label('d10');

zef_switch_color('d11_on','d11_button_1','d11_points');
zef_color_label('d11');

zef_switch_color('d12_on','d12_button_1','d12_points');
zef_color_label('d12');

zef_switch_color('d13_on','d13_button_1','d13_points');
zef_color_label('d13');

zef_switch_color('d14_on','d14_button_1','d14_points');

zef_color_label('d14');

zef_switch_color('d15_on','d15_button_1','d15_points');
zef_color_label('d15');
zef_switch_onoff;

zef_switch_color('d16_on','d16_button_1','d16_points');
zef_color_label('d16');

zef_switch_color('d17_on','d17_button_1','d17_points');

zef_color_label('d17');

zef_switch_color('d18_on','d18_button_1','d18_points');
zef_color_label('d18');

zef_switch_color('d19_on','d19_button_1','d19_points');
zef_color_label('d19');

zef_switch_color('d20_on','d20_button_1','d20_points');
zef_color_label('d20');

zef_switch_color('d21_on','d21_button_1','d21_points');

zef_color_label('d21');

zef_switch_color('d22_on','d22_button_1','d22_points');
zef_color_label('d22');

if not(isequal(zef.mlapp,1))

    zef_switch_color('w_on','pushbutton2','w_triangles');
    zef_switch_color('g_on','pushbutton4','g_triangles');
    zef_switch_color('c_on','pushbutton6','c_triangles');
    zef_switch_color('sk_on','pushbutton8','sk_triangles');
    zef_switch_color('sc_on','pushbutton10','sc_triangles');
    zef_switch_color('d1_on','pushbutton102','d1_triangles');
    zef_switch_color('d2_on','pushbutton202','d2_triangles');
    zef_switch_color('d3_on','pushbutton302','d3_triangles');
    zef_switch_color('d4_on','pushbutton402','d4_triangles');
    zef_switch_color('d5_on','d5_button_2','d5_triangles');
    zef_switch_color('d6_on','d6_button_2','d6_triangles');
    zef_switch_color('d7_on','d7_button_2','d7_triangles');
    zef_switch_color('d8_on','d8_button_2','d8_triangles');
    zef_switch_color('d9_on','d9_button_2','d9_triangles');
    zef_switch_color('d10_on','d10_button_2','d10_triangles');
    zef_switch_color('d11_on','d11_button_2','d11_triangles');
    zef_switch_color('d12_on','d12_button_2','d12_triangles');
    zef_switch_color('d13_on','d13_button_2','d13_triangles');
    zef_switch_color('d14_on','d14_button_2','d14_triangles');
    zef_switch_color('d15_on','d15_button_2','d15_triangles');
    zef_switch_color('d16_on','d16_button_2','d16_triangles');
    zef_switch_color('d17_on','d17_button_2','d17_triangles');
    zef_switch_color('d18_on','d18_button_2','d18_triangles');
    zef_switch_color('d19_on','d19_button_2','d19_triangles');
    zef_switch_color('d20_on','d20_button_2','d20_triangles');
    zef_switch_color('d21_on','d21_button_2','d21_triangles');
    zef_switch_color('d22_on','d22_button_2','d22_triangles');

end

zef_switch_onoff;
