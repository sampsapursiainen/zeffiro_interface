%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
if zef.w_on
zef.enable_str = 'on';
else
zef.enable_str = 'off';
end;

set(zef.h_edit9001, 'enable', zef.enable_str);
set(zef.h_edit29, 'enable', zef.enable_str);
set(zef.h_edit70, 'enable', zef.enable_str);
set(zef.h_w_sources,'enable', zef.enable_str);
set(zef.h_w_visible,'enable', zef.enable_str);
set(zef.h_w_merge,'enable', zef.enable_str);
set(zef.h_w_invert,'enable', zef.enable_str);
set(zef.h_pushbutton1,'enable', zef.enable_str);
if not(isequal(zef.mlapp,1))
set(zef.h_pushbutton2,'enable', zef.enable_str);
end

if zef.g_on
zef.enable_str = 'on';
else
zef.enable_str = 'off';
end;

set(zef.h_edit9002, 'enable', zef.enable_str);
set(zef.h_edit36, 'enable', zef.enable_str);
set(zef.h_edit71, 'enable', zef.enable_str);
set(zef.h_g_sources,'enable', zef.enable_str);
set(zef.h_g_visible,'enable', zef.enable_str);
set(zef.h_g_merge,'enable', zef.enable_str);
set(zef.h_g_invert,'enable', zef.enable_str);
set(zef.h_pushbutton3,'enable', zef.enable_str);
if not(isequal(zef.mlapp,1))
set(zef.h_pushbutton4,'enable', zef.enable_str);
end

if zef.c_on
zef.enable_str = 'on';
else
zef.enable_str = 'off';
end;

set(zef.h_edit9003, 'enable', zef.enable_str);
set(zef.h_edit50, 'enable', zef.enable_str);
set(zef.h_edit72, 'enable', zef.enable_str);
set(zef.h_c_sources,'enable', zef.enable_str);
set(zef.h_c_visible,'enable', zef.enable_str);
set(zef.h_c_merge,'enable', zef.enable_str);
set(zef.h_c_invert,'enable', zef.enable_str);
set(zef.h_pushbutton5,'enable', zef.enable_str);
if not(isequal(zef.mlapp,1))
set(zef.h_pushbutton6,'enable', zef.enable_str);
end

if zef.sk_on
zef.enable_str = 'on';
else
zef.enable_str = 'off';
end;

set(zef.h_edit9004, 'enable', zef.enable_str);
set(zef.h_edit57, 'enable', zef.enable_str);
set(zef.h_edit73, 'enable', zef.enable_str);
set(zef.h_sk_sources,'enable', zef.enable_str);
set(zef.h_sk_visible,'enable', zef.enable_str);
set(zef.h_sk_merge,'enable', zef.enable_str);
set(zef.h_sk_invert,'enable', zef.enable_str);
set(zef.h_pushbutton7,'enable', zef.enable_str);
if not(isequal(zef.mlapp,1))
set(zef.h_pushbutton8,'enable', zef.enable_str);
end

if zef.sc_on
zef.enable_str = 'on';
else
zef.enable_str = 'off';
end;

set(zef.h_edit9005, 'enable', zef.enable_str);
set(zef.h_edit64, 'enable', zef.enable_str);
set(zef.h_edit74, 'enable', zef.enable_str);

set(zef.h_sc_sources,'enable', zef.enable_str);
set(zef.h_sc_visible,'enable', zef.enable_str);
set(zef.h_sc_merge,'enable', zef.enable_str);
set(zef.h_sc_invert,'enable', zef.enable_str);
set(zef.h_pushbutton9,'enable', zef.enable_str);
if not(isequal(zef.mlapp,1))
set(zef.h_pushbutton10,'enable', zef.enable_str);
end

if zef.d1_on
zef.enable_str = 'on';
else
zef.enable_str = 'off';
end;

set(zef.h_edit9006, 'enable', zef.enable_str);
set(zef.h_edit129, 'enable', zef.enable_str);
set(zef.h_edit170, 'enable', zef.enable_str);
set(zef.h_d1_name, 'enable', zef.enable_str);
set(zef.h_d1_name,'backgroundcolor',[0.92 0.92 0.92]);
set(zef.h_d1_name,'backgroundcolor',[0.93 0.93 0.93]);

