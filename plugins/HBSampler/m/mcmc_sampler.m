%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
function [z,rec_source] = mcmc_sampler(void)

h = waitbar(0,['Sampling.']);

n_sampler = evalin('base','zef.inv_n_sampler');
n_burn_in = evalin('base','zef.inv_n_burn_in');

[s_ind_1] = unique(evalin('base','zef.source_interpolation_ind{1}'));
s_ind_0 = s_ind_1;
n_interp = length(s_ind_1(:));

source_positions = evalin('base','zef.source_positions');
source_positions = source_positions(s_ind_1,:);
roi_mode = evalin('base','zef.inv_roi_mode');
roi_threshold = evalin('base','zef.inv_roi_threshold');
roi_sphere = evalin('base', 'zef.inv_roi_sphere');
rec_source = evalin('base', 'zef.inv_rec_source');
r_roi = roi_sphere(:,4);
c_roi = roi_sphere(:,1:3)';
beta = evalin('base','zef.inv_beta');
theta0 = evalin('base','zef.inv_theta0');
eta = beta - 1.5;
kappa = beta + 1.5;
std_lhood = evalin('base','zef.inv_likelihood_std');
sampling_freq = evalin('base','zef.inv_sampling_frequency');
high_pass = evalin('base','zef.inv_low_cut_frequency');
low_pass = evalin('base','zef.inv_high_cut_frequency');
number_of_frames = evalin('base','zef.number_of_frames');
time_step = evalin('base','zef.inv_time_3');
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

%if evalin('base','zef.use_gpu') == 1 & gpuDeviceCount > 0
%L = gpuArray(L);
%end
%L_aux = L;
%S_mat = std_lhood^2*eye(size(L,1));
%if evalin('base','zef.use_gpu') == 1 & gpuDeviceCount > 0
%S_mat = gpuArray(S_mat);
%end

if number_of_frames > 1
z = cell(number_of_frames,1);
else
number_of_frames = 1;
end

tic;
for f_ind = 1 : number_of_frames
time_val = toc;
if f_ind > 1;
date_str = datestr(datevec(now+(number_of_frames/(f_ind-1) - 1)*time_val/86400));
end;

if iscell(evalin('base','zef.measurements'));
f = evalin('base',['zef.measurements{' int2str(evalin('base','zef.inv_data_segment')) '}']);
else
f = evalin('base','zef.measurements');
end

data_norm = 1;
if evalin('base','zef.normalize_data')==1;
data_norm = max(abs(f(:)));
%std_lhood = std_lhood^2;
elseif evalin('base','zef.normalize_data')==2;
data_norm = max(sqrt(sum(abs(f).^2)));
%std_lhood = std_lhood^2;
elseif evalin('base','zef.normalize_data')==3;
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

if source_direction_mode == 1 || source_direction_mode == 2
z_aux = zeros(size(L,2),1);
end
if source_direction_mode == 3
z_aux = zeros(3*size(L,2),1);
end
z_vec = ones(size(L,2),1);
theta = theta0*ones(length(z_vec),1);
%aux_norm = (sum(L.^2))';
%aux_norm = aux_norm./max(aux_norm(:));
%theta = theta0*aux_norm;

if size(f,2) > 1
if evalin('base','zef.inv_time_2') >=0 0 && evalin('base','zef.inv_time_1') >= 0 & 1 + sampling_freq*evalin('base','zef.inv_time_1') <= size(f,2);
f = f(:, max(1, 1 + floor(sampling_freq*evalin('base','zef.inv_time_1')+sampling_freq*(f_ind - 1)*evalin('base','zef.inv_time_3'))) : min(size(f,2), 1 + floor(sampling_freq*(evalin('base','zef.inv_time_1') + evalin('base','zef.inv_time_2'))+sampling_freq*(f_ind - 1)*evalin('base','zef.inv_time_3'))));
end
end
if size(f,2) > 1
t = [1:size(f,2)];
%gaussian_window = blackmanharris(length(t))';
%f = f.*gaussian_window;
f = mean(f,2);
end
%if f_ind == 1
%waitbar(0,h,['IAS MAP iteration. Time step ' int2str(f_ind) ' of ' int2str(number_of_frames) '.']);
%end
%n_ias_map_iter = evalin('base','zef.inv_n_map_iterations');

%if evalin('base','zef.use_gpu') == 1 & gpuDeviceCount > 0
%f = gpuArray(f);
%end

gibbs_sampler;

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
