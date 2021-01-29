run('../zeffiro_interface_nodisplay');

zef.file_path = [zef.program_path '/data'];
zef.file_name = 'sampsa_debug_version.mat';

zef_load_nodisplay;
zef_make_all_nodisplay;

zef.save_switch = 7;
zef_save_nodisplay;

exit;
