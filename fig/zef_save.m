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
zef_close_windows;
zef_data = zef;
zef_data = rmfield(zef_data,{'h_zeffiro','h_zeffiro_window_main','h_interpolate', 'h_source_interpolation_on', 'h_visualization_type', 'h_smoothing_strength', 'h_refinement_on', 'h_wm_sources',  'h_d1_sources',  'h_d2_sources',  'h_d3_sources',  'h_d4_sources', 'h_checkbox_mesh_smoothing_on', 'h_checkbox17', 'h_pushbutton34', 'h_text4196', 'h_edit9009','h_edit470', 'h_checkbox407', 'h_edit429', 'h_edit428', 'h_edit427', 'h_edit426', 'h_edit425', 'h_edit424', 'h_edit423', 'h_checkbox401', 'h_pushbutton402', 'h_pushbutton401', 'h_edit_meshing_accuracy', 'h_text_image', 'h_text_elements', 'h_text_nodes','h_edit_cp_d', 'h_edit_cp_c', 'h_edit_cp_b', 'h_edit_cp_a', 'h_checkbox_cp_on', 'h_edit9008', 'h_edit9007','h_edit9006', 'h_edit9005', 'h_edit9004', 'h_edit9003', 'h_edit9002', 'h_edit9001', 'h_pushbutton31', 'h_text3196','h_edit370', 'h_checkbox307','h_edit329', 'h_edit328', 'h_edit327', 'h_edit326', 'h_edit325', 'h_edit324', 'h_edit323', 'h_checkbox301', 'h_pushbutton302', 'h_pushbutton301', 'h_text2196', 'h_text1196', 'h_edit270', 'h_edit170', 'h_checkbox207', 'h_checkbox107', 'h_edit229', 'h_edit228', 'h_edit227', 'h_edit226', 'h_edit225', 'h_edit224', 'h_edit223', 'h_edit129', 'h_edit128', 'h_edit127', 'h_edit126', 'h_edit125', 'h_edit124', 'h_edit123', 'h_checkbox201', 'h_checkbox101', 'h_pushbutton202', 'h_pushbutton201', 'h_pushbutton102', 'h_pushbutton101', 'h_pushbutton23', 'h_edit82', 'h_pushbutton22', 'h_popupmenu6', 'h_edit81', 'h_edit80', 'h_text200', 'h_text199', 'h_text198', 'h_text197', 'h_text196', 'h_checkbox16', 'h_pushbutton21', 'h_checkbox15', 'h_edit76', 'h_edit75', 'h_edit74','h_edit73','h_edit72','h_edit71', 'h_edit70', 'h_edit65', 'h_pushbutton20','h_checkbox14', 'h_checkbox13', 'h_pushbutton17', 'h_pushbutton16', 'h_pushbutton2', 'h_pushbutton1', 'h_pushbutton14','h_popupmenu2', 'h_checkbox11', 'h_checkbox10','h_checkbox9', 'h_checkbox8', 'h_checkbox7', 'h_edit64','h_edit63','h_edit62','h_edit61','h_edit60','h_edit59','h_edit58','h_edit57','h_edit56','h_edit55','h_edit54','h_edit53','h_edit52','h_edit51','h_edit50','h_edit49','h_edit48','h_edit47','h_edit46','h_edit45','h_edit44', 'h_edit36','h_edit35','h_edit34','h_edit33','h_edit32','h_edit31','h_edit30','h_edit29','h_edit28','h_edit27','h_edit26','h_edit25','h_edit24','h_edit23','h_edit15','h_edit14','h_edit13','h_edit12','h_edit7','h_edit6','h_edit3','h_popupmenu1','h_checkbox5','h_checkbox4','h_checkbox3','h_checkbox2','h_pushbutton10','h_pushbutton9','h_pushbutton8','h_pushbutton7','h_pushbutton6','h_pushbutton5', 'h_pushbutton4','h_pushbutton3','h_checkbox1','aux_handle_vec','h_axes2','h_axes1','h','h_colorbar'});
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
for i = 1 : size(zef.sensors,1)
[zef.min_val, zef.min_ind] = min(sqrt(sum((zef.surface_mesh_nodes{end} - repmat(zef.sensors(i,1:3),size(zef.surface_mesh_nodes{end},1),1)).^2,2)));
zef.sensors_attached_surface(i,1:3) = zef.surface_mesh_nodes{end}(zef.min_ind,:);
end
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
zef_close_windows;
zef_data = zef;
zef_data = rmfield(zef_data,{'h_zeffiro','h_zeffiro_window_main','h_interpolate', 'h_source_interpolation_on', 'h_visualization_type', 'h_smoothing_strength', 'h_refinement_on', 'h_wm_sources', 'h_d1_sources', 'h_d2_sources', 'h_d3_sources', 'h_d4_sources', 'h_checkbox_mesh_smoothing_on', 'h_checkbox17', 'h_pushbutton34', 'h_text4196', 'h_edit9009','h_edit470', 'h_checkbox407', 'h_edit429', 'h_edit428', 'h_edit427', 'h_edit426', 'h_edit425', 'h_edit424', 'h_edit423', 'h_checkbox401', 'h_pushbutton402', 'h_pushbutton401', 'h_edit_meshing_accuracy', 'h_text_image', 'h_text_elements', 'h_text_nodes','h_edit_cp_d', 'h_edit_cp_c', 'h_edit_cp_b', 'h_edit_cp_a', 'h_checkbox_cp_on', 'h_edit9008', 'h_edit9007','h_edit9006', 'h_edit9005', 'h_edit9004', 'h_edit9003', 'h_edit9002', 'h_edit9001', 'h_pushbutton31', 'h_text3196','h_edit370', 'h_checkbox307','h_edit329', 'h_edit328', 'h_edit327', 'h_edit326', 'h_edit325', 'h_edit324', 'h_edit323', 'h_checkbox301', 'h_pushbutton302', 'h_pushbutton301', 'h_text2196', 'h_text1196', 'h_edit270', 'h_edit170', 'h_checkbox207', 'h_checkbox107', 'h_edit229', 'h_edit228', 'h_edit227', 'h_edit226', 'h_edit225', 'h_edit224', 'h_edit223', 'h_edit129', 'h_edit128', 'h_edit127', 'h_edit126', 'h_edit125', 'h_edit124', 'h_edit123', 'h_checkbox201', 'h_checkbox101', 'h_pushbutton202', 'h_pushbutton201', 'h_pushbutton102', 'h_pushbutton101', 'h_pushbutton23', 'h_edit82', 'h_pushbutton22', 'h_popupmenu6', 'h_edit81', 'h_edit80', 'h_text200', 'h_text199', 'h_text198', 'h_text197', 'h_text196', 'h_checkbox16', 'h_pushbutton21', 'h_checkbox15', 'h_edit76', 'h_edit75', 'h_edit74','h_edit73','h_edit72','h_edit71', 'h_edit70', 'h_edit65', 'h_pushbutton20','h_checkbox14', 'h_checkbox13', 'h_pushbutton17', 'h_pushbutton16', 'h_pushbutton2', 'h_pushbutton1', 'h_pushbutton14','h_popupmenu2', 'h_checkbox11', 'h_checkbox10','h_checkbox9', 'h_checkbox8', 'h_checkbox7', 'h_edit64','h_edit63','h_edit62','h_edit61','h_edit60','h_edit59','h_edit58','h_edit57','h_edit56','h_edit55','h_edit54','h_edit53','h_edit52','h_edit51','h_edit50','h_edit49','h_edit48','h_edit47','h_edit46','h_edit45','h_edit44', 'h_edit36','h_edit35','h_edit34','h_edit33','h_edit32','h_edit31','h_edit30','h_edit29','h_edit28','h_edit27','h_edit26','h_edit25','h_edit24','h_edit23','h_edit15','h_edit14','h_edit13','h_edit12','h_edit7','h_edit6','h_edit3','h_popupmenu1','h_checkbox5','h_checkbox4','h_checkbox3','h_checkbox2','h_pushbutton10','h_pushbutton9','h_pushbutton8','h_pushbutton7','h_pushbutton6','h_pushbutton5', 'h_pushbutton4','h_pushbutton3','h_checkbox1','aux_handle_vec','h_axes2','h_axes1','h','h_colorbar'});
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
zef_close_windows;
zef_data = zef;
zef_data = rmfield(zef_data,{'h_zeffiro','h_zeffiro_window_main','h_interpolate', 'h_source_interpolation_on', 'h_visualization_type', 'h_smoothing_strength', 'h_refinement_on', 'h_wm_sources', 'h_d1_sources', 'h_d2_sources', 'h_d3_sources', 'h_d4_sources', 'h_checkbox_mesh_smoothing_on', 'h_checkbox17', 'h_pushbutton34', 'h_text4196', 'h_edit9009','h_edit470', 'h_checkbox407', 'h_edit429', 'h_edit428', 'h_edit427', 'h_edit426', 'h_edit425', 'h_edit424', 'h_edit423', 'h_checkbox401', 'h_pushbutton402', 'h_pushbutton401', 'h_edit_meshing_accuracy', 'h_text_image', 'h_text_elements', 'h_text_nodes','h_edit_cp_d', 'h_edit_cp_c', 'h_edit_cp_b', 'h_edit_cp_a', 'h_checkbox_cp_on', 'h_edit9008', 'h_edit9007','h_edit9006', 'h_edit9005', 'h_edit9004', 'h_edit9003', 'h_edit9002', 'h_edit9001', 'h_pushbutton31', 'h_text3196','h_edit370', 'h_checkbox307','h_edit329', 'h_edit328', 'h_edit327', 'h_edit326', 'h_edit325', 'h_edit324', 'h_edit323', 'h_checkbox301', 'h_pushbutton302', 'h_pushbutton301', 'h_text2196', 'h_text1196', 'h_edit270', 'h_edit170', 'h_checkbox207', 'h_checkbox107', 'h_edit229', 'h_edit228', 'h_edit227', 'h_edit226', 'h_edit225', 'h_edit224', 'h_edit223', 'h_edit129', 'h_edit128', 'h_edit127', 'h_edit126', 'h_edit125', 'h_edit124', 'h_edit123', 'h_checkbox201', 'h_checkbox101', 'h_pushbutton202', 'h_pushbutton201', 'h_pushbutton102', 'h_pushbutton101', 'h_pushbutton23', 'h_edit82', 'h_pushbutton22', 'h_popupmenu6', 'h_edit81', 'h_edit80', 'h_text200', 'h_text199', 'h_text198', 'h_text197', 'h_text196', 'h_checkbox16', 'h_pushbutton21', 'h_checkbox15', 'h_edit76', 'h_edit75', 'h_edit74','h_edit73','h_edit72','h_edit71', 'h_edit70', 'h_edit65', 'h_pushbutton20','h_checkbox14', 'h_checkbox13', 'h_pushbutton17', 'h_pushbutton16', 'h_pushbutton2', 'h_pushbutton1', 'h_pushbutton14','h_popupmenu2', 'h_checkbox11', 'h_checkbox10','h_checkbox9', 'h_checkbox8', 'h_checkbox7', 'h_edit64','h_edit63','h_edit62','h_edit61','h_edit60','h_edit59','h_edit58','h_edit57','h_edit56','h_edit55','h_edit54','h_edit53','h_edit52','h_edit51','h_edit50','h_edit49','h_edit48','h_edit47','h_edit46','h_edit45','h_edit44', 'h_edit36','h_edit35','h_edit34','h_edit33','h_edit32','h_edit31','h_edit30','h_edit29','h_edit28','h_edit27','h_edit26','h_edit25','h_edit24','h_edit23','h_edit15','h_edit14','h_edit13','h_edit12','h_edit7','h_edit6','h_edit3','h_popupmenu1','h_checkbox5','h_checkbox4','h_checkbox3','h_checkbox2','h_pushbutton10','h_pushbutton9','h_pushbutton8','h_pushbutton7','h_pushbutton6','h_pushbutton5', 'h_pushbutton4','h_pushbutton3','h_checkbox1','aux_handle_vec','h_axes2','h_axes1','h','h_colorbar'});
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
