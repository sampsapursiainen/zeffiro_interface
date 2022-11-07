%Copyright © 2021- Sampsa Pursiainen & GPU-ToRRe-3D Development Team
%See: https://github.com/sampsapursiainen/GPU-Torre-3D


load([torre_dir '/system_data/signal_configuration.mat']);
load([torre_dir '/system_data/mesh_1.mat']);
load([torre_dir '/system_data/system_data_1.mat']);
load([torre_dir '/system_data/nodes_1.dat']);
load([torre_dir '/system_data/tetrahedra_1.dat']);

system_setting_index = 1;
parameters;

tic

data_name = 'data_1';

parpool(num_workers);

ast_ind_coarse = unique(interp_vec(ast_ind));
tet_ast = tetrahedra_1(ast_ind_coarse,6:9);

Aux_mat = [nodes_1(tet_ast(:,1),2:4)'; nodes_1(tet_ast(:,2),2:4)'; nodes_1(tet_ast(:,3),2:4)'] - repmat(nodes_1(tet_ast(:,4),2:4)',3,1);
ind_m = [1 4 7; 2 5 8 ; 3 6 9];
tilavuus = abs(Aux_mat(ind_m(1,1),:).*(Aux_mat(ind_m(2,2),:).*Aux_mat(ind_m(3,3),:)-Aux_mat(ind_m(2,3),:).*Aux_mat(ind_m(3,2),:)) ...
                - Aux_mat(ind_m(1,2),:).*(Aux_mat(ind_m(2,1),:).*Aux_mat(ind_m(3,3),:)-Aux_mat(ind_m(2,3),:).*Aux_mat(ind_m(3,1),:)) ...
                + Aux_mat(ind_m(1,3),:).*(Aux_mat(ind_m(2,1),:).*Aux_mat(ind_m(3,2),:)-Aux_mat(ind_m(2,2),:).*Aux_mat(ind_m(3,1),:)))/6;

j_aux_ind = zeros(size(tetrahedra_1,1),1);
j_aux_ind(j_ind_ast) = [1:length(j_ind_ast)]';
tet_ast = j_aux_ind(tet_ast);

system_setting_index = 1;
parameters;

t_data = t_vec(1:data_param:end);
ind_data_0 = find(t_data >= t_data_0,1);
ind_data_1 = find(t_data >= t_data_1,1);
if isempty(ind_data_1)
ind_data_1 = length(t_data);
end
t_data = t_data(1:ind_data_1);
n_t_data = length(t_data); 
t_data_resample = t_data(ind_data_0:data_resample_val:ind_data_1);
n_jacobian = length(t_data_resample);

bh_pulse = bh_window(t_data, pulse_length, 0, 'complex');
bh_pulse = bh_pulse(ones(4,1),:);

data_ind_aux = 0;

ast_ind_aux = unique(interp_vec(ast_ind));
n_ast = length(ast_ind_aux);
ast_ind_coarse = zeros(max(interp_vec), 1);
ast_ind_coarse(ast_ind_aux) = [1 : length(ast_ind_aux)];

fft_aux = fft([zeros(size(bh_pulse)) bh_pulse zeros(size(bh_pulse))],[],2);

parfor  j = 1 : size(path_data,1)

for k = 1 : size(path_data,2)-1

aux_mat_cos = zeros(1, n_jacobian, n_ast);
aux_mat_sin = zeros(1, n_jacobian, n_ast);

[u_data_mat, f_data_mat] = load_jacobian_data_complex(path_data(j,[1 k+1]), data_name, torre_dir);
u_data_mat = u_data_mat(:, 1:ind_data_1);
f_data_mat = f_data_mat(:, 1:ind_data_1);

for i = 1 : size(tet_ast,1)
    
D_mat = tilavuus(i)*[2 1 1 1; 1 2 1 1; 1 1 2 1; 1 1 1 2]/20;
    
    aux_data_1 = [u_data_mat(tet_ast(i,1),:);  u_data_mat(tet_ast(i,2),:); u_data_mat(tet_ast(i,3),:); u_data_mat(tet_ast(i,4),:)];
    aux_data_1 = [zeros(size(aux_data_1)) aux_data_1 zeros(size(aux_data_1))];
    deconv_vec_cos  =  fft(real(aux_data_1),[],2)./(fft_aux + deconv_reg_param);
    deconv_vec_sin  =  fft(imag(aux_data_1),[],2)./(fft_aux + deconv_reg_param);

    aux_data_2 = [f_data_mat(tet_ast(i,1),:) ; f_data_mat(tet_ast(i,2),:) ; f_data_mat(tet_ast(i,3),:); f_data_mat(tet_ast(i,4),:)];   
    aux_data_2 = [zeros(size(aux_data_2)) aux_data_2 zeros(size(aux_data_2))];
    aux_data_2 = D_mat*aux_data_2;          
        
    aux_fft_cos = fft(real(aux_data_2),[],2);
    aux_fft_sin = fft(imag(aux_data_2),[],2);
    aux_vec_cos = real(ifft(deconv_vec_cos.*aux_fft_cos,[],2));
    aux_vec_sin = real(ifft(deconv_vec_sin.*aux_fft_sin,[],2));
    aux_data_cos = sum(aux_vec_cos(:,n_t_data + 1 : 2*n_t_data),1);
    aux_data_sin = sum(aux_vec_sin(:,n_t_data + 1 : 2*n_t_data),1);
    aux_data_cos = aux_data_cos(ind_data_0:data_resample_val:ind_data_1);
    aux_data_sin = aux_data_sin(ind_data_0:data_resample_val:ind_data_1);
    %aux_data = aux_data(ind_data_0:ind_data_1);
    aux_mat_cos(1, :, ast_ind_coarse(interp_vec(ast_ind(i)))) = aux_mat_cos(1, :, ast_ind_coarse(interp_vec(ast_ind(i)))) + aux_data_cos;
    aux_mat_sin(1, :, ast_ind_coarse(interp_vec(ast_ind(i)))) = aux_mat_sin(1, :, ast_ind_coarse(interp_vec(ast_ind(i)))) + aux_data_sin;  
  end

save_jacobian_data_complex(aux_mat_cos, aux_mat_sin, [j k], torre_dir);

end
  end

delete(gcp('nocreate'));

J_mat = zeros(2*size(path_data,1)*(size(path_data,2)-1), n_jacobian, n_ast);

for  j = 1 :  size(path_data,1)
for k = 1 : size(path_data,2)-1
load([torre_dir '/system_data/aux_mat_' int2str(j) '_' int2str(k) '.mat'],'aux_mat_cos','aux_mat_sin');
delete([torre_dir '/system_data/aux_mat_' int2str(j) '_' int2str(k) '.mat']);
J_mat(2*size(path_data,1)*(k-1) + 2*j-1, :, :) = aux_mat_cos(1, :, :);
J_mat(2*size(path_data,1)*(k-1) + 2*j, :, :) = aux_mat_sin(1, :, :);
end 
end

jacobian_ind = ast_ind_coarse;
t_data_jacobian = t_data_resample;

save([torre_dir '/system_data/born_approximation_qam.mat'], 'J_mat', 'jacobian_ind', 'path_data', 't_data_jacobian', '-v7.3');

toc







