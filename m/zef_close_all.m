

zef.h_window_aux = findall(groot,'-regexp','Name','ZEFFIRO Interface');
set(zef.h_window_aux,'DeleteFcn','');
delete(zef.h_window_aux);
if isequal(exist('zef'),1)
if isfield(zef,'path_cell')
warning off;
for zef_i = 1 : length(zef.path_cell)
rmpath(zef.path_cell{zef_i})
end
warning on;
end
end

clear zef zef_data zef_i zef_j zef_k


