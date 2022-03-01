%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
function [z,rec_source] = ias_iteration_roi(void)

h = waitbar(0,['IAS MAP iteration.']);
[s_ind_1] = unique(evalin('base','zef.source_interpolation_ind{1}'));
s_ind_0 = s_ind_1;
n_interp = length(s_ind_1(:));

iasroi_hyperprior = evalin('base','zef.iasroi_hyperprior');
source_positions = evalin('base','zef.source_positions');
source_positions = source_positions(s_ind_1,:);
roi_mode = evalin('base','zef.iasroi_roi_mode');
roi_threshold = evalin('base','zef.iasroi_roi_threshold');
roi_sphere = evalin('base', 'zef.iasroi_roi_sphere');
rec_source = evalin('base', 'zef.iasroi_rec_source');
r_roi = roi_sphere(:,4);
c_roi = roi_sphere(:,1:3)';
snr_val = evalin('base','zef.iasroi_snr');
pm_val = evalin('base','zef.inv_prior_over_measurement_db');
amplitude_db = evalin('base','zef.inv_amplitude_db');
pm_val = pm_val - amplitude_db;
std_lhood = 10^(-snr_val/20);
sampling_freq = evalin('base','zef.iasroi_sampling_frequency');
high_pass = evalin('base','zef.iasroi_low_cut_frequency');
low_pass = evalin('base','zef.iasroi_high_cut_frequency');
number_of_frames = evalin('base','zef.iasroi_number_of_frames');
time_step = evalin('base','zef.iasroi_time_3');
source_direction_mode = evalin('base','zef.source_direction_mode');
source_directions = evalin('base','zef.source_directions');

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

I_aux = [];
roi_ind_vec = [];

if roi_mode == 1

for j = 1 : size(roi_sphere,1)

