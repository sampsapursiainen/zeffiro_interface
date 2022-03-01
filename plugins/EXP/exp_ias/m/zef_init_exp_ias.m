%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface

if not(isfield(zef,'exp_ias_q'))
    zef.exp_ias_q = 1;
end
if not(isfield(zef,'exp_ias_hyper_type'))
    zef.exp_ias_hyper_type = 1;
end
if not(isfield(zef,'exp_ias_beta'));
    zef.exp_ias_beta = 1.5;
end;
if not(isfield(zef,'exp_ias_theta0'));
    zef.exp_ias_theta0 = 0.001;
end;
if not(isfield(zef,'inv_snr'));
    zef.inv_snr = 30;
end;
if not(isfield(zef,'inv_n_map_iterations'));
    zef.inv_n_map_iterations = 25;
end;
if not(isfield(zef,'inv_n_L1_iterations'));
    zef.inv_n_L1_iterations = 5;
end;
if not(isfield(zef,'inv_pcg_tol'));
    zef.inv_pcg_tol = 1e-8;
end;
if not(isfield(zef,'inv_sampling_frequency'));
    zef.inv_sampling_frequency = 1025;
end;
if not(isfield(zef,'inv_low_cut_frequency'));
    zef.inv_low_cut_frequency = 7;
end;
if not(isfield(zef,'inv_high_cut_frequency'));
    zef.inv_high_cut_frequency = 9;
end;
if not(isfield(zef,'inv_data_segment'));
    zef.inv_data_segment = 1;
end;
if not(isfield(zef,'normalize_data'));
    zef.normalize_data = 1;
end;

if not(isfield(zef,'inv_time_1'));
    zef.inv_time_1 = 0;
end;
if not(isfield(zef,'inv_time_2'));
    zef.inv_time_2 = 0;
end;
if not(isfield(zef,'inv_time_3'));
    zef.inv_time_3 = 0;
end;
if not(isfield(zef,'number_of_frames'));
    zef.number_of_frames = 1;
end;

zef_childs=allchild(zef.h_exp_ias_map_estimation);

if zef.exp_ias_hyper_type~=3
    set(findobj(zef_childs, 'Tag','h_exp_ias_beta'),'Enable','off');
    set(findobj(zef_childs, 'Tag','h_exp_ias_theta0'),'Enable','off');
else
    set(findobj(zef_childs, 'Tag','h_exp_ias_beta'),'Enable','on');
    set(findobj(zef_childs, 'Tag','h_exp_ias_theta0'),'Enable','on');
end
clear zef_childs

set(zef.h_exp_ias_q ,'value',zef.exp_ias_q);
set(zef.h_exp_ias_hyper_type ,'value',zef.exp_ias_hyper_type);
set(zef.h_exp_ias_beta ,'string',num2str(zef.exp_ias_beta));
set(zef.h_exp_ias_theta0 ,'string',num2str(zef.exp_ias_theta0));
set(zef.h_exp_ias_snr ,'string',num2str(zef.inv_snr));
set(zef.h_exp_ias_n_map_iterations ,'string',num2str(zef.inv_n_map_iterations));
set(zef.h_exp_ias_n_L1_iterations ,'string',num2str(zef.inv_n_L1_iterations));
% set(zef.h_exp_ias_pcg_tol ,'string',num2str(zef.exp_ias_pcg_tol));
set(zef.h_exp_ias_sampling_frequency ,'string',num2str(zef.inv_sampling_frequency));
set(zef.h_exp_ias_low_cut_frequency ,'string',num2str(zef.inv_low_cut_frequency));
set(zef.h_exp_ias_high_cut_frequency ,'string',num2str(zef.inv_high_cut_frequency));
set(zef.h_exp_ias_data_segment ,'string',num2str(zef.inv_data_segment));
set(zef.h_exp_ias_normalize_data ,'value',zef.normalize_data);
set(zef.h_exp_ias_time_1 ,'string',num2str(zef.inv_time_1));
set(zef.h_exp_ias_time_2 ,'string',num2str(zef.inv_time_2));
set(zef.h_exp_ias_time_3 ,'string',num2str(zef.inv_time_3));
set(zef.h_exp_ias_number_of_frames ,'string',num2str(zef.number_of_frames));