%Copyright © 2018, Sampsa Pursiainen
if zef.save_switch == 1
if not(isempty(zef.save_file_path)) & not(zef.save_file_path==0)
[zef.file zef.file_path] = uiputfile('*.mat','Save as...',[zef.save_file_path zef.save_file]);
else
[zef.file zef.file_path] = uiputfile('*.mat','Save as...');
end
if not(isequal(zef.file,0));
zef.save_file = zef.file;
zef.save_file_path = zef.file_path;
zef_close_tools;
zef_close_figs;
zef_data = zef;
zef_data.fieldnames = fieldnames(zef);
zef_data = rmfield(zef_data,zef_data.fieldnames(find(startsWith(zef_data.fieldnames, 'h_'))));
zef_data = rmfield(zef_data,{'fieldnames','h'});
save([zef.save_file_path zef.save_file],'zef_data','-v7.3');
clear zef_data;
end
end
if zef.save_switch == 2
if not(isempty(zef.save_file_path)) & not(zef.save_file_path==0)  
[zef.file zef.file_path zef.file_index] = uiputfile({'*.mat';'*.dat'},'Export lead field',zef.save_file_path);
else
[zef.file zef.file_path zef.file_index] = uiputfile({'*.mat';'*.dat'},'Export lead field');
end
if not(isequal(zef.file,0));
if zef.file_index == 1
save([zef.file_path zef.file],'-struct','zef','L','-v7.3');
else 
save([zef.file_path zef.file],'-struct','zef','L','-ascii');
end
end
end
if zef.save_switch == 3
if not(isempty(zef.save_file_path)) & not(zef.save_file_path==0)  
[zef.file zef.file_path zef.file_index] = uiputfile({'*.mat';'*.dat'},'Export source positions',zef.save_file_path);
else
[zef.file zef.file_path zef.file_index] = uiputfile({'*.mat';'*.dat'},'Export source positions');
end
if not(isequal(zef.file,0));
if zef.file_index == 1
save([zef.file_path zef.file],'-struct','zef','source_positions','-v7.3');
else 
save([zef.file_path zef.file],'-struct','zef','source_positions','-ascii');
end
end
end
if zef.save_switch == 4
if not(isempty(zef.save_file_path)) & not(zef.save_file_path==0)      
[zef.file zef.file_path zef.file_index] = uiputfile({'*.mat';'*.dat'},'Export source directions',zef.save_file_path);
else
[zef.file zef.file_path zef.file_index] = uiputfile({'*.mat';'*.dat'},'Export source directions');
end
if not(isequal(zef.file,0));
if zef.file_index == 1
save([zef.file_path zef.file],'-struct','zef','source_directions','-v7.3');
else 
save([zef.file_path zef.file],'-struct','zef','source_directions','-ascii');
end
end
end
if zef.save_switch == 5
if not(isempty(zef.save_file_path)) & not(zef.save_file_path==0)  
[zef.file zef.file_path zef.file_index] = uiputfile({'*.mat'},'Export segmentation data',zef.save_file_path);
else
[zef.file zef.file_path zef.file_index] = uiputfile({'*.mat'},'Export segmentation data');
end
if not(isequal(zef.file,0));
[zef.sensors,zef.reuna_p,zef.reuna_t] = process_meshes([]);
zef.surface_mesh_nodes = zef.reuna_p;
zef.surface_mesh_triangles = zef.reuna_t;
if zef.imaging_method== 1
zef.sensors_attached_surface = zef.sensors;
for zef_i = 1 : size(zef.sensors,1)
[zef.min_val, zef.min_ind] = min(sqrt(sum((zef.surface_mesh_nodes{end} - repmat(zef.sensors(zef_i,1:3),size(zef.surface_mesh_nodes{end},1),1)).^2,2)));
zef.sensors_attached_surface(zef_i,1:3) = zef.surface_mesh_nodes{end}(zef.min_ind,:);
end
clear zef_i;
save([zef.file_path zef.file],'-struct','zef','sensors','surface_mesh_nodes','surface_mesh_triangles','sensors_attached_surface','-v7.3');
zef = rmfield(zef,{'min_val','min_ind','sensors_attached_surface'});
else
save([zef.file_path zef.file],'-struct','zef','sensors','surface_mesh_nodes','surface_mesh_triangles'); 
zef = rmfield(zef,{'surface_mesh_nodes','surface_mesh_triangles'});
end
end
end
if zef.save_switch == 6
if not(isempty(zef.save_file_path)) & not(zef.save_file_path==0)  
    [zef.file zef.file_path zef.file_index] = uiputfile({'*.mat'},'Export volume data',zef.save_file_path);
