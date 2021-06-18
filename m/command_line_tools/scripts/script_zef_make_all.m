run('../../../zeffiro_interface_nodisplay');

zef.file_path = [zef.program_path '/data/'];
zef.file = 'sampsa_debug_version.mat';

zef_load_nodisplay;

zef_set_gpu_nodisplay;

zef_make_all_nodisplay;

zef.file = 'sampsa_debug_version.mat';
zef.save_file = 'sampsa_debug_version.mat';
zef.save_switch = 7;
zef_save_nodisplay;

exit;
