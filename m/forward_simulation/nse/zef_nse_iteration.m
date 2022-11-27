
function zef = zef_nse_iteration(zef)

[zef.nse_field.nodes, zef.nse_field.tetra] = zef_get_submesh(zef.nodes,zef.tetra,zef.active_compartment_ind);
b_node_ind = zef_surface_mesh(zef.nse_field.tetra);
b_node_ind = unique(b_node_ind);

signal_pulse.dir = zeros(size(zef.inv_synth_source,1),3);

flux_val = 7.5e-4/60;
flux_vec = [0.5 0.5 -1/3 -1/3 -1/3]*flux_val;
n_smoothing = 0;
atmosphere_pressure = 1.01325e5;

zef.nse_field.nodes = zef.nse_field.nodes/1000;

zef.nse_field.artery_diameter = 0.005;

div_vec = zeros(size(zef.nse_field.nodes,1),1);

for i = 1 : size(zef.inv_synth_source,1)

    dir_vec = zef.inv_synth_source(i,4:6);
    dir_vec = dir_vec/norm(dir_vec,2);
    [~, node_ind] = min(sum((zef.inv_synth_source(i*ones(size(b_node_ind,1),1),1:3)/1000 - zef.nse_field.nodes(b_node_ind,:)).^2,2));
    node_ind = b_node_ind(node_ind);
    %node_ind = find(sqrt(sum((zef.nse_field.nodes(node_ind*ones(size(zef.nse_field.nodes,1),1),:) - zef.nse_field.nodes).^2,2))<zef.nse_field.artery_diameter/2);
    signal_pulse.dir(i,:) = dir_vec;
    signal_pulse.node_ind(i).data = node_ind;
    div_vec(node_ind) = flux_vec(i);
    b_node_ind = setdiff(b_node_ind,node_ind);
   
end

i_node_ind = [1:size(zef.nse_field.nodes,1)]';
i_node_ind = setdiff(i_node_ind,b_node_ind);
div_vec = div_vec(i_node_ind);

hgmm_conversion = 101325/760;

zef.nse_field.rho = zef.nse_field.density.*ones(size(zef.nse_field.tetra,1),1);
zef.nse_field.mu = zef.nse_field.viscosity.*ones(size(zef.nse_field.tetra,1),1);

zef.nse_field.t_data = 0:zef.nse_field.time_step_length:zef.nse_field.time_length;
signal_pulse.data = atmosphere_pressure + hgmm_conversion.*zef_nse_signal_pulse(zef.nse_field.t_data,zef.nse_field,256);
zef.nse_field.signal_pulse = signal_pulse;
div_data = ones(size(zef.nse_field.t_data));

h_waitbar = zef_waitbar(0,'NSE iteration.');

nse_mat = zef_nse_matrices(zef.nse_field.nodes,zef.nse_field.tetra,zef.nse_field.rho,zef.nse_field.mu);

