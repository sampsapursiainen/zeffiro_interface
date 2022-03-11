zef.ini_cell = readcell([zef.program_path '/profile/zeffiro_interface.ini'],'FileType','text');
for zef_i =  1 : size(zef.ini_cell,1)
if isequal(zef.ini_cell{zef_i,4},'number')
evalin('base',['zef.' zef.ini_cell{zef_i,3} ' = ' num2str(zef.ini_cell{zef_i,2}) ';']);
    elseif isequal(zef.ini_cell{zef_i,4},'string')
        evalin('base',['zef.' zef.ini_cell{zef_i,3} ' = ''' (zef.ini_cell{zef_i,2}) ''';']);
end
end
zef = rmfield(zef,'ini_cell');
if isfield(zef,'ini_cell_mod')
for zef_i =  1 : size(zef.ini_cell_mod,1)
if isequal(zef.ini_cell_mod{zef_i,4},'number')
evalin('base',['zef.' zef.ini_cell_mod{zef_i,3} ' = ' num2str(zef.ini_cell_mod{zef_i,2}) ';']);
    elseif isequal(zef.ini_cell_mod{zef_i,4},'string')
        evalin('base',['zef.' zef.ini_cell_mod{zef_i,3} ' = ''' (zef.ini_cell_mod{zef_i,2}) ''';']);
end
end
zef = rmfield(zef,'ini_cell_mod');
end
