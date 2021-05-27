%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface

if not(isfield(zef,'exp_em_q'))
    zef.exp_em_q = 1;
end
if not(isfield(zef,'exp_em_hyper_type'))
    zef.exp_em_hyper_type = 1;
end
if not(isfield(zef,'exp_em_beta')); 
    zef.exp_em_beta = 1.5; 
end;
if not(isfield(zef,'exp_em_theta0')); 
    zef.exp_em_theta0 = 0.001; 
end;
if not(isfield(zef,'exp_em_snr')); 
    zef.exp_em_snr = 30; 
end;
if not(isfield(zef,'exp_em_n_map_iterations')); 
    zef.exp_em_n_map_iterations = 25; 
end;
if not(isfield(zef,'exp_em_n_L1_iterations')); 
    zef.exp_em_n_L1_iterations = 5; 
end;
if not(isfield(zef,'exp_em_pcg_tol')); 
    zef.exp_em_pcg_tol = 1e-8; 
end;
if not(isfield(zef,'exp_em_sampling_frequency')); 
    zef.exp_em_sampling_frequency = 1025; 
end;
if not(isfield(zef,'exp_em_low_cut_frequency')); 
    zef.exp_em_low_cut_frequency = 7; 
end;
if not(isfield(zef,'exp_em_high_cut_frequency')); 
    zef.exp_em_high_cut_frequency = 9; 
end;
if not(isfield(zef,'exp_em_data_segment')); 
    zef.exp_em_data_segment = 1; 
end;
if not(isfield(zef,'exp_em_normalize_data')); 
    zef.exp_em_normalize_data = 1; 
end;

if not(isfield(zef,'exp_em_time_1')); 
    zef.exp_em_time_1 = 0; 
end;
if not(isfield(zef,'exp_em_time_2')); 
    zef.exp_em_time_2 = 0; 
end;
if not(isfield(zef,'exp_em_time_3')); 
    zef.exp_em_time_3 = 0; 
end;
if not(isfield(zef,'exp_em_number_of_frames')); 
    zef.exp_em_number_of_frames = 1; 
end;

zef_childs=allchild(zef.h_exp_em_map_estimation);

if zef.exp_em_hyper_type~=3
    set(findobj(zef_childs, 'Tag','h_exp_em_beta'),'Enable','off');
    set(findobj(zef_childs, 'Tag','h_exp_em_theta0'),'Enable','off');
else
    set(findobj(zef_childs, 'Tag','h_exp_em_beta'),'Enable','on');
    set(findobj(zef_childs, 'Tag','h_exp_em_theta0'),'Enable','on');    
end
clear zef_childs

set(zef.h_exp_em_q ,'value',zef.exp_em_q);
set(zef.h_exp_em_hyper_type ,'value',zef.exp_em_hyper_type);
set(zef.h_exp_em_beta ,'string',num2str(zef.exp_em_beta));
set(zef.h_exp_em_theta0 ,'string',num2str(zef.exp_em_theta0));
set(zef.h_exp_em_snr ,'string',num2str(zef.exp_em_snr));
set(zef.h_exp_em_n_map_iterations ,'string',num2str(zef.exp_em_n_map_iterations));
set(zef.h_exp_em_n_L1_iterations ,'string',num2str(zef.exp_em_n_L1_iterations));
% set(zef.h_exp_em_pcg_tol ,'string',num2str(zef.exp_em_pcg_tol));
set(zef.h_exp_em_sampling_frequency ,'string',num2str(zef.exp_em_sampling_frequency));
set(zef.h_exp_em_low_cut_frequency ,'string',num2str(zef.exp_em_low_cut_frequency));
set(zef.h_exp_em_high_cut_frequency ,'string',num2str(zef.exp_em_high_cut_frequency));
set(zef.h_exp_em_data_segment ,'string',num2str(zef.exp_em_data_segment));
set(zef.h_exp_em_normalize_data ,'value',zef.exp_em_normalize_data);
set(zef.h_exp_em_time_1 ,'string',num2str(zef.exp_em_time_1));
set(zef.h_exp_em_time_2 ,'string',num2str(zef.exp_em_time_2));
set(zef.h_exp_em_time_3 ,'string',num2str(zef.exp_em_time_3));
set(zef.h_exp_em_number_of_frames ,'string',num2str(zef.exp_em_number_of_frames));