nse_mat.M = nse_mat.M(i_node_ind,i_node_ind);
nse_mat.L_11 = nse_mat.L_11(i_node_ind,i_node_ind);
nse_mat.L_22 = nse_mat.L_22(i_node_ind,i_node_ind);
nse_mat.L_33 = nse_mat.L_33(i_node_ind,i_node_ind);
nse_mat.L_12 = nse_mat.L_12(i_node_ind,i_node_ind);
nse_mat.L_13 = nse_mat.L_13(i_node_ind,i_node_ind);
nse_mat.L_23 = nse_mat.L_23(i_node_ind,i_node_ind);
nse_mat.Q_1 = nse_mat.Q_1(i_node_ind,i_node_ind);
nse_mat.Q_2 = nse_mat.Q_2(i_node_ind,i_node_ind);
nse_mat.Q_3 = nse_mat.Q_3(i_node_ind,i_node_ind);
nse_mat.B1_1 = nse_mat.B1_1(i_node_ind,i_node_ind);
nse_mat.B1_2 = nse_mat.B1_2(i_node_ind,i_node_ind);
nse_mat.B1_3 = nse_mat.B1_3(i_node_ind,i_node_ind);
nse_mat.B2 = nse_mat.B2(i_node_ind,i_node_ind);
nse_mat.B3_11 = nse_mat.B3_11(i_node_ind,i_node_ind);
nse_mat.B3_21 = nse_mat.B3_21(i_node_ind,i_node_ind);
nse_mat.B3_31 = nse_mat.B3_31(i_node_ind,i_node_ind);
nse_mat.B3_12 = nse_mat.B3_12(i_node_ind,i_node_ind);
nse_mat.B3_22 = nse_mat.B3_22(i_node_ind,i_node_ind);
nse_mat.B3_32 = nse_mat.B3_32(i_node_ind,i_node_ind);
nse_mat.B3_13 = nse_mat.B3_13(i_node_ind,i_node_ind);
nse_mat.B3_23 = nse_mat.B3_23(i_node_ind,i_node_ind);
nse_mat.B3_33 = nse_mat.B3_33(i_node_ind,i_node_ind);
nse_mat.F = nse_mat.F(i_node_ind,i_node_ind);
nse_mat.N = nse_mat.N(i_node_ind,i_node_ind);

p = zeros(size(nse_mat.M,1),1);
u_1 = zeros(size(nse_mat.M,1),1);
u_2 = zeros(size(nse_mat.M,1),1);
u_3 = zeros(size(nse_mat.M,1),1);

zef.nse_field.p_field = zeros(size(nse_mat.M,1),zef.nse_field.number_of_frames);
zef.nse_field.u_1_field = zeros(size(nse_mat.M,1),zef.nse_field.number_of_frames);
zef.nse_field.u_2_field = zeros(size(nse_mat.M,1),zef.nse_field.number_of_frames);
zef.nse_field.u_3_field = zeros(size(nse_mat.M,1),zef.nse_field.number_of_frames);

f_1_aux = zeros(size(u_1));
f_2_aux = zeros(size(u_2));
f_3_aux = zeros(size(u_3));

%f_3_aux = f_3_aux - 9.81*ones(size(f_3_aux));

aux_vec_init_1 = zeros(size(u_1));
aux_vec_init_2 = zeros(size(u_2));
aux_vec_init_3 = zeros(size(u_3));

[~, ~, ~, b_coord, volume] = zef_volume_scalar_uFG(zef.nse_field.nodes, zef.nse_field.tetra, 1, u_1, u_2, u_3, u_1, zef.nse_field.rho, i_node_ind);

if zef.nse_field.use_gpu
    
    zef.nse_field.nodes = gpuArray(zef.nse_field.nodes);
    zef.nse_field.tetra = gpuArray(zef.nse_field.tetra);
      zef.nse_field.rho = gpuArray(zef.nse_field.rho);
      zef.nse_field.mu = gpuArray(zef.nse_field.mu);
    nse_mat.M = gpuArray(nse_mat.M);
    nse_mat.L_11 = gpuArray(nse_mat.L_11);
    nse_mat.L_22 = gpuArray(nse_mat.L_22);
    nse_mat.L_33 = gpuArray(nse_mat.L_33);
    nse_mat.L_12 = gpuArray(nse_mat.L_12);
    nse_mat.L_13 = gpuArray(nse_mat.L_13);
    nse_mat.L_23 = gpuArray(nse_mat.L_23);
    nse_mat.Q_1 = gpuArray(nse_mat.Q_1);
    nse_mat.Q_2 = gpuArray(nse_mat.Q_2);
    nse_mat.Q_3 = gpuArray(nse_mat.Q_3);
