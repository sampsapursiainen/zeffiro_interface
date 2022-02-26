function [z, info] = zef_mne(void)

inverse_gamma_ind = [1:4];
gamma_ind = [5:10];
h = waitbar(0,['MNE Reconstruction.']);
[s_ind_1] = unique(evalin('base','zef.source_interpolation_ind{1}'));
n_interp = length(s_ind_1);

pm_val = evalin('base','zef.inv_prior_over_measurement_db');
amplitude_db = evalin('base','zef.inv_amplitude_db');
pm_val = pm_val - amplitude_db;

snr_val = evalin('base','zef.inv_snr');
mne_type = evalin('base','zef.mne_type');
mne_prior = evalin('base','zef.mne_prior');
std_lhood = 10^(-snr_val/20);
sampling_freq = evalin('base','zef.mne_sampling_frequency');
high_pass = evalin('base','zef.mne_low_cut_frequency');
low_pass = evalin('base','zef.mne_high_cut_frequency');
number_of_frames = evalin('base','zef.mne_number_of_frames');
time_step = evalin('base','zef.mne_time_3');
source_direction_mode = evalin('base','zef.source_direction_mode');
source_directions = evalin('base','zef.source_directions');

info=[];
info.tag='mne_type';
info.type='mne_type';
info.std_lhood=std_lhood;

info.snr_val = evalin('base','zef.inv_snr');
info.mne_type = evalin('base','zef.mne_type');
info.mne_prior = evalin('base','zef.mne_prior');
info.sampling_freq = evalin('base','zef.mne_sampling_frequency');
info.high_pass = evalin('base','zef.mne_low_cut_frequency');
info.low_pass = evalin('base','zef.mne_high_cut_frequency');
info.number_of_frames = evalin('base','zef.mne_number_of_frames');
info.time_step = evalin('base','zef.mne_time_3');
info.source_direction_mode = evalin('base','zef.source_direction_mode');
info.source_directions = evalin('base','zef.source_directions');

if source_direction_mode == 2

[s_ind_3] = evalin('base','zef.source_interpolation_ind{3}');

i = 0;
length_reuna = 0;
sigma_vec = [];
priority_vec = [];
visible_vec = [];
color_cell = cell(0);
aux_brain_ind = [];
aux_dir_mode = [];
submesh_cell = cell(0);
compartment_tags = evalin('base','zef.compartment_tags');
for k = 1 : length(compartment_tags)
        var_0 = ['zef.'  compartment_tags{k} '_on'];
        var_1 = ['zef.' compartment_tags{k} '_sigma'];
        var_2 = ['zef.' compartment_tags{k} '_priority'];
        var_3 = ['zef.' compartment_tags{k} '_visible'];
        var_4 = ['zef.' compartment_tags{k} '_submesh_ind'];
    color_str = evalin('base',['zef.' compartment_tags{k} '_color']);
on_val = evalin('base',var_0);
sigma_val = evalin('base',var_1);
priority_val = evalin('base',var_2);
visible_val = evalin('base',var_3);
submesh_ind = evalin('base',var_4);
if on_val
i = i + 1;
sigma_vec(i,1) = sigma_val;
priority_vec(i,1) = priority_val;
color_cell{i} = color_str;
visible_vec(i,1) = i*visible_val;
submesh_cell{i} = submesh_ind;
if evalin('base',['zef.' compartment_tags{k} '_sources'])>0;
    aux_brain_ind = [aux_brain_ind i];
    aux_dir_mode = [aux_dir_mode evalin('base',['zef.' compartment_tags{k} '_sources'])-1];
end
end
end

i = 0;
length_reuna = 0;
sigma_vec = [];
priority_vec = [];
visible_vec = [];
color_cell = cell(0);
aux_brain_ind = [];
aux_dir_mode = [];
submesh_cell = cell(0);
for k = 1 : length(compartment_tags)
        var_0 = ['zef.'  compartment_tags{k} '_on'];
        var_1 = ['zef.' compartment_tags{k} '_sigma'];
        var_2 = ['zef.' compartment_tags{k} '_priority'];
        var_3 = ['zef.' compartment_tags{k} '_visible'];
        var_4 = ['zef.' compartment_tags{k} '_submesh_ind'];
    color_str = evalin('base',['zef.' compartment_tags{k} '_color']);
on_val = evalin('base',var_0);
sigma_val = evalin('base',var_1);
priority_val = evalin('base',var_2);
visible_val = evalin('base',var_3);
submesh_ind = evalin('base',var_4);
if on_val
i = i + 1;
sigma_vec(i,1) = sigma_val;
priority_vec(i,1) = priority_val;
color_cell{i} = color_str;
visible_vec(i,1) = i*visible_val;
submesh_cell{i} = submesh_ind;
if evalin('base',['zef.' compartment_tags{k} '_sources'])>0;
    aux_brain_ind = [aux_brain_ind i];
    aux_dir_mode = [aux_dir_mode evalin('base',['zef.' compartment_tags{k} '_sources'])-1];
