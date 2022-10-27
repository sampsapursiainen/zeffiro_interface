%Copyright © 2021- Sampsa Pursiainen & GPU-ToRRe-3D Development Team
%See: https://github.com/sampsapursiainen/GPU-Torre-3D


parameters;
t_0 = 0;
current_iterate = 0;

if make_video == 1
time_lapse = VideoWriter('wave_1.avi');
time_lapse.FrameRate = 24;
open(time_lapse);
end

n_nodes = size(C,1);
n_tetrahedra = size(A,1);

ones_aux_vec = ones(length(ast_ind),1);

M = gpuArray((1./full(sum(C,2))));
C = gpuArray(C);
R = gpuArray(R);
A = (single(1./full(diag(A))));
div_vec = single(zeros(size(A,1),1));

n_array = gpuArray(single(nodes));
t_array = gpuArray(uint32(tetrahedra(:,1:4)));

if near_field == 1 
[boundary_vec_1, boundary_vec_2] = boundary_point_source(source_points, orbit_triangles, orbit_nodes);
else
[boundary_vec_1, boundary_vec_2, s_orbit] = boundary_source(fade_out_param, source_points, orbit_triangles, orbit_nodes);
end
a_o = source_orientations;

t_data = zeros(1,ceil(length(t_vec)/data_param));

n_path_data = size(path_data,1);

process_id_counter = 0;
h_waitbar = waitbar(0, 'Leap-frog iteration.');

for k = process_id
    
    process_id_counter = process_id_counter + 1;
    waitbar(0, h_waitbar, ['Process ' int2str(process_id_counter) ' of ' int2str(length(process_id)) '.']);

a_o(k,find(a_o(k,:)==0))= eps;
    
    du_dt_vec = zeros(size(orbit_ind,1),3);

    u_data = (zeros(size(orbit_ind,1),ceil(length(t_vec)/data_param)));
    du_dt_data = (zeros(size(orbit_ind,1),ceil(length(t_vec)/data_param)));
    p_1_data = (zeros(size(orbit_tetra_ind,1),ceil(length(t_vec)/data_param)));
    p_2_data = (zeros(size(orbit_tetra_ind,1),ceil(length(t_vec)/data_param)));
    p_3_data = (zeros(size(orbit_tetra_ind,1),ceil(length(t_vec)/data_param)));
    u_data_mat = (zeros(size(j_ind_ast,1), ceil(length(t_vec)/data_param)));
    f_data_mat = (zeros(size(j_ind_ast,1), ceil(length(t_vec)/data_param)));

    data_ind = 0;

if time_series_id > 1

load([torre_dir '/data_' int2str(folder_ind) '/point_' int2str(process_id) '_field_data_' carrier_mode '.mat']);

p_1 = single(p_1);
p_2 = single(p_2);
p_3 = single(p_3);

else

    u = zeros(n_nodes,3);
    aux_vec_init = zeros(size(u));
   
    p_1 = single(zeros(n_tetrahedra,3));
    p_2 = single(zeros(n_tetrahedra,3));
    p_3 = single(zeros(n_tetrahedra,3));    

end

if not(ismember(gpu_extended_memory,[0 2]))
    
    u = gpuArray(u);
    aux_vec_init = gpuArray(aux_vec_init);

end

 if not(ismember(gpu_extended_memory,[0 1]))
    p_1 = gpuArray(p_1);
    p_2 = gpuArray(p_2);
    p_3 = gpuArray(p_3);
    A = gpuArray(A);
    div_vec = gpuArray(div_vec);
 end


update_waitbar_ind = floor(length(t_vec)/5000);

start_time = now;
for i = current_iterate + 1 : current_iterate + length(t_vec)

t = t_0 + (i-1)*d_t;

[pulse_window, d_pulse_window] = pulse_window_function(t-s_orbit(:,k)+t_shift, pulse_length, carrier_cycles_per_pulse_cycle, carrier_mode);
f_aux = pulse_window.*boundary_vec_1(:,k) + d_pulse_window.*boundary_vec_2(:,k);

div_vec(ast_ind) = p_1(ast_ind,1)+p_2(ast_ind,2)+p_3(ast_ind,3);

aux_vec =  - B_T_prod(p_1,p_2,p_3,div_vec,n_array,t_array,gpu_extended_memory) - mat_vec(R,u,gpu_extended_memory);
aux_vec(orbit_ind,1) = aux_vec(orbit_ind,1) + a_o(k,1)*f_aux; 
aux_vec(orbit_ind,2) = aux_vec(orbit_ind,2) + a_o(k,2)*f_aux; 
aux_vec(orbit_ind,3) = aux_vec(orbit_ind,3) + a_o(k,3)*f_aux; 

[aux_vec_init] = pcg_iteration_gpu(C,aux_vec,pcg_tol,pcg_maxit,M,aux_vec_init,gpu_extended_memory);
u_aux = d_t*pml_val*u(I_u,:);
u = u + d_t*aux_vec_init;
du_dt_vec = aux_vec_init(orbit_ind,:);
u(I_u,:) = u(I_u,:) - u_aux;

