%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
if zef.save_switch == 1
if zef.use_display
if not(isempty(zef.save_file_path)) & not(zef.save_file_path==0)
[zef.file zef.file_path] = uiputfile('*.mat','Save as...',[zef.save_file_path zef.save_file]);
else
[zef.file zef.file_path] = uiputfile('*.mat','Save as...');
end
 end
if not(isequal(zef.file,0));
zef.save_file = zef.file;
zef.save_file_path = zef.file_path;
zef_close_tools;
zef_close_figs;
zef_data = zef;
zef_remove_object_fields;
save([zef.save_file_path zef.save_file],'zef_data','-v7.3');
clear zef_data;
zef_mesh_tool;
zeffiro_interface_mesh_visualization_tool;
zef_update;
end
end
if zef.save_switch == 2
    if zef.use_display
if not(isempty(zef.save_file_path)) & not(zef.save_file_path==0)
[zef.file zef.file_path zef.file_index] = uiputfile({'*.mat';'*.dat'},'Export lead field',zef.save_file_path);
else
[zef.file zef.file_path zef.file_index] = uiputfile({'*.mat'},'Export lead field');
end
    end
if not(isequal(zef.file,0));
save([zef.file_path zef.file],'-struct','zef','L','-v7.3');
end
end
if zef.save_switch == 3
    if zef.use_display
if not(isempty(zef.save_file_path)) & not(zef.save_file_path==0)
[zef.file zef.file_path zef.file_index] = uiputfile({'*.mat'},'Export source space',zef.save_file_path);
else
[zef.file zef.file_path zef.file_index] = uiputfile({'*.mat'},'Export source space');
end
    end
if not(isequal(zef.file,0));
save([zef.file_path zef.file],'-struct','zef','source_positions','source_directions','-v7.3');
end
end
if zef.save_switch == 4
    if zef.use_display
if not(isempty(zef.save_file_path)) & not(zef.save_file_path==0)
[zef.file zef.file_path zef.file_index] = uiputfile({'*.mat'},'Export sensors',zef.save_file_path);
else
[zef.file zef.file_path zef.file_index] = uiputfile({'*.mat'},'Export sensors');
end
    end
if not(isequal(zef.file,0));
save([zef.file_path zef.file],'-struct','zef',[zef.current_sensors '_points'],[zef.current_sensors '_directions'],'-v7.3');
end
end
if zef.save_switch == 5
    if zef.use_display
if not(isempty(zef.save_file_path)) & not(zef.save_file_path==0)
[zef.file zef.file_path zef.file_index] = uiputfile({'*.mat'},'Export segmentation data',zef.save_file_path);
else
[zef.file zef.file_path zef.file_index] = uiputfile({'*.mat'},'Export segmentation data');
end
    end
if not(isequal(zef.file,0));
zef_process_meshes([]);
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
    if zef.use_display
if not(isempty(zef.save_file_path)) & not(zef.save_file_path==0)
    [zef.file zef.file_path zef.file_index] = uiputfile({'*.mat'},'Export volume data',zef.save_file_path);
else
[zef.file zef.file_path zef.file_index] = uiputfile({'*.mat'},'Export volume data');
end
    end
if not(isequal(zef.file,0));
zef_process_meshes;
zef.tetrahedra = zef.tetra;
%[zef.sigma,zef.brain_ind] = zef_postprocess_fem_mesh([]);
if zef.imaging_method== 1
[zef.sensors_attached_volume] = zef_attach_sensors_volume([]);
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
zef_remove_object_fields;
save([zef.save_file_path zef.save_file],'zef_data','-v7.3');
clear zef_data;
zef_mesh_tool;
zeffiro_interface_mesh_visualization_tool;
zef_update;
else
if zef.use_display
if not(isempty(zef.save_file_path)) & not(zef.save_file_path==0)
[zef.file zef.file_path] = uiputfile('*.mat','Save as...',[zef.save_file_path zef.save_file]);
else
[zef.file zef.file_path] = uiputfile('*.mat','Save as...');
end
end
if not(isequal(zef.file,0));
zef.save_file = zef.file;
zef.save_file_path = zef.file_path;
zef_close_tools;
zef_close_figs;
zef_data = zef;
zef_remove_object_fields;
save([zef.save_file_path zef.save_file],'zef_data','-v7.3');
clear zef_data;
end
end
end
if zef.save_switch == 8
if zef.use_display
if not(isempty(zef.save_file_path)) & not(zef.save_file_path==0)
[zef.file zef.file_path zef.file_index] = uiputfile({'*.mat';'*.dat'},'Export reconstruction',zef.save_file_path);
else
[zef.file zef.file_path zef.file_index] = uiputfile({'*.mat';'*.dat'},'Export reconstruction');
end
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
    if zef.use_display
[zef.file zef.file_path zef.file_index] = uiputfile({'*.fig'},'Save figures as...',zef.save_file_path);
    end
if not(isequal(zef.file,0));
zef.h_fig_aux = findall(groot, 'Type','figure','-regexp','Name','ZEFFIRO Interface: Figure tool*');
savefig(zef.h_fig_aux,[zef.save_file_path zef.file]);
rmfield(zef,'h_fig_aux');
end;
end;
if zef.save_switch == 10
    if zef.use_display
[zef.file zef.file_path zef.file_index] = uiputfile({'*.png';'*.jpg';'*.tiff'},'Print figure to file as...',zef.save_file_path);
    end
if not(isequal(zef.file,0));
    if zef.file_index == 1
print(gcf,'-dpng','-r200',[zef.file_path zef.file]);
    end
        if zef.file_index == 2
print(gcf,['-djpeg' zef.video_codec],'-r200',[zef.save_file_path zef.file]);
    end
if zef.file_index == 3
print(gcf,'-dtiff','-r200',[zef.file_path zef.file]);
    end
end;
end;