nse_mat.B1_1 = gpuArray(nse_mat.B1_1);
nse_mat.B1_2 = gpuArray(nse_mat.B1_2);
nse_mat.B1_3 = gpuArray(nse_mat.B1_3);
nse_mat.B2 = gpuArray(nse_mat.B2);
nse_mat.B3_11 = gpuArray(nse_mat.B3_11);
nse_mat.B3_21 = gpuArray(nse_mat.B3_21);
nse_mat.B3_31 = gpuArray(nse_mat.B3_31);
nse_mat.B3_12 = gpuArray(nse_mat.B3_12);
nse_mat.B3_22 = gpuArray(nse_mat.B3_22);
nse_mat.B3_32 = gpuArray(nse_mat.B3_32);
nse_mat.B3_13 = gpuArray(nse_mat.B3_13);
nse_mat.B3_23 = gpuArray(nse_mat.B3_23);
nse_mat.B3_33 = gpuArray(nse_mat.B3_33);
    nse_mat.F = gpuArray(nse_mat.F);
    nse_mat.N = gpuArray(nse_mat.N);
    p = gpuArray(p);
    u_1 = gpuArray(u_1);
    u_2 = gpuArray(u_2);
    u_3 = gpuArray(u_3);  
    f_1_aux = gpuArray(f_1_aux);
    f_2_aux = gpuArray(f_2_aux);
    f_3_aux = gpuArray(f_3_aux);  
    b_coord = gpuArray(b_coord);
    volume = gpuArray(volume);  
    for i = 1 : size(zef.inv_synth_source,1)
    signal_pulse.node_ind(i).data = gpuArray(signal_pulse.node_ind(i).data);
    end
   
end

if zef.nse_field.use_gpu 
nse_mat.DM = gpuArray(1./full(sum(nse_mat.M,2)));  
else
nse_mat.DM = spdiags(full(sum(nse_mat.M,2)),0,size(nse_mat.M,1),size(nse_mat.M,1));
end

QinvMQ = @(x) zef_QinvMQ(x,nse_mat.Q_1,nse_mat.Q_2,nse_mat.Q_3,nse_mat.M,zef.nse_field.pcg_tol,zef.nse_field.pcg_maxit,nse_mat.DM,zef.nse_field.use_gpu); 

field_store_ind = floor((length(zef.nse_field.t_data)-1)/(zef.nse_field.number_of_frames-1));
field_store_counter = 0;

for t_ind = 1 : length(zef.nse_field.t_data)

zef_waitbar(t_ind/length(zef.nse_field.t_data),h_waitbar,'NSE iteration.');

f_1 = nse_mat.F*f_1_aux;
f_2 = nse_mat.F*f_2_aux;
f_3 = nse_mat.F*f_3_aux;

[Cuu_1, Cuu_2, Cuu_3] = zef_volume_scalar_uFG(zef.nse_field.nodes, zef.nse_field.tetra, 1, u_1, u_2, u_3, u_1, zef.nse_field.rho, i_node_ind, b_coord, volume);
[Aux_1, Aux_2, Aux_3] = zef_volume_scalar_uFG(zef.nse_field.nodes, zef.nse_field.tetra, 2, u_1, u_2, u_3, u_2, zef.nse_field.rho, i_node_ind, b_coord, volume);
Cuu_1 = Cuu_1 + Aux_1;
Cuu_2 = Cuu_2 + Aux_2;
Cuu_3 = Cuu_3 + Aux_3;

[Aux_1, Aux_2, Aux_3] = zef_volume_scalar_uFG(zef.nse_field.nodes, zef.nse_field.tetra, 3, u_1, u_2, u_3, u_3, zef.nse_field.rho, i_node_ind, b_coord, volume);
Cuu_1 = Cuu_1 + Aux_1;
Cuu_2 = Cuu_2 + Aux_2;
Cuu_3 = Cuu_3 + Aux_3;

b_1_vec_1 = - nse_mat.B1_1*p;
b_2_vec_1 = nse_mat.B2*u_1;
b_3_vec_1 = nse_mat.B3_11*u_1 +  nse_mat.B3_12*u_2 +  nse_mat.B3_13*u_3;

