if zef.cp_on
zef.enable_str = 'on';    
else
zef.enable_str = 'off';   
end;

set(zef.h_edit_cp_a, 'enable', zef.enable_str);
set(zef.h_edit_cp_b, 'enable', zef.enable_str);
set(zef.h_edit_cp_c, 'enable', zef.enable_str);
set(zef.h_edit_cp_d, 'enable', zef.enable_str);