set(zef.h_d1_sources,'enable', zef.enable_str);
set(zef.h_d1_visible,'enable', zef.enable_str);
set(zef.h_d1_merge,'enable', zef.enable_str);
set(zef.h_d1_invert,'enable', zef.enable_str);
set(zef.h_pushbutton101,'enable', zef.enable_str);
if not(isequal(zef.mlapp,1))
set(zef.h_pushbutton102,'enable', zef.enable_str);
end

if zef.d2_on
zef.enable_str = 'on';
else
zef.enable_str = 'off';
end;

set(zef.h_edit9007, 'enable', zef.enable_str);
set(zef.h_edit229, 'enable', zef.enable_str);
set(zef.h_edit270, 'enable', zef.enable_str);
set(zef.h_d2_name, 'enable', zef.enable_str);
set(zef.h_d2_name,'backgroundcolor',[0.92 0.92 0.92]);
set(zef.h_d2_name,'backgroundcolor',[0.93 0.93 0.93]);

set(zef.h_d2_sources,'enable', zef.enable_str);
set(zef.h_d2_visible,'enable', zef.enable_str);
set(zef.h_d2_merge,'enable', zef.enable_str);
set(zef.h_d2_invert,'enable', zef.enable_str);
set(zef.h_pushbutton201,'enable', zef.enable_str);
if not(isequal(zef.mlapp,1))
set(zef.h_pushbutton202,'enable', zef.enable_str);
end

if zef.d3_on
zef.enable_str = 'on';
else
zef.enable_str = 'off';
end;

set(zef.h_edit9008, 'enable', zef.enable_str);
set(zef.h_edit329, 'enable', zef.enable_str);
set(zef.h_edit370, 'enable', zef.enable_str);
set(zef.h_d3_name, 'enable', zef.enable_str);
set(zef.h_d3_name,'backgroundcolor',[0.92 0.92 0.92]);
set(zef.h_d3_name,'backgroundcolor',[0.93 0.93 0.93]);

set(zef.h_d3_sources,'enable', zef.enable_str);
set(zef.h_d3_visible,'enable', zef.enable_str);
set(zef.h_d3_merge,'enable', zef.enable_str);
set(zef.h_d3_invert,'enable', zef.enable_str);
set(zef.h_pushbutton301,'enable', zef.enable_str);
if not(isequal(zef.mlapp,1))
set(zef.h_pushbutton302,'enable', zef.enable_str);
end

if zef.d4_on
zef.enable_str = 'on';
else
zef.enable_str = 'off';
end;

set(zef.h_edit9009, 'enable', zef.enable_str);
set(zef.h_edit429, 'enable', zef.enable_str);
set(zef.h_edit470, 'enable', zef.enable_str);
set(zef.h_d4_name, 'enable', zef.enable_str);
set(zef.h_d4_name,'backgroundcolor',[0.92 0.92 0.92]);
set(zef.h_d4_name,'backgroundcolor',[0.93 0.93 0.93]);

set(zef.h_d4_sources,'enable', zef.enable_str);
set(zef.h_d4_visible,'enable', zef.enable_str);
set(zef.h_d4_merge,'enable', zef.enable_str);
set(zef.h_d4_invert,'enable', zef.enable_str);
set(zef.h_pushbutton401,'enable', zef.enable_str);
if not(isequal(zef.mlapp,1))
set(zef.h_pushbutton402,'enable', zef.enable_str);
end

if zef.d5_on
zef.enable_str = 'on';
else
zef.enable_str = 'off';
end;

set(zef.h_d5_scaling, 'enable', zef.enable_str);
set(zef.h_d5_sigma, 'enable', zef.enable_str);
set(zef.h_d5_priority, 'enable', zef.enable_str);
set(zef.h_d5_name, 'enable', zef.enable_str);
set(zef.h_d5_name,'backgroundcolor',[0.92 0.92 0.92]);
set(zef.h_d5_name,'backgroundcolor',[0.93 0.93 0.93]);

set(zef.h_d5_sources,'enable', zef.enable_str);
set(zef.h_d5_visible,'enable', zef.enable_str);
set(zef.h_d5_merge,'enable', zef.enable_str);
set(zef.h_d5_invert,'enable', zef.enable_str);
set(zef.h_d5_button_1,'enable', zef.enable_str);
if not(isequal(zef.mlapp,1))
set(zef.h_d5_button_2,'enable', zef.enable_str);
end