l_1_vec = 2*nse_mat.L_11*u_1 + nse_mat.L_22*u_1 + nse_mat.L_33*u_1 + nse_mat.L_12*u_2 + nse_mat.L_13*u_3;
aux_vec_1 = Cuu_1 + l_1_vec  - b_1_vec_1 - b_2_vec_1 - b_3_vec_1 - f_1;
if zef.nse_field.use_gpu
aux_vec_1 = pcg_iteration_gpu(nse_mat.M,aux_vec_1,zef.nse_field.pcg_tol,zef.nse_field.pcg_maxit,nse_mat.DM,aux_vec_1);
else
aux_vec_1 = pcg_iteration(nse_mat.M,aux_vec_1,zef.nse_field.pcg_tol,zef.nse_field.pcg_maxit,nse_mat.DM,aux_vec_1);
end
    
aux_vec_2  = nse_mat.Q_1*aux_vec_1;

b_1_vec_2 = - nse_mat.B1_2*p; 
b_2_vec_2 = nse_mat.B2*u_2;
b_3_vec_2 = nse_mat.B3_21*u_1 +  nse_mat.B3_22*u_2 +  nse_mat.B3_23*u_3;

l_2_vec = nse_mat.L_11*u_2 + 2*nse_mat.L_22*u_2 + nse_mat.L_33*u_2 + nse_mat.L_12*u_1 + nse_mat.L_23*u_3;
aux_vec_1 =   Cuu_2 + l_2_vec - b_1_vec_2 - b_2_vec_2 - b_3_vec_2 - f_2;
if zef.nse_field.use_gpu 
aux_vec_1 = pcg_iteration_gpu(nse_mat.M,aux_vec_1,zef.nse_field.pcg_tol,zef.nse_field.pcg_maxit,nse_mat.DM,aux_vec_1);
else
aux_vec_1 = pcg_iteration(nse_mat.M,aux_vec_1,zef.nse_field.pcg_tol,zef.nse_field.pcg_maxit,nse_mat.DM,aux_vec_1);    
end
aux_vec_2  = aux_vec_2 + nse_mat.Q_2*aux_vec_1;

b_1_vec_3 = - nse_mat.B1_3*p; 
b_2_vec_3 = nse_mat.B2*u_3;
b_3_vec_3 = nse_mat.B3_31*u_1 +  nse_mat.B3_32*u_2 +  nse_mat.B3_33*u_3;

l_3_vec = nse_mat.L_11*u_3 + nse_mat.L_22*u_3 + 2*nse_mat.L_33*u_3 + nse_mat.L_23*u_2 + nse_mat.L_13*u_1;
aux_vec_1 = Cuu_3 + l_3_vec - b_1_vec_3 - b_2_vec_3 - b_3_vec_3 - f_3;
if zef.nse_field.use_gpu
aux_vec_1 = pcg_iteration_gpu(nse_mat.M,aux_vec_1,zef.nse_field.pcg_tol,zef.nse_field.pcg_maxit,nse_mat.DM,aux_vec_1);
else
aux_vec_1 = pcg_iteration(nse_mat.M,aux_vec_1,zef.nse_field.pcg_tol,zef.nse_field.pcg_maxit,nse_mat.DM,aux_vec_1);    
end
aux_vec_2  = aux_vec_2 + nse_mat.Q_3*aux_vec_1;

aux_vec_2 = aux_vec_2 - div_vec*div_data(t_ind);

if zef.nse_field.use_gpu
p = pcg_iteration_gpu(QinvMQ,aux_vec_2,zef.nse_field.pcg_tol,zef.nse_field.pcg_maxit,[],p);
else
p = pcg_iteration(QinvMQ,aux_vec_2,zef.nse_field.pcg_tol,zef.nse_field.pcg_maxit,[],p);    
end

