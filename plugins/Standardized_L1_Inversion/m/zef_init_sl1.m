%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
function zef = zef_init_sl1(zef)

zef = zef_sl1_map_estimation_window(zef);

set(zef.h_sl1_map_estimation,'Position',[ 0.5764    0.2944    0.15    0.40]);

set(zef.h_sl1_map_estimation,'Name','ZEFFIRO Interface: Standardized Hierarchical L1 MAP estimation');
set(findobj(zef.h_sl1_map_estimation.Children,'-property','FontUnits'),'FontUnits','pixels')
set(findobj(zef.h_sl1_map_estimation.Children,'-property','FontSize'),'FontSize',zef.font_size);

set(zef.h_sl1_start,'Callback','zef_update_sl1; [zef.reconstruction, zef.reconstruction_information] = zef_sl1_iteration(zef);');

if not(isfield(zef,'sl1_hyperprior'));
    zef.sl1_hyperprior = 2;
end;
if not(isfield(zef,'sl1_n_map_iterations'));
    zef.sl1_n_map_iterations = 25;
end;
if not(isfield(zef,'sl1_pcg_tol'));
    zef.sl1_pcg_tol = 1e-8;
end;

zef.sl1_sampling_frequency = zef.inv_sampling_frequency;
zef.sl1_low_cut_frequency = zef.inv_low_cut_frequency;
zef.sl1_high_cut_frequency = zef.inv_high_cut_frequency;

if not(isfield(zef,'sl1_normalize_data'));
    zef.sl1_normalize_data = 1;
end;

if not(isfield(zef,'sl1_type'));
    zef.sl1_type = 1;
end;


zef.sl1_time_1 = zef.inv_time_1;
zef.sl1_time_2 = zef.inv_time_2;
zef.sl1_time_3 = zef.inv_time_3;
zef.sl1_number_of_frames = zef.number_of_frames;

if not(isfield(zef,'sl1_data_segment'));
    zef.sl1_data_segment = 1;
end;

zef.sl1_snr = zef.inv_snr;

set(zef.h_sl1_hyperprior ,'value',zef.sl1_hyperprior);
set(zef.h_sl1_type ,'value',zef.sl1_type);
set(zef.h_sl1_snr ,'string',num2str(zef.sl1_snr));
set(zef.h_sl1_n_map_iterations ,'string',num2str(zef.sl1_n_map_iterations));
set(zef.h_sl1_sampling_frequency ,'string',num2str(zef.sl1_sampling_frequency));
set(zef.h_sl1_low_cut_frequency ,'string',num2str(zef.sl1_low_cut_frequency));
set(zef.h_sl1_high_cut_frequency ,'string',num2str(zef.sl1_high_cut_frequency));
set(zef.h_sl1_normalize_data ,'value',zef.sl1_normalize_data);
set(zef.h_sl1_time_1 ,'string',num2str(zef.sl1_time_1));
set(zef.h_sl1_time_2 ,'string',num2str(zef.sl1_time_2));
set(zef.h_sl1_time_3 ,'string',num2str(zef.sl1_time_3));
set(zef.h_sl1_number_of_frames ,'string',num2str(zef.sl1_number_of_frames));

uistack(flipud([zef.h_sl1_hyperprior ;
    zef.h_sl1_snr ; zef.h_sl1_n_map_iterations ;
    zef.h_sl1_sampling_frequency ; zef.h_sl1_low_cut_frequency ;
    zef.h_sl1_high_cut_frequency ; zef.h_sl1_time_1 ; zef.h_sl1_time_2; zef.h_sl1_number_of_frames; zef.h_sl1_time_3 ; zef.h_sl1_cancel ;
    zef.h_sl1_apply; zef.h_sl1_start  ]),'top');

end