if zef.d6_on
zef.enable_str = 'on';
else
zef.enable_str = 'off';
end;

set(zef.h_d6_scaling, 'enable', zef.enable_str);
set(zef.h_d6_sigma, 'enable', zef.enable_str);
set(zef.h_d6_priority, 'enable', zef.enable_str);
set(zef.h_d6_name, 'enable', zef.enable_str);
set(zef.h_d6_name,'backgroundcolor',[0.92 0.92 0.92]);
set(zef.h_d6_name,'backgroundcolor',[0.93 0.93 0.93]);

set(zef.h_d6_sources,'enable', zef.enable_str);
set(zef.h_d6_visible,'enable', zef.enable_str);
set(zef.h_d6_merge,'enable', zef.enable_str);
set(zef.h_d6_invert,'enable', zef.enable_str);
set(zef.h_d6_button_1,'enable', zef.enable_str);
if not(isequal(zef.mlapp,1))
set(zef.h_d6_button_2,'enable', zef.enable_str);
end

if zef.d7_on
zef.enable_str = 'on';
else
zef.enable_str = 'off';
end;

set(zef.h_d7_scaling, 'enable', zef.enable_str);
set(zef.h_d7_sigma, 'enable', zef.enable_str);
set(zef.h_d7_priority, 'enable', zef.enable_str);
set(zef.h_d7_name, 'enable', zef.enable_str);
set(zef.h_d7_name,'backgroundcolor',[0.92 0.92 0.92]);
set(zef.h_d7_name,'backgroundcolor',[0.93 0.93 0.93]);

set(zef.h_d7_sources,'enable', zef.enable_str);
set(zef.h_d7_visible,'enable', zef.enable_str);
set(zef.h_d7_merge,'enable', zef.enable_str);
set(zef.h_d7_invert,'enable', zef.enable_str);
set(zef.h_d7_button_1,'enable', zef.enable_str);
if not(isequal(zef.mlapp,1))
set(zef.h_d7_button_2,'enable', zef.enable_str);
end

if zef.d8_on
zef.enable_str = 'on';
else
zef.enable_str = 'off';
end;

set(zef.h_d8_scaling, 'enable', zef.enable_str);
set(zef.h_d8_sigma, 'enable', zef.enable_str);
set(zef.h_d8_priority, 'enable', zef.enable_str);
set(zef.h_d8_name, 'enable', zef.enable_str);
set(zef.h_d8_name,'backgroundcolor',[0.92 0.92 0.92]);
set(zef.h_d8_name,'backgroundcolor',[0.93 0.93 0.93]);

set(zef.h_d8_sources,'enable', zef.enable_str);
set(zef.h_d8_visible,'enable', zef.enable_str);
set(zef.h_d8_merge,'enable', zef.enable_str);
set(zef.h_d8_invert,'enable', zef.enable_str);
set(zef.h_d8_button_1,'enable', zef.enable_str);
if not(isequal(zef.mlapp,1))
set(zef.h_d8_button_2,'enable', zef.enable_str);
end

if zef.d9_on
zef.enable_str = 'on';
else
zef.enable_str = 'off';
end;

set(zef.h_d9_scaling, 'enable', zef.enable_str);
set(zef.h_d9_sigma, 'enable', zef.enable_str);
set(zef.h_d9_priority, 'enable', zef.enable_str);
set(zef.h_d9_name, 'enable', zef.enable_str);
set(zef.h_d9_name,'backgroundcolor',[0.92 0.92 0.92]);
set(zef.h_d9_name,'backgroundcolor',[0.93 0.93 0.93]);

set(zef.h_d9_sources,'enable', zef.enable_str);
set(zef.h_d9_visible,'enable', zef.enable_str);
set(zef.h_d9_merge,'enable', zef.enable_str);
set(zef.h_d9_invert,'enable', zef.enable_str);
set(zef.h_d9_button_1,'enable', zef.enable_str);
if not(isequal(zef.mlapp,1))
set(zef.h_d9_button_2,'enable', zef.enable_str);
end

if zef.d10_on
zef.enable_str = 'on';
else
zef.enable_str = 'off';
end;

