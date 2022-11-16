
function zef = zef_nse_iteration(zef)

[zef.nse_field.nodes, zef.nse_field.tetra] = zef_get_submesh(zef.nodes,zef.tetra,zef.active_compartment_ind);

signal_pulse.dir = zeros(size(zef.inv_synth_source,1),3);
node_ind_aux = [];

for i = 1 : size(zef.inv_synth_source,1)

    dir_vec = zef.inv_synth_source(i,4:6);
    dir_vec = dir_vec/norm(dir_vec,2);
    [~, node_ind] = min(sum((zef.inv_synth_source(i*ones(size(zef.nse_field.nodes,1),1),1:3) - zef.nse_field.nodes).^2,2));
    %node_ind = find(sqrt(sum((zef.nse_field.nodes(node_ind*ones(size(zef.nse_field.nodes,1),1),:) - zef.nse_field.nodes).^2,2))<zef.nse_field.artery_diameter/2);
    node_ind_aux = [node_ind_aux ; node_ind(:)];
    
    signal_pulse.dir(i,:) = dir_vec;
    signal_pulse.node_ind(i).data = node_ind;
    
end

hgmm_conversion = 101325/760;
zef.nse_field.nodes = zef.nse_field.nodes/1000;

zef.nse_field.rho = zef.nse_field.density.*ones(size(zef.nse_field.tetra,1),1);
zef.nse_field.mu = zef.nse_field.viscosity.*ones(size(zef.nse_field.tetra,1),1);

zef.nse_field.t_data = 0:zef.nse_field.time_step_length:zef.nse_field.time_length;

signal_pulse.data = hgmm_conversion.*zef_nse_signal_pulse(zef.nse_field.t_data,zef.nse_field,256);
zef.nse_field.signal_pulse = signal_pulse;

h_waitbar = zef_waitbar(0,'NSE iteration.');

p = zeros(size(zef.nse_field.nodes,1),1);
u_1 = zeros(size(zef.nse_field.nodes,1),1);
u_2 = zeros(size(zef.nse_field.nodes,1),1);
u_3 = zeros(size(zef.nse_field.nodes,1),1);

zef.nse_field.p_field = zeros(size(zef.nse_field.nodes,1),zef.nse_field.number_of_frames);
zef.nse_field.u_1_field = zeros(size(zef.nse_field.nodes,1),zef.nse_field.number_of_frames);
zef.nse_field.u_2_field = zeros(size(zef.nse_field.nodes,1),zef.nse_field.number_of_frames);
zef.nse_field.u_3_field = zeros(size(zef.nse_field.nodes,1),zef.nse_field.number_of_frames);

[M,L,Q_1,Q_2,Q_3,F] = zef_nse_matrices(zef.nse_field.nodes,zef.nse_field.tetra,zef.nse_field.rho,zef.nse_field.mu);

f_1_aux = zeros(size(u_1));
f_2_aux = zeros(size(u_2));
f_3_aux = zeros(size(u_3));

aux_vec_init_1 = zeros(size(u_1));
aux_vec_init_2 = zeros(size(u_2));
aux_vec_init_3 = zeros(size(u_3));

if zef.nse_field.use_gpu
    zef.nse_field.nodes = gpuArray(zef.nse_field.nodes);
    zef.nse_field.tetra = gpuArray(zef.nse_field.tetra);
    M = gpuArray(M);
    L = gpuArray(L);
    Q_1 = gpuArray(Q_1);
    Q_2 = gpuArray(Q_2);
    Q_3 = gpuArray(Q_3);
    F = gpuArray(F);
    p = gpuArray(p);
    u_1 = gpuArray(u_1);
    u_2 = gpuArray(u_2);
    u_3 = gpuArray(u_3);  
    f_1_aux = gpuArray(f_1_aux);
    f_2_aux = gpuArray(f_2_aux);
    f_3_aux = gpuArray(f_3_aux);  
    node_ind_aux = gpuArray(node_ind_aux);
    for i = 1 : size(zef.inv_synth_source,1)
      signal_pulse.node_ind(i).data = gpuArray(signal_pulse.node_ind(i).data);
    end
   
end

if zef.nse_field.use_gpu 
DM = gpuArray(1./full(sum(M,2)));  
else
DM = spdiags(full(sum(M,2)),0,size(zef.nse_field.nodes,1),size(zef.nse_field.nodes,1));
end

QinvMQ = @(x) zef_QinvMQ(x,Q_1,Q_2,Q_3,M,zef.nse_field.pcg_tol,zef.nse_field.pcg_maxit,DM,zef.nse_field.use_gpu); 

field_store_ind = floor((length(zef.nse_field.t_data)-1)/(zef.nse_field.number_of_frames-1));
field_store_counter = 0;

for t_ind = 1 : length(zef.nse_field.t_data)

zef_waitbar(t_ind/length(zef.nse_field.t_data),h_waitbar,'NSE iteration.');

for i = 1 : length(signal_pulse.node_ind)
f_1_aux(signal_pulse.node_ind(i).data) = signal_pulse.dir(i,1).*signal_pulse.data(t_ind);
f_2_aux(signal_pulse.node_ind(i).data) = signal_pulse.dir(i,2).*signal_pulse.data(t_ind);
f_3_aux(signal_pulse.node_ind(i).data) = signal_pulse.dir(i,3).*signal_pulse.data(t_ind);
end

f_1 = F*f_1_aux;
f_2 = F*f_2_aux;
f_3 = F*f_3_aux;

