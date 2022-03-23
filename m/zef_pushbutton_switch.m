%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
switch_color('s_on','pushbutton16','s_points');
if zef.imaging_method==2
switch_color('s_on','pushbutton17','s_directions');
end

switch_color('w_on','pushbutton1','w_points');

color_label('w');

switch_color('g_on','pushbutton3','g_points');

color_label('g');

switch_color('c_on','pushbutton5','c_points');

color_label('c');

switch_color('sk_on','pushbutton7','sk_points');

color_label('sk');

switch_color('sc_on','pushbutton9','sc_points');

color_label('sc');

switch_color('d1_on','pushbutton101','d1_points');

color_label('d1');

switch_color('d2_on','pushbutton201','d2_points');
color_label('d2');

switch_color('d3_on','pushbutton301','d3_points');

color_label('d3');

switch_color('d4_on','pushbutton401','d4_points');

color_label('d4');
switch_onoff;

switch_color('d5_on','d5_button_1','d5_points');

color_label('d5');

switch_color('d6_on','d6_button_1','d6_points');
color_label('d6');

switch_onoff;

switch_color('d7_on','d7_button_1','d7_points');
color_label('d7');

switch_color('d8_on','d8_button_1','d8_points');
color_label('d8');

switch_color('d9_on','d9_button_1','d9_points');
color_label('d9');

switch_color('d10_on','d10_button_1','d10_points');
color_label('d10');

switch_color('d11_on','d11_button_1','d11_points');
color_label('d11');

switch_color('d12_on','d12_button_1','d12_points');
color_label('d12');

switch_color('d13_on','d13_button_1','d13_points');
color_label('d13');

switch_color('d14_on','d14_button_1','d14_points');

color_label('d14');

switch_color('d15_on','d15_button_1','d15_points');
color_label('d15');
switch_onoff;

switch_color('d16_on','d16_button_1','d16_points');
color_label('d16');

switch_color('d17_on','d17_button_1','d17_points');

color_label('d17');

switch_color('d18_on','d18_button_1','d18_points');
color_label('d18');

switch_color('d19_on','d19_button_1','d19_points');
color_label('d19');

switch_color('d20_on','d20_button_1','d20_points');
color_label('d20');

switch_color('d21_on','d21_button_1','d21_points');

color_label('d21');

switch_color('d22_on','d22_button_1','d22_points');
color_label('d22');

if not(isequal(zef.mlapp,1))

switch_color('w_on','pushbutton2','w_triangles');
switch_color('g_on','pushbutton4','g_triangles');
switch_color('c_on','pushbutton6','c_triangles');
switch_color('sk_on','pushbutton8','sk_triangles');
switch_color('sc_on','pushbutton10','sc_triangles');
switch_color('d1_on','pushbutton102','d1_triangles');
switch_color('d2_on','pushbutton202','d2_triangles');
switch_color('d3_on','pushbutton302','d3_triangles');
switch_color('d4_on','pushbutton402','d4_triangles');
switch_color('d5_on','d5_button_2','d5_triangles');
switch_color('d6_on','d6_button_2','d6_triangles');
switch_color('d7_on','d7_button_2','d7_triangles');
switch_color('d8_on','d8_button_2','d8_triangles');
switch_color('d9_on','d9_button_2','d9_triangles');
switch_color('d10_on','d10_button_2','d10_triangles');
switch_color('d11_on','d11_button_2','d11_triangles');
switch_color('d12_on','d12_button_2','d12_triangles');
switch_color('d13_on','d13_button_2','d13_triangles');
switch_color('d14_on','d14_button_2','d14_triangles');
switch_color('d15_on','d15_button_2','d15_triangles');
switch_color('d16_on','d16_button_2','d16_triangles');
switch_color('d17_on','d17_button_2','d17_triangles');
switch_color('d18_on','d18_button_2','d18_triangles');
switch_color('d19_on','d19_button_2','d19_triangles');
switch_color('d20_on','d20_button_2','d20_triangles');
switch_color('d21_on','d21_button_2','d21_triangles');
switch_color('d22_on','d22_button_2','d22_triangles');

end

switch_onoff;