else
[zef.file zef.file_path zef.file_index] = uiputfile({'*.mat'},'Export volume data');
end
if not(isequal(zef.file,0));
[zef.sensors,zef.reuna_p,zef.reuna_t] = process_meshes([]);
zef.tetrahedra = zef.tetra;
%[zef.sigma,zef.brain_ind] = zef_sigma([]);
if zef.imaging_method== 1
[zef.sensors_attached_volume] = attach_sensors_volume([]);
save([zef.file_path zef.file],'-struct','zef','sensors','nodes','tetrahedra','prisms','surface_triangles','sigma','sigma_prisms','sensors_attached_volume','brain_ind','-v7.3');
zef = rmfield(zef,{'sensors_attached_volume','tetrahedra'});
else
save([zef.file_path zef.file],'-struct','zef','sensors','nodes','tetrahedra','surface_triangles','sigma','-v7.3');
zef = rmfield(zef,'tetrahedra');
end
end
end
if zef.save_switch == 7
if not(isempty(zef.save_file)) & not(isempty(zef.save_file_path)) & not(zef.save_file_path==0) & not(isequal(zef.save_file,'default_project.mat'))
zef_close_tools;
zef_close_figs;
zef_data = zef;
zef_data.fieldnames = fieldnames(zef);
zef_data = rmfield(zef_data,zef_data.fieldnames(find(startsWith(zef_data.fieldnames, 'h_'))));
zef_data = rmfield(zef_data,{'fieldnames','h'});
save([zef.save_file_path zef.save_file],'zef_data','-v7.3');
clear zef_data;
else
if not(isempty(zef.save_file_path)) & not(zef.save_file_path==0)  
[zef.file zef.file_path] = uiputfile('*.mat','Save as...',[zef.save_file_path zef.save_file]);
else
[zef.file zef.file_path] = uiputfile('*.mat','Save as...');   
end
if not(isequal(zef.file,0));
zef.save_file = zef.file;
zef.save_file_path = zef.file_path;
zef_close_tools;
zef_close_figs;
zef_data = zef;
zef_data.fieldnames = fieldnames(zef);
zef_data = rmfield(zef_data,zef_data.fieldnames(find(startsWith(zef_data.fieldnames, 'h_'))));
zef_data = rmfield(zef_data,{'fieldnames','h'});
save([zef.save_file_path zef.save_file],'zef_data','-v7.3');
clear zef_data;
end
end
end
if zef.save_switch == 8
if not(isempty(zef.save_file_path)) & not(zef.save_file_path==0)  
[zef.file zef.file_path zef.file_index] = uiputfile({'*.mat';'*.dat'},'Export reconstruction',zef.save_file_path);
else
[zef.file zef.file_path zef.file_index] = uiputfile({'*.mat';'*.dat'},'Export reconstruction');
end
if not(isequal(zef.file,0));
if zef.file_index == 1
save([zef.file_path zef.file],'-struct','zef','reconstruction','-v7.3');
else 
save([zef.file_path zef.file],'-struct','zef','reconstruction','-ascii');
end
end
end
if zef.save_switch == 9
[zef.file zef.file_path zef.file_index] = uiputfile({'*.fig'},'Save figures as...',zef.save_file_path); 
if not(isequal(zef.file,0)); 
zef.h_fig_aux = findall(groot, 'Type','figure','Name','ZEFFIRO Interface: Figure tool');
savefig(zef.h_fig_aux,[zef.save_file_path zef.file]); 
rmfield(zef,'h_fig_aux');
end;
end;