end
end
end

a_d_i_vec = [];
aux_p = [];
aux_t = [];

for ab_ind = 1 : length(aux_brain_ind)

aux_t = [aux_t ; size(aux_p,1) + evalin('base',['zef.reuna_t{' int2str(aux_brain_ind(ab_ind)) '}'])];
aux_p = [aux_p ; evalin('base',['zef.reuna_p{' int2str(aux_brain_ind(ab_ind)) '}'])];
a_d_i_vec = [a_d_i_vec ; aux_dir_mode(ab_ind)*ones(size(evalin('base',['zef.reuna_p{' int2str(aux_brain_ind(ab_ind)) '}']),1),1)];

end

a_d_i_vec = a_d_i_vec(aux_t(:,1));
n_vec_aux = cross(aux_p(aux_t(:,2),:)' - aux_p(aux_t(:,1),:)', aux_p(aux_t(:,3),:)' - aux_p(aux_t(:,1),:)')';
n_vec_aux = n_vec_aux./repmat(sqrt(sum(n_vec_aux.^2,2)),1,3);

n_vec_aux(:,1) = smooth_field(aux_t, n_vec_aux(:,1), size(aux_p(:,1),1),7);
n_vec_aux(:,2) = smooth_field(aux_t, n_vec_aux(:,2), size(aux_p(:,1),1),7);
n_vec_aux(:,3) = smooth_field(aux_t, n_vec_aux(:,3), size(aux_p(:,1),1),7);

n_vec_aux =  - n_vec_aux./repmat(sqrt(sum(n_vec_aux.^2,2)),1,3);

s_ind_4 = find(not(a_d_i_vec(s_ind_3)));
source_directions = n_vec_aux(s_ind_3,:);

end

if source_direction_mode == 3
source_directions = source_directions(s_ind_1,:);
end

if source_direction_mode == 1  || source_direction_mode == 2
s_ind_1 = [3*s_ind_1-2 ; 3*s_ind_1-1 ; 3*s_ind_1];
end
if  source_direction_mode == 3
s_ind_2 = [3*s_ind_1-2 ; 3*s_ind_1-1 ; 3*s_ind_1];
end

s_ind_1 = s_ind_1(:);

L = evalin('base','zef.L');
L = L(:,s_ind_1);

if source_direction_mode == 2

L_1 = L(:,1:n_interp);
L_2 = L(:,n_interp+1:2*n_interp);
L_3 = L(:,2*n_interp+1:3*n_interp);
s_1 = source_directions(:,1)';
s_2 = source_directions(:,2)';
s_3 = source_directions(:,3)';
ones_vec = ones(size(L,1),1);
L_0 = L_1(:,s_ind_4).*s_1(ones_vec,s_ind_4) + L_2(:,s_ind_4).*s_2(ones_vec,s_ind_4) + L_3(:,s_ind_4).*s_3(ones_vec,s_ind_4);
L(:,s_ind_4) = L_0;
L(:,n_interp+s_ind_4) = L_0;
L(:,2*n_interp+s_ind_4) = L_0;
clear L_0 L_1 L_2 L_3 s_1 s_2 s_3;

end

source_count = n_interp;
if evalin('base','zef.mne_normalize_data')==1;
    normalize_data = 'maximum';
else
    normalize_data = 'average';
end

if mne_prior == 1
    balance_spatially = 1;
else
    balance_spatially = 0;
end

[theta0] = zef_find_gaussian_prior(snr_val-pm_val,L,size(L,2),evalin('base','zef.mne_normalize_data'),0);

if evalin('base','zef.use_gpu') == 1 & gpuDeviceCount > 0
L = gpuArray(L);
end

S_mat = std_lhood^2*eye(size(L,1));
if evalin('base','zef.use_gpu') == 1 & gpuDeviceCount > 0
S_mat = gpuArray(S_mat);
end

if number_of_frames > 1
z = cell(number_of_frames,1);
else
number_of_frames = 1;
end

if iscell(evalin('base','zef.measurements'));
f = evalin('base',['zef.measurements{' int2str(evalin('base','zef.mne_data_segment')) '}']);
else
f = evalin('base','zef.measurements');
end

data_norm = 1;
if evalin('base','zef.mne_normalize_data')==1;
data_norm = max(abs(f(:)));
%std_lhood = std_lhood^2;
elseif evalin('base','zef.mne_normalize_data')==2;
data_norm = max(sqrt(sum(abs(f).^2)));
%std_lhood = std_lhood^2;
elseif evalin('base','zef.mne_normalize_data')==3;
data_norm = sum(sqrt(sum(abs(f).^2)))/size(f,2);
%std_lhood = std_lhood^2;
end;
f = f/data_norm;

