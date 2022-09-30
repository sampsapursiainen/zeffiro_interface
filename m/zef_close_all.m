zef.h_window_aux = findall(groot,'-regexp','Name','ZEFFIRO Interface*');
%zef.h_window_aux = findall(groot,'-property','ZefTool','-or','-property','ZefFig');
set(zef.h_window_aux,'DeleteFcn','');
delete(zef.h_window_aux);
zef_delete_waitbar;
if exist('zef','var')
if isfield(zef,'zeffiro_restart')
if isequal(zef.zeffiro_restart,0)
warning('off','MATLAB:rmpath:DirNotFound');
rmpath(genpath(fileparts(which('zeffiro_interface.m'))));
warning('on','MATLAB:rmpath:DirNotFound');
end
else
warning('off','MATLAB:rmpath:DirNotFound');
rmpath(genpath(fileparts(which('zeffiro_interface.m'))));
warning('on','MATLAB:rmpath:DirNotFound');    
end
else
warning('off','MATLAB:rmpath:DirNotFound');
rmpath(genpath(fileparts(which('zeffiro_interface.m'))));
warning('on','MATLAB:rmpath:DirNotFound');    
end

clear zef zef_data zef_i zef_j zef_k


