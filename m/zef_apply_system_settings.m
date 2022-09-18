function zef = zef_apply_system_settings(zef)

if nargin == 0
zef = evalin('base','zef');
end


zef.ini_cell = readcell([zef.program_path '/profile/zeffiro_interface.ini'],'FileType','text');
for zef_i =  1 : size(zef.ini_cell,1)
if isequal(zef.ini_cell{zef_i,4},'number')
    if not(isnumeric(zef.ini_cell{zef_i,2}))
      zef.ini_cell{zef_i,2} = str2num(zef.ini_cell{zef_i,2});
    end
elseif isequal(zef.ini_cell{zef_i,4},'string')
    zef.ini_cell{zef_i,2} = num2str(zef.ini_cell{zef_i,2});
end

zef.(zef.ini_cell{zef_i,3})  = zef.ini_cell{zef_i,2};

end

zef = rmfield(zef,'ini_cell');
if isfield(zef,'ini_cell_mod')
for zef_i =  1 : size(zef.ini_cell_mod,1)
if isequal(zef.ini_cell_mod{zef_i,4},'number')
if not(isnumeric(zef.ini_cell_mod{zef_i,2}))
   zef.ini_cell_mod{zef_i,2} = str2num(zef.ini_cell_mod{zef_i,2});
end
elseif isequal(zef.ini_cell_mod{zef_i,4},'string')
    zef.ini_cell{zef_i,2} = num2str(zef.ini_cell_mod{zef_i,2});
end
    
zef.(zef.ini_cell_mod{zef_i,3})  =  num2str(zef.ini_cell_mod{zef_i,2});

end
zef = rmfield(zef,'ini_cell_mod');
end

if isequal(zef.segmentation_tool_default_position,[0 0 0 0])
   h_groot = groot; 
   screen_size = h_groot.ScreenSize;
   zef.segmentation_tool_default_position = [screen_size(3)/10 screen_size(4)/10 screen_size(3)/3 2*screen_size(4)/3];
end

if nargout == 0
assignin('base','zef',zef);
end

end
