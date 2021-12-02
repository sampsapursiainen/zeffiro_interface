%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
function zef_import_figure

[file_name folder_name] = uigetfile({'*.fig'},'Open figure file',evalin('base','zef.save_file_path'));

if not(isequal(file_name,0));   
    
open([folder_name '/' file_name]);

end
    
end