clear u_aux aux_vec;

[p_aux] = B_prod(u,1,n_array,t_array,gpu_extended_memory);

aux_vec = (A.*p_aux); 
p_aux = d_t*pml_val*p_1(I_p_x,:);
p_1 = p_1 + d_t*aux_vec;
dp_1_dt_vec = aux_vec(orbit_tetra_ind,:);
p_1(I_p_x,:) = p_1(I_p_x,:) - p_aux;

[p_aux] = B_prod(u,2,n_array,t_array,gpu_extended_memory);

aux_vec = (A.*p_aux); 
p_aux = d_t*pml_val*p_2(I_p_y,:);
p_2 = p_2 + d_t*aux_vec;
dp_2_dt_vec = aux_vec(orbit_tetra_ind,:);
p_2(I_p_y,:) = p_2(I_p_y,:) - p_aux;

[p_aux] = B_prod(u,3,n_array,t_array,gpu_extended_memory);

aux_vec = (A.*p_aux);
p_aux = d_t*pml_val*p_3(I_p_z,:);
p_3 = p_3 + d_t*aux_vec;
dp_3_dt_vec = aux_vec(orbit_tetra_ind,:);
p_3(I_p_z,:) = p_3(I_p_z,:) - p_aux;

clear p_aux aux_vec;

%%% data storage

if mod(i-1,data_param)==0
data_ind = data_ind + 1;
t_data(data_ind) = t;

u_data(:, data_ind) = gather(u(orbit_ind,1)*a_o(k,1) + u(orbit_ind,2)*a_o(k,2) + u(orbit_ind,3)*a_o(k,3));
du_dt_data(:, data_ind) = gather(du_dt_vec(:,1)*a_o(k,1) + du_dt_vec(:,2)*a_o(k,2) + du_dt_vec(:,3)*a_o(k,3));
p_1_data(:, data_ind) = gather(dp_1_dt_vec(:,1)*a_o(k,1) + dp_1_dt_vec(:,2)*a_o(k,2) + dp_1_dt_vec(:,3)*a_o(k,3));
p_2_data(:, data_ind) = gather(dp_2_dt_vec(:,1)*a_o(k,1) + dp_2_dt_vec(:,2)*a_o(k,2) + dp_2_dt_vec(:,3)*a_o(k,3));
p_3_data(:, data_ind) = gather(dp_3_dt_vec(:,1)*a_o(k,1) + dp_3_dt_vec(:,2)*a_o(k,2) + dp_3_dt_vec(:,3)*a_o(k,3));
u_data_mat(:,data_ind) = gather(u(j_ind_ast,1)*a_o(k,1) + u(j_ind_ast,2)*a_o(k,2) + u(j_ind_ast,3)*a_o(k,3));

div_vec(ast_ind) = p_1(ast_ind,1) + p_2(ast_ind,2) + p_3(ast_ind,3);
aux_vec = B_T_prod(p_1,p_2,p_3,div_vec,n_array,t_array,gpu_extended_memory) + mat_vec(R,u,gpu_extended_memory);
[aux_vec] = pcg_iteration_gpu(C,aux_vec,pcg_tol,pcg_maxit,M,zeros(size(aux_vec,1),3),gpu_extended_memory);
du_dt_vec_ast = aux_vec(j_ind_ast,:);
f_data_mat(:,data_ind) = gather(du_dt_vec_ast(:,1)*a_o(k,1) + du_dt_vec_ast(:,2)*a_o(k,2) + du_dt_vec_ast(:,3)*a_o(k,3));

clear aux_vec;

end   