set(zef.h_d10_scaling, 'enable', zef.enable_str);
set(zef.h_d10_sigma, 'enable', zef.enable_str);
set(zef.h_d10_priority, 'enable', zef.enable_str);
set(zef.h_d10_name, 'enable', zef.enable_str);
set(zef.h_d10_name,'backgroundcolor',[0.92 0.92 0.92]);
set(zef.h_d10_name,'backgroundcolor',[0.93 0.93 0.93]);

set(zef.h_d10_sources,'enable', zef.enable_str);
set(zef.h_d10_visible,'enable', zef.enable_str);
set(zef.h_d10_merge,'enable', zef.enable_str);
set(zef.h_d10_invert,'enable', zef.enable_str);
set(zef.h_d10_button_1,'enable', zef.enable_str);
if not(isequal(zef.mlapp,1))
set(zef.h_d10_button_2,'enable', zef.enable_str);
end

if zef.d11_on
zef.enable_str = 'on';
else
zef.enable_str = 'off';
end;

set(zef.h_d11_scaling, 'enable', zef.enable_str);
set(zef.h_d11_sigma, 'enable', zef.enable_str);
set(zef.h_d11_priority, 'enable', zef.enable_str);
set(zef.h_d11_name, 'enable', zef.enable_str);
set(zef.h_d11_name,'backgroundcolor',[0.92 0.92 0.92]);
set(zef.h_d11_name,'backgroundcolor',[0.93 0.93 0.93]);

set(zef.h_d11_sources,'enable', zef.enable_str);
set(zef.h_d11_visible,'enable', zef.enable_str);
set(zef.h_d11_merge,'enable', zef.enable_str);
set(zef.h_d11_invert,'enable', zef.enable_str);
set(zef.h_d11_button_1,'enable', zef.enable_str);
if not(isequal(zef.mlapp,1))
set(zef.h_d11_button_2,'enable', zef.enable_str);
 end

if zef.d12_on
zef.enable_str = 'on';
else
zef.enable_str = 'off';
end;

set(zef.h_d12_scaling, 'enable', zef.enable_str);
set(zef.h_d12_sigma, 'enable', zef.enable_str);
set(zef.h_d12_priority, 'enable', zef.enable_str);
set(zef.h_d12_name, 'enable', zef.enable_str);
set(zef.h_d12_name,'backgroundcolor',[0.92 0.92 0.92]);
set(zef.h_d12_name,'backgroundcolor',[0.93 0.93 0.93]);

set(zef.h_d12_sources,'enable', zef.enable_str);
set(zef.h_d12_visible,'enable', zef.enable_str);
set(zef.h_d12_merge,'enable', zef.enable_str);
set(zef.h_d12_invert,'enable', zef.enable_str);
set(zef.h_d12_button_1,'enable', zef.enable_str);
if not(isequal(zef.mlapp,1))
set(zef.h_d12_button_2,'enable', zef.enable_str);
end

if zef.d13_on
zef.enable_str = 'on';
else
zef.enable_str = 'off';
end;

set(zef.h_d13_scaling, 'enable', zef.enable_str);
set(zef.h_d13_sigma, 'enable', zef.enable_str);
set(zef.h_d13_priority, 'enable', zef.enable_str);
set(zef.h_d13_name, 'enable', zef.enable_str);
set(zef.h_d13_name,'backgroundcolor',[0.92 0.92 0.92]);
set(zef.h_d13_name,'backgroundcolor',[0.93 0.93 0.93]);

set(zef.h_d13_sources,'enable', zef.enable_str);
set(zef.h_d13_visible,'enable', zef.enable_str);
set(zef.h_d13_merge,'enable', zef.enable_str);
set(zef.h_d13_invert,'enable', zef.enable_str);
set(zef.h_d13_button_1,'enable', zef.enable_str);
if not(isequal(zef.mlapp,1))
set(zef.h_d13_button_2,'enable', zef.enable_str);
end

if zef.d14_on
zef.enable_str = 'on';
else
zef.enable_str = 'off';
end;

set(zef.h_d14_scaling, 'enable', zef.enable_str);
set(zef.h_d14_sigma, 'enable', zef.enable_str);
set(zef.h_d14_priority, 'enable', zef.enable_str);
set(zef.h_d14_name, 'enable', zef.enable_str);
set(zef.h_d14_name,'backgroundcolor',[0.92 0.92 0.92]);
set(zef.h_d14_name,'backgroundcolor',[0.93 0.93 0.93]);

