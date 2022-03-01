%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
function [z] = ramus_sampling_process(void)

h = waitbar(0,['RAMUS Sampler.']);
[s_ind_1] = unique(evalin('base','zef.source_interpolation_ind{1}'));
n_interp = length(s_ind_1);

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
n_decompositions = evalin('base','zef.inv_multires_n_decompositions');
n_multires = evalin('base','zef.inv_multires_n_levels');
sparsity_factor = evalin('base','zef.inv_multires_sparsity');
weight_vec_aux = sparsity_factor.^[0:n_multires-1]';
n_iterations =  evalin('base','zef.inv_n_sampler');
n_burn_in =  evalin('base','zef.inv_n_burn_in');

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
z_aux = zeros(size(L_aux,2),1);
end
if source_direction_mode == 3
z_aux = zeros(3*size(L_aux,2),1);
end
z_vec = ones(size(L_aux,2),1);
theta = theta0*ones(length(z_vec),1);

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
if f_ind == 1
waitbar(0,h,['RAMUS Sampler. Time step ' int2str(f_ind) ' of ' int2str(number_of_frames) '.']);
end
n_ias_map_iter = evalin('base','zef.inv_n_map_iterations');

if evalin('base','zef.use_gpu') == 1 & gpuDeviceCount > 0
f = gpuArray(f);
end

multires_dec =  evalin('base','zef.inv_multires_dec');
multires_ind =  evalin('base','zef.inv_multires_ind');
n_iter = evalin('base','zef.inv_multires_n_iter');
if length(n_iter) < n_multires
    n_iter = n_iter(1)*ones(1,n_multires);
end
mr_sparsity = evalin('base','zef.inv_multires_sparsity');

theta_vec_aux = zeros(size(L_aux,2),1);
z_vec_aux = zeros(size(L_aux,2),1);

exp_arg_old = -Inf;
z_vec_old = 0;
acceptance_counter = 0;
iter_counter = 0;

for iter_ind = 1 : n_iterations

n_rep = randperm(n_decompositions,1);

if evalin('base','zef.inv_init_guess_mode') == 2
theta = theta0*ones(size(L_aux,2),1);
end

if iter_ind == 1
j = 1;
else
j = randperm(n_multires,1);
end

n_mr_dec = length(multires_dec{n_rep}{j});

if source_direction_mode == 1 || source_direction_mode == 2
mr_dec = [multires_dec{n_rep}{j}; multires_dec{n_rep}{j}+n_interp ; multires_dec{n_rep}{j} + 2*n_interp];
mr_dec = mr_dec(:);
mr_ind = [multires_ind{n_rep}{j} ; multires_ind{n_rep}{j} + n_mr_dec ; multires_ind{n_rep}{j} + 2*n_mr_dec];
mr_ind = mr_ind(:);
end

if source_direction_mode == 3
mr_dec = multires_dec{n_rep}{j};
mr_dec = mr_dec(:);
mr_ind = multires_ind{n_rep}{j};
mr_ind = mr_ind(:);
end

if n_iter(j) > 0
L_aux_2 = L_aux(:,mr_dec);
theta = theta(mr_dec);
end

for i = 1 : n_iter(j)
if f_ind > 1;
waitbar(iter_ind/n_iterations,h,['Time step ' int2str(f_ind) ' of ' int2str(number_of_frames) '. Ready: ' date_str '.' ]);
else
waitbar(iter_ind/n_iterations,h,['RAMUS Sampler. Time step ' int2str(f_ind) ' of ' int2str(number_of_frames) '.' ]);
end;
d_sqrt = sqrt(theta);
if evalin('base','zef.use_gpu') == 1 & gpuDeviceCount > 0
d_sqrt = gpuArray(d_sqrt);
end
L = L_aux_2.*repmat(d_sqrt',size(L,1),1);
z_vec = d_sqrt.*(L'*((L*L' + S_mat)\f));

if evalin('base','zef.use_gpu') == 1 & gpuDeviceCount > 0
z_vec = gather(z_vec);
end
if evalin('base','zef.inv_hyperprior') == 1;
theta = theta0*(eta + sqrt((1/(2*theta0))*z_vec.^2 + eta^2));
else
theta = (theta0+0.5*z_vec.^2)./kappa;
end;

end;

theta = theta(mr_ind);
z_vec = z_vec(mr_ind);

resid_vec = f - L_aux*z_vec;
if evalin('base','zef.inv_hyperprior') == 1;
    exp_arg_new = - 0.5*resid_vec'*resid_vec/(std_lhood.^2) - 0.5*z_vec'*(z_vec./theta) - sum(theta./theta0) + (kappa-3)*sum(log(theta));
else
    exp_arg_new = - 0.5*resid_vec'*resid_vec/(std_lhood.^2) - 0.5*z_vec'*(z_vec./theta) - sum(theta0./theta) - kappa*sum(log(theta));
end
    iter_counter = iter_counter + 1;

if exp_arg_new - exp_arg_old >= log(rand(1))
    exp_arg_old = exp_arg_new;
    z_vec_current = z_vec;
acceptance_counter = acceptance_counter+1;
end

if iter_ind > n_burn_in
z_vec_aux = z_vec_aux + z_vec_current;
end

theta_vec_aux = theta_vec_aux + theta;
theta = theta_vec_aux/iter_ind;

end

%acceptance_counter/iter_counter
z_vec = z_vec_aux/(n_iterations-n_burn_in);

if source_direction_mode == 2
z_vec_aux = (z_vec(s_ind_4) + z_vec(n_interp+s_ind_4) + z_vec(2*n_interp+s_ind_4))/3;
z_vec(s_ind_4) = z_vec_aux.*source_directions(s_ind_4,1);
z_vec(n_interp+s_ind_4) = z_vec_aux.*source_directions(s_ind_4,2);
z_vec(2*n_interp+s_ind_4) = z_vec_aux.*source_directions(s_ind_4,3);
%z_vec = z_vec(:);
end

if source_direction_mode == 3
z_vec = [z_vec.*source_directions(:,1) ; z_vec.*source_directions(:,2) ;  z_vec.*source_directions(:,3)]';
%z_vec = z_vec(:);
end

if source_direction_mode == 1 || source_direction_mode == 2
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
