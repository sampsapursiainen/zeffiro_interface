[zef.file zef.file_path zef.file_index] = uiputfile({'*.jpg';'*.tif';'*.png';'*.avi'},'Save visualization as...',zef.save_file_path); 
if not(isequal(zef.file,0)); 
    [zef.sensors,zef.reuna_p,zef.reuna_t,zef.reuna_p_inf] = process_meshes([]); 
    print_meshes([]); 
end;