set(zef.h_d14_sources,'enable', zef.enable_str);
set(zef.h_d14_visible,'enable', zef.enable_str);
set(zef.h_d14_merge,'enable', zef.enable_str);
set(zef.h_d14_invert,'enable', zef.enable_str);
set(zef.h_d14_button_1,'enable', zef.enable_str);
if not(isequal(zef.mlapp,1))
set(zef.h_d14_button_2,'enable', zef.enable_str);
end

if zef.d15_on
zef.enable_str = 'on';
else
zef.enable_str = 'off';
end;

set(zef.h_d15_scaling, 'enable', zef.enable_str);
set(zef.h_d15_sigma, 'enable', zef.enable_str);
set(zef.h_d15_priority, 'enable', zef.enable_str);
set(zef.h_d15_name, 'enable', zef.enable_str);
set(zef.h_d15_name,'backgroundcolor',[0.92 0.92 0.92]);
set(zef.h_d15_name,'backgroundcolor',[0.93 0.93 0.93]);

set(zef.h_d15_sources,'enable', zef.enable_str);
set(zef.h_d15_visible,'enable', zef.enable_str);
set(zef.h_d15_merge,'enable', zef.enable_str);
set(zef.h_d15_invert,'enable', zef.enable_str);
set(zef.h_d15_button_1,'enable', zef.enable_str);
if not(isequal(zef.mlapp,1))
set(zef.h_d15_button_2,'enable', zef.enable_str);
end

if zef.d16_on
zef.enable_str = 'on';
else
zef.enable_str = 'off';
end;

set(zef.h_d16_scaling, 'enable', zef.enable_str);
set(zef.h_d16_sigma, 'enable', zef.enable_str);
set(zef.h_d16_priority, 'enable', zef.enable_str);
set(zef.h_d16_name, 'enable', zef.enable_str);
set(zef.h_d16_name,'backgroundcolor',[0.92 0.92 0.92]);
set(zef.h_d16_name,'backgroundcolor',[0.93 0.93 0.93]);

set(zef.h_d16_sources,'enable', zef.enable_str);
set(zef.h_d16_visible,'enable', zef.enable_str);
set(zef.h_d16_merge,'enable', zef.enable_str);
set(zef.h_d16_invert,'enable', zef.enable_str);
set(zef.h_d16_button_1,'enable', zef.enable_str);
if not(isequal(zef.mlapp,1))
set(zef.h_d16_button_2,'enable', zef.enable_str);
end

if zef.d17_on
zef.enable_str = 'on';
else
zef.enable_str = 'off';
end;

set(zef.h_d17_scaling, 'enable', zef.enable_str);
set(zef.h_d17_sigma, 'enable', zef.enable_str);
set(zef.h_d17_priority, 'enable', zef.enable_str);
set(zef.h_d17_name, 'enable', zef.enable_str);
set(zef.h_d17_name,'backgroundcolor',[0.92 0.92 0.92]);
set(zef.h_d17_name,'backgroundcolor',[0.93 0.93 0.93]);

set(zef.h_d17_sources,'enable', zef.enable_str);
set(zef.h_d17_visible,'enable', zef.enable_str);
set(zef.h_d17_merge,'enable', zef.enable_str);
set(zef.h_d17_invert,'enable', zef.enable_str);
set(zef.h_d17_button_1,'enable', zef.enable_str);
if not(isequal(zef.mlapp,1))
set(zef.h_d17_button_2,'enable', zef.enable_str);
end

if zef.d18_on
zef.enable_str = 'on';
else
zef.enable_str = 'off';
end;

set(zef.h_d18_scaling, 'enable', zef.enable_str);
set(zef.h_d18_sigma, 'enable', zef.enable_str);
set(zef.h_d18_priority, 'enable', zef.enable_str);
set(zef.h_d18_name, 'enable', zef.enable_str);
set(zef.h_d18_name,'backgroundcolor',[0.92 0.92 0.92]);
set(zef.h_d18_name,'backgroundcolor',[0.93 0.93 0.93]);