if i == frame_param 
h_fig = figure(1); clf; 
set(h_fig,'paperunits','inches');
set(h_fig,'papersize',[1080 1920]);
set(h_fig,'paperposition',[0 0 1920 1080]);
set(gcf,'renderer','opengl'); set(gcf,'color',[84 90 112 ]/300); 
u_plot = real(gather(u(:,1)*a_o(k,1)+u(:,2)*a_o(k,2)+u(:,3)*a_o(k,3)));
max_plot_val = max(abs(u_plot(:)));
set(gcf, 'InvertHardCopy', 'off'); 
hold on;
u_plot_q = reshape(Interp_mat*u_plot,size(x_lattice_interpolation));
u_plot_q = smooth3(u_plot_q,'gaussian',ceil(length(x_lattice_interpolation)/20),1);
patch_val = max_plot_val/4;
patch_1 = patch(isosurface(x_lattice_interpolation,y_lattice_interpolation,z_lattice_interpolation,u_plot_q,patch_val));
isonormals(x_lattice_interpolation,y_lattice_interpolation,z_lattice_interpolation,u_plot_q,patch_1);
set(patch_1,'FaceColor',[0.8 0.8 0.8],'EdgeColor','none','facelighting','phong','diffusestrength',0.5,'specularstrength',0.5,'facealpha',0.5);
patch_2 = patch(isosurface(x_lattice_interpolation,y_lattice_interpolation,z_lattice_interpolation,u_plot_q,-patch_val));
h_iso = isonormals(x_lattice_interpolation,y_lattice_interpolation,z_lattice_interpolation,u_plot_q,patch_2);
set(patch_2,'FaceColor',[0.1 0.1 0.1],'EdgeColor','none','facelighting','phong','diffusestrength',0.5,'specularstrength',0.5,'facealpha',0.5);
view(c_view_1,c_view_2); set(gca,'visible','off');
h_surf_ast=trisurf(surface_triangles_ast,nodes(:,1),nodes(:,2),nodes(:,3),ones(size(nodes,1),1));
set(h_surf_ast,'facecolor',[1 0.9 0.8],'facealpha',0.35,'edgealpha',0,'diffusestrength',0.2,'specularstrength',0.2,'facelighting','gouraud');
h_camlight_1 = camlight(0,0);
h_camlight_2 = camlight(45,0);
axis equal;
set(gca,'xlim',[-s_radius s_radius]);
set(gca,'ylim',[-s_radius s_radius]);
set(gca,'zlim',[-s_radius s_radius]);
camva(5);
drawnow;
if make_video == 1
print(h_fig,'-r1','-dpng','video_frame_temp.png');
video_frame = imread('video_frame_temp.png');
writeVideo(time_lapse,video_frame);
end
elseif mod(i, frame_param) == 0
delete(patch_1)
delete(patch_2)
u_plot = real(gather(u(:,1)*a_o(k,1)+u(:,2)*a_o(k,2)+u(:,3)*a_o(k,3)));
max_plot_val = max(abs(u_plot(:)));
set(gcf, 'InvertHardCopy', 'off'); 
hold on;
u_plot_q = reshape(Interp_mat*u_plot,size(x_lattice_interpolation));
u_plot_q = smooth3(u_plot_q,'gaussian',ceil(length(x_lattice_interpolation)/20),1);
patch_val = max_plot_val/4;
patch_1 = patch(isosurface(x_lattice_interpolation,y_lattice_interpolation,z_lattice_interpolation,u_plot_q,patch_val));
isonormals(x_lattice_interpolation,y_lattice_interpolation,z_lattice_interpolation,u_plot_q,patch_1);
set(patch_1,'FaceColor',[0.8 0.8 0.8],'EdgeColor','none','facelighting','phong','diffusestrength',0.5,'specularstrength',0.5,'facealpha',0.5);
patch_2 = patch(isosurface(x_lattice_interpolation,y_lattice_interpolation,z_lattice_interpolation,u_plot_q,-patch_val));
h_iso = isonormals(x_lattice_interpolation,y_lattice_interpolation,z_lattice_interpolation,u_plot_q,patch_2);
set(patch_2,'FaceColor',[0.1 0.1 0.1],'EdgeColor','none','facelighting','phong','diffusestrength',0.5,'specularstrength',0.5,'facealpha',0.5);
view(c_view_1,c_view_2);
drawnow;
if make_video == 1
print(h_fig,'-r1','-dpng','video_frame_temp.png');
video_frame = imread('video_frame_temp.png');
writeVideo(time_lapse,video_frame);
end
end

if mod(i,update_waitbar_ind) == 0
    ready_time = datestr(start_time + (now-start_time)*(length(t_vec)-i+current_iterate)/(i-current_iterate));
    waitbar((i-current_iterate)/length(t_vec),h_waitbar,['Process ' int2str(process_id_counter) ' of ' int2str(length(process_id)) '. Ready approx.:' ready_time]);
    if norm(u(:,1)*a_o(k,1)+u(:,2)*a_o(k,2)+u(:,3)*a_o(k,3),Inf) > leap_frog_stopping_criterion
    error('Leap-frog iteration diverges.');
    end
end
end



if make_video == 1
close(time_lapse)
end

if time_series_count == 1

[rec_data] = surface_integral(u_data, du_dt_data, p_1_data, p_2_data, p_3_data, t_data, t_shift, source_points, orbit_nodes, orbit_triangles);

save([torre_dir '/data_' int2str(folder_ind) '/point_' int2str(k) '_data_' carrier_mode '.mat'], 'rec_data', 'u_data_mat', 'f_data_mat', 't_data', 'pulse_length', 'carrier_cycles_per_pulse_cycle');
else 
current_iterate = i;
if time_series_id < time_series_count
save([torre_dir '/data_' int2str(folder_ind) '/point_' int2str(k) '_field_data_' carrier_mode '.mat'], '-v7.3', 'u', 'aux_vec_init', 'p_1', 'p_2', 'p_3', 'current_iterate'); 
else
delete([torre_dir '/data_' int2str(folder_ind) '/point_' int2str(k) '_field_data_' carrier_mode '.mat']); 
end
save([torre_dir '/data_' int2str(folder_ind) '/point_' int2str(k) '_data_' carrier_mode '_' int2str(time_series_id) '.mat'], '-v7.3', 'u_data', 'du_dt_data', 'u_data_mat', 'f_data_mat', 'p_1_data', 'p_2_data', 'p_3_data', 't_data', 'pulse_length', 'carrier_cycles_per_pulse_cycle');
end

end


close(h_waitbar);

