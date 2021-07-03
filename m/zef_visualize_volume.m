[zef.sensors,zef.reuna_p,zef.reuna_t,zef.reuna_p_inf] = process_meshes(zef.explode_everything); 
zef.on_screen = 1;
zef_update_fig_details;plot_volume([]); 
zef.stop_movie = 0; 
set(zef.h_stop_movie,'value',zef.stop_movie);