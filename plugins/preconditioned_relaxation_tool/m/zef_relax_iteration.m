%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
function [z,reconstruction_information] = zef_relax_iteration(void)

h = waitbar(0,['Relaxation iteration.']);
n_multires = evalin('base','zef.relax_multires_n_levels');
sparsity_factor = evalin('base','zef.relax_multires_sparsity');
snr_val = evalin('base','zef.relax_snr');
relax_db = evalin('base','zef.relax_db');
n_iter = evalin('base','zef.relax_multires_n_iter');
relax_tolerance = evalin('base','zef.relax_tolerance');
sampling_freq = evalin('base','zef.relax_sampling_frequency');
high_pass = evalin('base','zef.relax_low_cut_frequency');
low_pass = evalin('base','zef.relax_high_cut_frequency');
number_of_frames = evalin('base','zef.relax_number_of_frames');
time_step = evalin('base','zef.relax_time_3');
source_direction_mode = evalin('base','zef.source_direction_mode');
source_directions = evalin('base','zef.source_directions');
n_decompositions = evalin('base','zef.relax_multires_n_decompositions');
M = evalin('base','zef.relax_preconditioner');
perm_vec = evalin('base','zef.relax_preconditioner_permutation');
gamma = 10^(-relax_db/20);
tol_val = 10^(-(snr_val - relax_tolerance)/20);

reconstruction_information.tag = 'Relaxation';
reconstruction_information.inv_time_1 = evalin('base','zef.relax_time_1');
reconstruction_information.inv_time_2 = evalin('base','zef.relax_time_2');
reconstruction_information.inv_time_3 = evalin('base','zef.relax_time_3');
reconstruction_information.sampling_freq = evalin('base','zef.relax_sampling_frequency');
reconstruction_information.low_pass = evalin('base','zef.relax_high_cut_frequency');
reconstruction_information.high_pass = evalin('base','zef.relax_low_cut_frequency');
reconstruction_information.number_of_frames = evalin('base','zef.relax_number_of_frames');
reconstruction_information.source_direction_mode = evalin('base','zef.source_direction_mode');
reconstruction_information.source_directions = evalin('base','zef.source_directions');
reconstruction_information.snr_val = evalin('base','zef.relax_snr');

[L, n_interp, procFile] = zef_processLeadfields(source_direction_mode);

[f_data] = zef_getFilteredData;

tic;

z_inverse = cell(0);

tic;
for f_ind = 1 : number_of_frames

time_val = toc;
if f_ind > 1;
date_str = datestr(datevec(now+(number_of_frames/(f_ind-1) - 1)*time_val/86400));
end;

z_vec = ones(size(L, 2),1);

[f] = zef_getTimeStep(f_data, f_ind, true);

if f_ind == 1
waitbar(0,h,['Iterative relaxation. Time step ' int2str(f_ind) ' of ' int2str(number_of_frames) '.']);
end

L_aux = L;
z_vec_aux = zeros(size(L,2),1);

for n_rep = 1 : length(M)

L = L_aux(:,perm_vec{n_rep}{1});

if isequal(evalin('base','zef.relax_iteration_type'),1)

L_aux_2 = M{n_rep}\L';
norm_f = norm(L'*f);
z_vec = gamma*L_aux_2*f;

elseif isequal(evalin('base','zef.relax_iteration_type'),2)

b = L'*f;
z_vec = zeros(size(L,2),1);
norm_b = norm(b);
r = b;
p = r;

end

for i = 1 : n_iter
if f_ind > 1;
waitbar((n_rep*(n_iter-1)+1)/(length(M)*n_iter),h,['Dec. ' int2str(n_rep) ' of ' int2str(length(M)) ', Step ' int2str(f_ind) ' of ' int2str(number_of_frames) '. Ready: ' date_str '.' ]);
else
waitbar((n_rep*(n_iter-1)+1)/(length(M)*n_iter),h,['Iterative relaxation. Dec. ' int2str(n_rep) ' of ' int2str(length(M)) ', Time step ' int2str(f_ind) ' of ' int2str(number_of_frames) '.' ]);
end;

if isequal(evalin('base','zef.relax_iteration_type'),1)

z_vec = z_vec + gamma*L_aux_2*(f - L*z_vec);
relres_vec = norm(L'*(L*z_vec - f))/norm_f;

elseif isequal(evalin('base','zef.relax_iteration_type'),2)
  a = L * p;
  a = L' * a;
  a_dot_p = sum(a.*p);
  aux_val = sum(r.*p);
  lambda = aux_val ./ a_dot_p;
  z_vec = z_vec + lambda * p;
  r = r - lambda * a;
  inv_M_r = M{n_rep}\r;
  aux_val = sum(inv_M_r.*a);
  gamma = aux_val ./ a_dot_p;
  p = inv_M_r - gamma * p;

relres_vec = gather(norm(r)/norm_b);

end

if relres_vec < tol_val
break;
end

end

if tol_val < relres_vec
    'Error: iteration did not converge.'
end

z_vec = z_vec(perm_vec{n_rep}{2});
z_vec_aux = z_vec_aux + z_vec;

end

z_vec = z_vec_aux/n_decompositions;

z_inverse{f_ind} = z_vec;

[z] = zef_postProcessInverse(z_inverse, procFile);
[z] = zef_normalizeInverseReconstruction(z);

end

close(h);

end

