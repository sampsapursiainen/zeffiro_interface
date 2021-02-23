[zef.sensors,zef.reuna_p,zef.reuna_t,zef.reuna_p_inf] = process_meshes([]); 
zef.on_screen = 2;set(zef.h_text_image,'string','surfaces'); 
zef_update_fig_details;plot_meshes([]); 
zef.stop_movie = 0; 
set(zef.h_stop_movie,'value',zef.stop_movie);