
zef_process_meshes(zef.explode_everything);
zef.on_screen = 2;
zef_update_fig_details;zef_plot_meshes([]);
zef.stop_movie = 0;

zef.frame_start=str2double(zef.h_frame_start.Value);
zef.frame_stop=str2double(zef.h_frame_stop.Value);

set(zef.h_stop_movie,'value',zef.stop_movie);
set(zef.h_stop_movie,'foregroundcolor',[0 0 0]);
set(zef.h_stop_movie,'string','Stop');

set(zef.h_stop_movie,'value',zef.stop_movie);
set(zef.h_pause_movie,'foregroundcolor',[0 0 0]);
set(zef.h_pause_movie,'string','Pause');