set(zef.h_d18_sources,'enable', zef.enable_str);
set(zef.h_d18_visible,'enable', zef.enable_str);
set(zef.h_d18_merge,'enable', zef.enable_str);
set(zef.h_d18_invert,'enable', zef.enable_str);
set(zef.h_d18_button_1,'enable', zef.enable_str);
if not(isequal(zef.mlapp,1))
set(zef.h_d18_button_2,'enable', zef.enable_str);
end

if zef.d19_on
zef.enable_str = 'on';
else
zef.enable_str = 'off';
end;

set(zef.h_d19_scaling, 'enable', zef.enable_str);
set(zef.h_d19_sigma, 'enable', zef.enable_str);
set(zef.h_d19_priority, 'enable', zef.enable_str);
set(zef.h_d19_name, 'enable', zef.enable_str);
set(zef.h_d19_name,'backgroundcolor',[0.92 0.92 0.92]);
set(zef.h_d19_name,'backgroundcolor',[0.93 0.93 0.93]);

set(zef.h_d19_sources,'enable', zef.enable_str);
set(zef.h_d19_visible,'enable', zef.enable_str);
set(zef.h_d19_merge,'enable', zef.enable_str);
set(zef.h_d19_invert,'enable', zef.enable_str);
set(zef.h_d19_button_1,'enable', zef.enable_str);
if not(isequal(zef.mlapp,1))
set(zef.h_d19_button_2,'enable', zef.enable_str);
end

if zef.d20_on
zef.enable_str = 'on';
else
zef.enable_str = 'off';
end;

set(zef.h_d20_scaling, 'enable', zef.enable_str);
set(zef.h_d20_sigma, 'enable', zef.enable_str);
set(zef.h_d20_priority, 'enable', zef.enable_str);
set(zef.h_d20_name, 'enable', zef.enable_str);
set(zef.h_d20_name,'backgroundcolor',[0.92 0.92 0.92]);
set(zef.h_d20_name,'backgroundcolor',[0.93 0.93 0.93]);

set(zef.h_d20_sources,'enable', zef.enable_str);
set(zef.h_d20_visible,'enable', zef.enable_str);
set(zef.h_d20_merge,'enable', zef.enable_str);
set(zef.h_d20_invert,'enable', zef.enable_str);
set(zef.h_d20_button_1,'enable', zef.enable_str);
if not(isequal(zef.mlapp,1))
set(zef.h_d20_button_2,'enable', zef.enable_str);
end

if zef.d21_on
zef.enable_str = 'on';
else
zef.enable_str = 'off';
end;

set(zef.h_d21_scaling, 'enable', zef.enable_str);
set(zef.h_d21_sigma, 'enable', zef.enable_str);
set(zef.h_d21_priority, 'enable', zef.enable_str);
set(zef.h_d21_name, 'enable', zef.enable_str);
set(zef.h_d21_name,'backgroundcolor',[0.92 0.92 0.92]);
set(zef.h_d21_name,'backgroundcolor',[0.93 0.93 0.93]);

set(zef.h_d21_sources,'enable', zef.enable_str);
set(zef.h_d21_visible,'enable', zef.enable_str);
set(zef.h_d21_merge,'enable', zef.enable_str);
set(zef.h_d21_invert,'enable', zef.enable_str);
set(zef.h_d21_button_1,'enable', zef.enable_str);
if not(isequal(zef.mlapp,1))
set(zef.h_d21_button_2,'enable', zef.enable_str);
end

if zef.d22_on
zef.enable_str = 'on';
else
zef.enable_str = 'off';
end;

set(zef.h_d22_scaling, 'enable', zef.enable_str);
set(zef.h_d22_sigma, 'enable', zef.enable_str);
set(zef.h_d22_priority, 'enable', zef.enable_str);
set(zef.h_d22_name, 'enable', zef.enable_str);
set(zef.h_d22_name,'backgroundcolor',[0.92 0.92 0.92]);
set(zef.h_d22_name,'backgroundcolor',[0.93 0.93 0.93]);

set(zef.h_d22_sources,'enable', zef.enable_str);
set(zef.h_d22_visible,'enable', zef.enable_str);
set(zef.h_d22_merge,'enable', zef.enable_str);
set(zef.h_d22_invert,'enable', zef.enable_str);
set(zef.h_d22_button_1,'enable', zef.enable_str);
if not(isequal(zef.mlapp,1))
set(zef.h_d22_button_2,'enable', zef.enable_str);
end