[Cuu_1, Cuu_2, Cuu_3] = zef_volume_scalar_uFG(zef.nse_field.nodes, zef.nse_field.tetra, 1, u_1, u_2, u_3, u_1);
[Aux_1, Aux_2, Aux_3] = zef_volume_scalar_uFG(zef.nse_field.nodes, zef.nse_field.tetra, 2, u_1, u_2, u_3, u_2);
Cuu_1 = Cuu_1 + Aux_1;
Cuu_2 = Cuu_2 + Aux_2;
Cuu_3 = Cuu_3 + Aux_3;

[Aux_1, Aux_2, Aux_3] = zef_volume_scalar_uFG(zef.nse_field.nodes, zef.nse_field.tetra, 3, u_1, u_2, u_3, u_3);
Cuu_1 = Cuu_1 + Aux_1;
Cuu_2 = Cuu_2 + Aux_2;
Cuu_3 = Cuu_3 + Aux_3;

aux_vec_1 =   Cuu_1 + L*u_1 - f_1;
if zef.nse_field.use_gpu
aux_vec_1 = pcg_iteration_gpu(M,aux_vec_1,zef.nse_field.pcg_tol,zef.nse_field.pcg_maxit,DM,aux_vec_1);
else
aux_vec_1 = pcg_iteration(M,aux_vec_1,zef.nse_field.pcg_tol,zef.nse_field.pcg_maxit,DM,aux_vec_1);
end
    
aux_vec_2  = Q_1*aux_vec_1;

aux_vec_1 =   Cuu_2 + L*u_2 - f_2;
if zef.nse_field.use_gpu 
aux_vec_1 = pcg_iteration_gpu(M,aux_vec_1,zef.nse_field.pcg_tol,zef.nse_field.pcg_maxit,DM,aux_vec_1);
else
aux_vec_1 = pcg_iteration(M,aux_vec_1,zef.nse_field.pcg_tol,zef.nse_field.pcg_maxit,DM,aux_vec_1);    
end
aux_vec_2  = aux_vec_2 + Q_2*aux_vec_1;

aux_vec_1 =   Cuu_3 + L*u_3 - f_3;
if zef.nse_field.use_gpu
aux_vec_1 = pcg_iteration_gpu(M,aux_vec_1,zef.nse_field.pcg_tol,zef.nse_field.pcg_maxit,DM,aux_vec_1);
else
aux_vec_1 = pcg_iteration(M,aux_vec_1,zef.nse_field.pcg_tol,zef.nse_field.pcg_maxit,DM,aux_vec_1);    
end
aux_vec_2  = aux_vec_2 + Q_3*aux_vec_1;

if zef.nse_field.use_gpu
p = pcg_iteration_gpu(QinvMQ,aux_vec_2,zef.nse_field.pcg_tol,zef.nse_field.pcg_maxit,[],p);
else
p = pcg_iteration(QinvMQ,aux_vec_2,zef.nse_field.pcg_tol,zef.nse_field.pcg_maxit,[],p);    
end

%p(node_ind_aux) = zeros(length(node_ind_aux),1);

aux_vec_1 =  f_1 - Cuu_1 - L*u_1 + Q_1*p;
if zef.nse_field.use_gpu 
[aux_vec_init_1] = pcg_iteration_gpu(M,aux_vec_1,zef.nse_field.pcg_tol,zef.nse_field.pcg_maxit,DM,aux_vec_init_1);
else
[aux_vec_init_1] = pcg_iteration(M,aux_vec_1,zef.nse_field.pcg_tol,zef.nse_field.pcg_maxit,DM,aux_vec_init_1);    
end

aux_vec_2 =  f_2 - Cuu_2 - L*u_2 + Q_2*p;
if zef.nse_field.use_gpu 
[aux_vec_init_2] = pcg_iteration_gpu(M,aux_vec_2,zef.nse_field.pcg_tol,zef.nse_field.pcg_maxit,DM,aux_vec_init_2);
else
[aux_vec_init_2] = pcg_iteration(M,aux_vec_2,zef.nse_field.pcg_tol,zef.nse_field.pcg_maxit,DM,aux_vec_init_2);    
end

aux_vec_3 =  f_3 - Cuu_3 - L*u_3 + Q_3*p;
if zef.nse_field.use_gpu 
[aux_vec_init_3] = pcg_iteration_gpu(M,aux_vec_3,zef.nse_field.pcg_tol,zef.nse_field.pcg_maxit,DM,aux_vec_init_3);
else
[aux_vec_init_3] = pcg_iteration(M,aux_vec_3,zef.nse_field.pcg_tol,zef.nse_field.pcg_maxit,DM,aux_vec_init_3);    
end

u_1 = u_1 + zef.nse_field.time_step_length*aux_vec_init_1;
u_2 = u_2 + zef.nse_field.time_step_length*aux_vec_init_2;
u_3 = u_3 + zef.nse_field.time_step_length*aux_vec_init_3;

if and(mod(t_ind-1,field_store_ind)==0, field_store_counter < zef.nse_field.number_of_frames)
field_store_counter = field_store_counter + 1;
zef.nse_field.u_1_field(:,field_store_counter) = gather(u_1);
zef.nse_field.u_2_field(:,field_store_counter) = gather(u_2);
zef.nse_field.u_3_field(:,field_store_counter) = gather(u_3);
zef.nse_field.p_field(:,field_store_counter) = gather(p);
    zef.nse_field.nodes = gather(zef.nse_field.nodes);
    zef.nse_field.tetra = gather(zef.nse_field.tetra);
end

end

close(h_waitbar);

end

