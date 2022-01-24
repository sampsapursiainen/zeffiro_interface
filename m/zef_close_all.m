zef.h_window_aux = findall(groot,'-regexp','Name','ZEFFIRO Interface');
zef.h_window_aux = setdiff(zef.h_window_aux,zef.h_zeffiro_window_main);
set(zef.h_window_aux,'DeleteFcn','');
delete(zef.h_window_aux);
delete(zef.h_zeffiro_window_main);
clear zef zef_data zef_i zef_j zef_k