%for j = 1 : n_smoothing
   
%    p = nse_mat.N*p;
    
%end

%scaling_factor = signal_pulse.data(t_ind)/p(signal_pulse.node_ind(1).data(1));
%p = scaling_factor*p;
%u_1 = scaling_factor*u_1;
%u_2 = scaling_factor*u_2;
%u_3 = scaling_factor*u_3;

b_1_vec_1 = - nse_mat.B1_1*p; 

aux_vec_1 =  b_1_vec_1 + b_2_vec_1 + b_3_vec_1 + f_1 - Cuu_1 - l_1_vec + nse_mat.Q_1*p;
if zef.nse_field.use_gpu 
[aux_vec_init_1] = pcg_iteration_gpu(nse_mat.M,aux_vec_1,zef.nse_field.pcg_tol,zef.nse_field.pcg_maxit,nse_mat.DM,aux_vec_init_1);
else
[aux_vec_init_1] = pcg_iteration(nse_mat.M,aux_vec_1,zef.nse_field.pcg_tol,zef.nse_field.pcg_maxit,nse_mat.DM,aux_vec_init_1);    
end

b_1_vec_2 = - nse_mat.B1_2*p; 

aux_vec_2 =  b_1_vec_2 + b_2_vec_2 + b_3_vec_2 + f_2 - Cuu_2 - l_2_vec + nse_mat.Q_2*p;
if zef.nse_field.use_gpu 
[aux_vec_init_2] = pcg_iteration_gpu(nse_mat.M,aux_vec_2,zef.nse_field.pcg_tol,zef.nse_field.pcg_maxit,nse_mat.DM,aux_vec_init_2);
else
[aux_vec_init_2] = pcg_iteration(nse_mat.M,aux_vec_2,zef.nse_field.pcg_tol,zef.nse_field.pcg_maxit,nse_mat.DM,aux_vec_init_2);    
end

b_1_vec_3 = - nse_mat.B1_3*p; 

aux_vec_3 =  b_1_vec_3 + b_2_vec_3 + b_3_vec_3 + f_3 - Cuu_3 - l_3_vec + nse_mat.Q_3*p;
if zef.nse_field.use_gpu 
[aux_vec_init_3] = pcg_iteration_gpu(nse_mat.M,aux_vec_3,zef.nse_field.pcg_tol,zef.nse_field.pcg_maxit,nse_mat.DM,aux_vec_init_3);
else
[aux_vec_init_3] = pcg_iteration(nse_mat.M,aux_vec_3,zef.nse_field.pcg_tol,zef.nse_field.pcg_maxit,nse_mat.DM,aux_vec_init_3);    
end

u_1 = u_1 + zef.nse_field.time_step_length*aux_vec_init_1;
u_2 = u_2 + zef.nse_field.time_step_length*aux_vec_init_2;
u_3 = u_3 + zef.nse_field.time_step_length*aux_vec_init_3;

% for j = 1 : n_smoothing
%    
%     u_1 = nse_mat.N*u_1;
%     u_2 = nse_mat.N*u_2;
%     u_3 = nse_mat.N*u_3;
%     
% end

if and(mod(t_ind-1,field_store_ind)==0, field_store_counter < zef.nse_field.number_of_frames)
field_store_counter = field_store_counter + 1;
zef.nse_field.u_1_field(:,field_store_counter) = gather(u_1);
zef.nse_field.u_2_field(:,field_store_counter) = gather(u_2);
zef.nse_field.u_3_field(:,field_store_counter) = gather(u_3);
zef.nse_field.p_field(:,field_store_counter) = gather(p);
zef.nse_field.nodes = gather(zef.nse_field.nodes);
zef.nse_field.tetra = gather(zef.nse_field.tetra);
end

zef.nse_field.i_node_ind = i_node_ind; 
zef.nse_field.b_node_ind = b_node_ind; 

end

close(h_waitbar);

end