filter_order = 3;
if size(f,2) > 1 && low_pass > 0
[lp_f_1,lp_f_2] = ellip(filter_order,3,80,low_pass/(sampling_freq/2));
f = filter(lp_f_1,lp_f_2,f')';
end
if size(f,2) > 1 && high_pass > 0
[hp_f_1,hp_f_2] = ellip(filter_order,3,80,high_pass/(sampling_freq/2),'high');
f = filter(hp_f_1,hp_f_2,f')';
end

f_data = f;
size_f = size(f,2);

tic;
for f_ind = 1 : number_of_frames
time_val = toc;
if f_ind > 1;
date_str = datestr(datevec(now+(number_of_frames/(f_ind-1) - 1)*time_val/86400));
end;

if ismember(source_direction_mode, [1,2])
z_aux = zeros(size(L,2),1);
end
if source_direction_mode == 3
z_aux = zeros(3*size(L,2),1);
end
z_vec = ones(size(L,2),1);

%aux_norm = (sum(L.^2))';
%aux_norm = aux_norm./max(aux_norm(:));
%theta = theta0*aux_norm;

if size_f > 1
if evalin('base','zef.mne_time_2') >=0 && evalin('base','zef.mne_time_1') >= 0 && 1 + sampling_freq*evalin('base','zef.mne_time_1') <= size_f;
f = f_data(:, max(1, 1 + floor(sampling_freq*evalin('base','zef.mne_time_1')+sampling_freq*(f_ind - 1)*evalin('base','zef.mne_time_3'))) : min(size_f, 1 + floor(sampling_freq*(evalin('base','zef.mne_time_1') + evalin('base','zef.mne_time_2'))+sampling_freq*(f_ind - 1)*evalin('base','zef.mne_time_3'))));
end
end
if size_f > 1
t = [1:size_f];
%gaussian_window = blackmanharris(length(t))';
%f = f.*gaussian_window;
f = mean(f,2);
end
if f_ind == 1
waitbar(0,h,['MNE reconstruction. Time step ' int2str(f_ind) ' of ' int2str(number_of_frames) '.']);
end

if evalin('base','zef.use_gpu') == 1 & gpuDeviceCount > 0
f = gpuArray(f);
end

if f_ind > 1;
waitbar(f_ind/number_of_frames,h,['Step ' int2str(f_ind) ' of ' int2str(number_of_frames) '. Ready: ' date_str '.' ]);
else
waitbar(f_ind/number_of_frames,h,['MNE reconstruction. Time step ' int2str(f_ind) ' of ' int2str(number_of_frames) '.' ]);
end;
m_max = sqrt(size(L,2));
u = zeros(length(z_vec),1);
z_vec = zeros(length(z_vec),1);
if length(theta0)==1
d_sqrt = sqrt(theta0)*ones(size(z_vec));
else
    d_sqrt = sqrt(theta0);
end
if evalin('base','zef.use_gpu') == 1 & gpuDeviceCount > 0
d_sqrt = gpuArray(d_sqrt);
end
L_inv = L.*repmat(d_sqrt',size(L,1),1);
L_inv = d_sqrt.*(L_inv'*(inv(L_inv*L_inv' + S_mat)));

if isequal(mne_type,2)
% dSPM
    aux_vec = sum(L_inv.^2, 2);
    aux_vec = sqrt(aux_vec);
    L_inv = L_inv./aux_vec(:,ones(size(L_inv,2),1));

elseif isequal(mne_type, 3)
%'sLORETA'

aux_vec = sqrt(sum(L_inv.*L', 2));
L_inv = L_inv./aux_vec(:,ones(size(L_inv,2),1));

end

z_vec = L_inv * f;

if evalin('base','zef.use_gpu') == 1 & gpuDeviceCount > 0
z_vec = gather(z_vec);
end

if ismember(source_direction_mode,[2])
z_vec_aux = (z_vec(s_ind_4) + z_vec(n_interp+s_ind_4) + z_vec(2*n_interp+s_ind_4))/3;
z_vec(s_ind_4) = z_vec_aux.*source_directions(s_ind_4,1);
z_vec(n_interp+s_ind_4) = z_vec_aux.*source_directions(s_ind_4,2);
z_vec(2*n_interp+s_ind_4) = z_vec_aux.*source_directions(s_ind_4,3);
end

if ismember(source_direction_mode,[3])
z_vec = [z_vec.*source_directions(:,1); z_vec.*source_directions(:,2); z_vec.*source_directions(:,3)];
end

if ismember(source_direction_mode,[1 2])
z_aux(s_ind_1) = z_vec;
end
if ismember(source_direction_mode,[3])
z_aux(s_ind_2) = z_vec;
end

if number_of_frames > 1;
z{f_ind} = z_aux;
else
z = z_aux;
end
end
if number_of_frames > 1;
aux_norm_vec = 0;
for f_ind = 1 : number_of_frames;
aux_norm_vec = max(sqrt(sum(reshape(z{f_ind}, 3, length(z{f_ind})/3).^2)),aux_norm_vec);
end;
for f_ind = 1 : number_of_frames;
z{f_ind} = z{f_ind}./max(aux_norm_vec);
end;
else
aux_norm_vec = sqrt(sum(reshape(z, 3, length(z)/3).^2));
z = z./max(aux_norm_vec);
end;
close(h);
end

