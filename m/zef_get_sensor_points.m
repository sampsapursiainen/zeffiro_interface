[zef.file zef.file_path] = uigetfile('*.dat'); 
if not(isequal(zef.file,0));
zef.aux_field = zef_get_mesh([zef.file_path zef.file],zef.current_sensors,'points');
evalin('base',['zef.' zef.current_sensors '_points = [' num2str(zef.aux_field(:)') '];']);
evalin('base',['zef.' zef.current_sensors '_points = reshape(zef.' zef.current_sensors '_points, length(' 'zef.' zef.current_sensors '_points)/' num2str(size(zef.aux_field,2)) ',' num2str(size(zef.aux_field,2)) ');']);
zef = rmfield(zef,'aux_field');
zef_update;
end; 