r_aux = find(sqrt(sum((source_positions'-c_roi(:,j*ones(1,size(source_positions,1)))).^2))<=r_roi(j));
I_aux = [I_aux r_aux];
roi_ind_vec = [roi_ind_vec j*ones(1,size(r_aux,2))];

end
roi_ind_vec = roi_ind_vec(:);
end

if roi_mode == 2
reconstruction = evalin('base','zef.reconstruction');
reconstruction = reconstruction(s_ind_1);
reconstruction = reshape(reconstruction,length(reconstruction)/3,3);
reconstruction = sqrt(sum(reconstruction.^2,2));
reconstruction = reconstruction/max(reconstruction(:));
I_aux = find(reconstruction >= roi_threshold);
end

if roi_mode == 3
source_ind_aux = evalin('base','zef.source_interpolation_ind{1}');
p_ind_aux_1 = [];
p_selected = evalin('base','zef.parcellation_selected');
for p_ind = 1 : length(p_selected)
p_ind_aux_2 = evalin('base',['zef.parcellation_interp_ind{' int2str(p_selected(p_ind)) '}{1}']);
p_ind_aux_1 = [p_ind_aux_1 ;  unique(p_ind_aux_2)];
end
p_ind_aux_1 = unique(p_ind_aux_1);
I_aux = unique(source_ind_aux(p_ind_aux_1,:));
I_aux = find(ismember(s_ind_0,I_aux));
end

if source_direction_mode == 2
    roi_length = length(I_aux(:));
    s_ind_5 = intersect(s_ind_4,I_aux(:));
    s_ind_5 = find(ismember(I_aux(:),s_ind_5));
end

if source_direction_mode == 1 || source_direction_mode == 2
roi_aux_ind = [I_aux(:) ; n_interp + I_aux(:) ; 2*n_interp + I_aux(:)];
else
roi_aux_ind = I_aux(:);
end
roi_aux_ind = roi_aux_ind(:);

n_lead_field = size(L,2);
L = L(:,roi_aux_ind);

source_count = n_interp;
if evalin('base','zef.iasroi_normalize_data')==1;
    normalize_data = 'maximum';
else
    normalize_data = 'average';
end
if iasroi_hyperprior == 1
    balance_spatially = 1;
else
    balance_spatially = 0;
end
if evalin('base','zef.inv_hyperprior') == 1
[beta, theta0] = zef_find_ig_hyperprior(snr_val-pm_val,evalin('base','zef.inv_hyperprior_tail_length_db'),L,size(L,2),evalin('base','zef.iasroi_normalize_data'),balance_spatially,evalin('base','zef.inv_hyperprior_weight'));
elseif evalin('base','zef.inv_hyperprior') == 2
[beta, theta0] = zef_find_g_hyperprior(snr_val-pm_val,evalin('base','zef.inv_hyperprior_tail_length_db'),L,size(L,2),evalin('base','zef.iasroi_normalize_data'),balance_spatially,evalin('base','zef.inv_hyperprior_weight'));
end

if evalin('base','zef.use_gpu') == 1 & gpuDeviceCount > 0
L = gpuArray(L);
end
L_aux = L;
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
f = evalin('base',['zef.measurements{' int2str(evalin('base','zef.iasroi_data_segment')) '}']);
else
f = evalin('base','zef.measurements');
end

inverse_gamma_ind = [1:4]
gamma_ind = [5:10];

data_norm = 1;
if evalin('base','zef.iasroi_normalize_data')==1;
data_norm = max(abs(f(:)));
%std_lhood = std_lhood^2;
elseif evalin('base','zef.iasroi_normalize_data')==2;
data_norm = max(sqrt(sum(abs(f).^2)));
%std_lhood = std_lhood^2;
elseif evalin('base','zef.iasroi_normalize_data')==3;
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

size_f = size(f,2);
f_data = f;

tic;
for f_ind = 1 : number_of_frames
time_val = toc;
if f_ind > 1;
date_str = datestr(datevec(now+(number_of_frames/(f_ind-1) - 1)*time_val/86400));
end;

if source_direction_mode == 1 || source_direction_mode == 2
z_aux = zeros(size(L,2),1);
end
if source_direction_mode == 3
z_aux = zeros(3*size(L,2),1);
end
z_vec = ones(size(L,2),1);

if evalin('base','zef.inv_hyperprior') == 1
if length(theta0) > 1  || length(beta) > 1
theta = theta0./(beta-1);
else
theta = (theta0./(beta-1))*ones(size(L,2),1);
end
elseif evalin('base','zef.inv_hyperprior') == 2
if length(theta0) > 1  || length(beta) > 1
theta = theta0.*beta;
else
theta = (theta0.*beta)*ones(size(L,2),1);
end
end

%aux_norm = (sum(L.^2))';
%aux_norm = aux_norm./max(aux_norm(:));
%theta = theta0*aux_norm;

if size_f > 1
if evalin('base','zef.iasroi_time_2') >=0 0 && evalin('base','zef.iasroi_time_1') >= 0 & 1 + sampling_freq*evalin('base','zef.iasroi_time_1') <= size_f;
f = f_data(:, max(1, 1 + floor(sampling_freq*evalin('base','zef.iasroi_time_1')+sampling_freq*(f_ind - 1)*evalin('base','zef.iasroi_time_3'))) : min(size_f, 1 + floor(sampling_freq*(evalin('base','zef.iasroi_time_1') + evalin('base','zef.iasroi_time_2'))+sampling_freq*(f_ind - 1)*evalin('base','zef.iasroi_time_3'))));
end
end
if size_f > 1
t = [1:size_f];
%gaussian_window = blackmanharris(length(t))';
%f = f.*gaussian_window;
f = mean(f,2);
end
if f_ind == 1
waitbar(0,h,['IAS MAP iteration. Time step ' int2str(f_ind) ' of ' int2str(number_of_frames) '.']);
end
n_ias_map_iter = evalin('base','zef.iasroi_n_map_iterations');

if evalin('base','zef.use_gpu') == 1 & gpuDeviceCount > 0
f = gpuArray(f);
end

for i = 1 : n_ias_map_iter
if f_ind > 1;
waitbar(i/n_ias_map_iter,h,['Step ' int2str(f_ind) ' of ' int2str(number_of_frames) '. Ready: ' date_str '.' ]);
else
waitbar(i/n_ias_map_iter,h,['IAS MAP iteration. Time step ' int2str(f_ind) ' of ' int2str(number_of_frames) '.' ]);
end;
m_max = sqrt(size(L,2));
u = zeros(length(z_vec),1);
z_vec = zeros(length(z_vec),1);
d_sqrt = sqrt(theta);
if evalin('base','zef.use_gpu') == 1 & gpuDeviceCount > 0
d_sqrt = gpuArray(d_sqrt);
end
L = L_aux.*repmat(d_sqrt',size(L,1),1);
z_vec = d_sqrt.*(L'*((L*L' + S_mat)\f));

if evalin('base','zef.use_gpu') == 1 & gpuDeviceCount > 0
z_vec = gather(z_vec);
end
if evalin('base','zef.inv_hyperprior') == 1
theta = (theta0+0.5*z_vec.^2)./(beta + 1.5);
elseif evalin('base','zef.inv_hyperprior') == 2
theta = theta0.*(beta-1.5 + sqrt((1./(2.*theta0)).*z_vec.^2 + (beta+1.5).^2));
end
end;

if ismember(source_direction_mode,[2])
z_vec_aux = (z_vec(s_ind_5) + z_vec(roi_length+s_ind_5) + z_vec(2*roi_length+s_ind_5))/3;
z_vec(s_ind_5) = z_vec_aux.*source_directions(I_aux(s_ind_5),1);
z_vec(roi_length+s_ind_5) = z_vec_aux.*source_directions(I_aux(s_ind_5),2);
z_vec(2*roi_length+s_ind_5) = z_vec_aux.*source_directions(I_aux(s_ind_5),3);
end

if source_direction_mode == 3
z_vec = [z_vec.*source_directions(roi_aux_ind,1); z_vec.*source_directions(roi_aux_ind,2);  z_vec.*source_directions(roi_aux_ind,3)];
roi_aux_ind = [roi_aux_ind(:) ; n_interp + roi_aux_ind(:) ; 2*n_interp + roi_aux_ind(:)];
%z_vec = z_vec(:);
end

if roi_mode == 1

rec_size = length(roi_ind_vec);
for j = 1 : size(roi_sphere,1)
    r_aux = find(roi_ind_vec==j);
    w_vec = (sum([z_vec(r_aux) z_vec(rec_size+r_aux) z_vec(2*rec_size +r_aux)].^2,2));
    rec_pos = [w_vec.*source_positions(roi_aux_ind(r_aux),1) w_vec.*source_positions(roi_aux_ind(r_aux),2) w_vec.*source_positions(roi_aux_ind(r_aux),3)];
    rec_pos = sum(rec_pos)./sum([w_vec w_vec w_vec]);
    rec_dir =  1e3*sum([z_vec(r_aux) z_vec(rec_size+r_aux) z_vec(2*rec_size +r_aux)]);
    rec_norm = norm(rec_dir);
    rec_dir = rec_dir/rec_norm;
rec_source(j,1:7) = [rec_pos rec_dir rec_norm];
end
end

if ismember(source_direction_mode, [1,2])
z_vec_aux = zeros(n_lead_field,1);
else
z_vec_aux = zeros(3*n_lead_field,1);
end
z_vec_aux(roi_aux_ind) = z_vec;
z_vec = z_vec_aux;

if ismember(source_direction_mode, [1,2])
    z_aux(s_ind_1) = z_vec;
end
if source_direction_mode == 3
z_aux(s_ind_2) = z_vec;
end

if number_of_frames > 1;
z{f_ind} = z_aux;
else
z = z_aux;
end;
end;
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
