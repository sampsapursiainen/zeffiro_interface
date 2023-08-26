time_vec = linspace(zef.nse_field.start_time, zef.nse_field.time_length,length(zef.nse_field.bp_vessels));

c_ind_1_domain = find(ismember(zef.domain_labels,zef.nse_field.artery_domain_ind));
[v_1_nodes, v_1_tetra, ~] = zef_get_submesh(zef.nodes, zef.tetra, c_ind_1_domain);
found = find(abs(v_1_nodes(145873,1)-v_1_nodes(:,1))<=1.5 & abs(v_1_nodes(145873,2)-v_1_nodes(:,2))<=1.5 & abs(v_1_nodes(145873,3)-v_1_nodes(:,3))<=1.5);
found2 = find(abs(v_1_nodes(73405,1)-v_1_nodes(:,1))<=2.4 & abs(v_1_nodes(73405,2)-v_1_nodes(:,2))<=2.4 & abs(v_1_nodes(73405,3)-v_1_nodes(:,3))<=2.4);

dir_aux = -v_1_nodes(found,:)+v_1_nodes(147109,:);
dir_aux = dir_aux./sqrt(dir_aux(:,1).^2+dir_aux(:,2).^2+dir_aux(:,3).^2);
dir_aux2 = v_1_nodes(75640,:)-v_1_nodes(found2,:);
dir_aux2 = dir_aux2./sqrt(dir_aux2(:,1).^2+dir_aux2(:,2).^2+dir_aux2(:,3).^2);


n_nodes = size(v_1_nodes,1);
i_node_ind = [1:n_nodes]';
%i_node_ind = setdiff(i_node_ind,zef.nse_field.b_nodes);



%%
region=found2;
direction=dir_aux2;
%%

aux_collect2_viscosity = zeros(size(zeros(size(zef.nse_field.bp_vessels,2),1),1),1);

%viscosity
for i=1:size(zeros(size(zef.nse_field.bp_vessels,2),1),1)
aux_collect2_viscosity(i) = mean(zef.nse_field.mu_vessels{1,i}(region,1));
end
%mean(zef.nse_field.mu_vessels{1,i}(found,1));
%mean(zef.nse_field.bv_vessels_1{1,i}(found2,1).*test2_2(:,1)+zef.nse_field.bv_vessels_2{1,i}(found2,1).*test2_2(:,2)+zef.nse_field.bv_vessels_3{1,i}(found2,1).*test2_2(:,3))
%mean(zef.nse_field.bv_vessels_1{1,i}(found,1).*test2(:,1)+zef.nse_field.bv_vessels_2{1,i}(found,1).*test2(:,2)+zef.nse_field.bv_vessels_3{1,i}(found,1).*test2(:,3))
%mean(zef.nse_field.bp_vessels{1,i}(found,1))
figure(1)
% plot(time_vec_aux(time_frame_ind),aux_collect2)
plot(time_vec,aux_collect2_viscosity)
h_axes = gca;
h_axes.FontSize = 18;
h_axes.XGrid = 'on';
h_axes.YGrid = 'on';
xlabel('Time (s)')
ylabel('Viscosity (Pa s)')
f1 = figure(2);
f1.Position(3:4) = [1500 900];
%% velocity
%found = nodes of the further region
%found2 = nodes of the closer region
%dir_aux = assumed direction of the flow in the further region
%dir_aux2 = assumed direction of the flow in the closer region

aux_collect2_velocity = zeros(size(zeros(size(zef.nse_field.bp_vessels,2),1),1),1);

for i=1:size(zeros(size(zef.nse_field.bp_vessels,2),1),1)
aux_collect2_velocity(i) = mean(zef.nse_field.bv_vessels_1{1,i}(region,1).*direction(:,1)+zef.nse_field.bv_vessels_2{1,i}(region,1).*direction(:,2)+zef.nse_field.bv_vessels_3{1,i}(region,1).*direction(:,3));
end
figure(2)
% plot(time_vec_aux(time_frame_ind),aux_collect2)
plot(time_vec,aux_collect2_velocity)
h_axes = gca;
h_axes.FontSize = 18;
h_axes.XGrid = 'on';
h_axes.YGrid = 'on';
xlabel('Time (s)')
ylabel('Velocity (m/s)')
f1 = figure(2);
f1.Position(3:4) = [1500 900];
%%
aux1=0;
aux2=100;
%boundary_points = intersect(found,zef.nse_field.b_nodes);
C1 = 0.00797;
C2 = 0.0608;
C3 = 0.00499;
C4 = 14.585;
Hem = 40;
TPMA = 25.9;


%for i=1:size(zeros(size(zef.nse_field.bp_vessels,2),1),1)
%     trace_strain_rate = (zef.nse_field.mu_vessels{1,i}(boundary_points)./(0.1*C1)*exp(-C2*Hem)*exp(-C4*(TPMA/(Hem^2)))).^(1/(-C3*Hem));
%     trace_strain_rate = ((((zef.nse_field.mu_vessels{1,i}(boundary_points)-zef.nse_field.mu)./(zef.nse_field.viscosity_delta)).^(zef.nse_field.viscosity_transition/(zef.nse_field.viscosity_exponent-1))-1).^(1/zef.nse_field.viscosity_transition))./zef.nse_field.viscosity_relaxation_time;
%     trace_strain_rate = (sqrt(0.01*((0.625*0.35)^3))./(sqrt(zef.nse_field.mu_vessels{1,i}(boundary_points))-sqrt(0.0012*((1-0.35)^(-5/2))))).^2;
%     aux_collect2(i) = mean(trace_strain_rate.*zef.nse_field.mu_vessels{1,i}(boundary_points));
  %  aux_collect2(i) = mean(zef.nse_field.shearrate1{1,i}(boundary_points).*zef.nse_field.mu_vessels{1,i}(boundary_points));
%end
%figure(3)
% plot(time_vec_aux(time_frame_ind),aux_collect2)
%plot(1:zef.nse_field.n_frames,aux_collect2)

%h_axes = gca;
%h_axes.FontSize = 18;
%h_axes.XGrid = 'on';
%h_axes.YGrid = 'on';
%xlabel('Time (s)')
%ylabel('Shear stress (Pa)')
%f1 = figure(2);
%f1.Position(3:4) = [1500 900];
%%
% pressure

aux_collect2_pressure = zeros(size(zeros(size(zef.nse_field.bp_vessels,2),1),1),1);

for i=1:size(zeros(size(zef.nse_field.bp_vessels,2),1),1)
    aux_collect2_pressure(i) = mean(zef.nse_field.bp_vessels{1,i}(region));
end
figure(4)
% plot(time_vec_aux(time_frame_ind),aux_collect2)
plot(time_vec,aux_collect2_pressure)
h_axes = gca;
h_axes.FontSize = 18;
h_axes.XGrid = 'on';
h_axes.YGrid = 'on';
xlabel('Time (s)')
ylabel('Pressure (mmHg)')
f1 = figure(2);
f1.Position(3:4) = [1500 900];
%%
% aux1=0;
% aux2=100;
% for i=200:300
% if max(zef.nse_field.shearrate1{1,i}(ia,1).*zef.nse_field.mu_vessels{1,i}(ia,1))> aux1
% aux1 = max(zef.nse_field.shearrate1{1,i}(ia,1).*zef.nse_field.mu_vessels{1,i}(ia,1));
% end
% if min(zef.nse_field.shearrate1{1,i}(ia,1).*zef.nse_field.mu_vessels{1,i}(ia,1))<aux2
% aux2 = min(zef.nse_field.shearrate1{1,i}(ia,1).*zef.nse_field.mu_vessels{1,i}(ia,1));
% end
% end

%%
% aux_varib33=zeros(300,99);
% aux_varib22=zeros(300,40);
% 
% for i=1:300
% aux_varib33(i,:) = zef.nse_field.shearrate1{1,i}(ia,1).*zef.nse_field.mu_vessels{1,i}(ia,1);
% end
% 
% for i=1:300
% aux_varib22(i,:) = zef.nse_field.shearrate1{1,i}(ia2,1).*zef.nse_field.mu_vessels{1,i}(ia2,1);
% end

% mean(mean(aux_varib22(1:100,:),2))
% mean(mean(aux_varib22(100:200,:),2))
% mean(mean(aux_varib22(200:300,:),2))
% std(std(aux_varib22(1:100,:),0,2))
% std(std(aux_varib22(100:200,:),0,2))
% std(std(aux_varib22(200:300,:),0,2))
% 
% mean(mean(aux_varib33(1:100,:),2))
% mean(mean(aux_varib33(100:200,:),2))
% mean(mean(aux_varib33(200:300,:),2))
% std(std(aux_varib33(1:100,:),0,2))
% std(std(aux_varib33(100:200,:),0,2))
% std(std(aux_varib33(200:300,:),0,2))
% %%
% aux1=0;
% aux2=0;
% for i=200:300
% if max(dir_aux2(:,1).*zef.nse_field.bv_vessels_1{1,i}(found2,1)+dir_aux2(:,2).*zef.nse_field.bv_vessels_2{1,i}(found2,1)+dir_aux2(:,3).*zef.nse_field.bv_vessels_3{1,i}(found2,1))> aux1
% aux1 = max(dir_aux2(:,1).*zef.nse_field.bv_vessels_1{1,i}(found2,1)+dir_aux2(:,2).*zef.nse_field.bv_vessels_2{1,i}(found2,1)+dir_aux2(:,3).*zef.nse_field.bv_vessels_3{1,i}(found2,1));
% end
% if min(dir_aux2(:,1).*zef.nse_field.bv_vessels_1{1,i}(found2,1)+dir_aux2(:,2).*zef.nse_field.bv_vessels_2{1,i}(found2,1)+dir_aux2(:,3).*zef.nse_field.bv_vessels_3{1,i}(found2,1))<aux2
% aux2 = min(dir_aux2(:,1).*zef.nse_field.bv_vessels_1{1,i}(found2,1)+dir_aux2(:,2).*zef.nse_field.bv_vessels_2{1,i}(found2,1)+dir_aux2(:,3).*zef.nse_field.bv_vessels_3{1,i}(found2,1));
% end
% end
% %%
% aux1=0;
% aux2=0;
% for i=200:300
% if max(dir_aux(:,1).*zef.nse_field.bv_vessels_1{1,i}(found,1)+dir_aux(:,2).*zef.nse_field.bv_vessels_2{1,i}(found,1)+dir_aux(:,3).*zef.nse_field.bv_vessels_3{1,i}(found,1))> aux1
% aux1 = max(dir_aux(:,1).*zef.nse_field.bv_vessels_1{1,i}(found,1)+dir_aux(:,2).*zef.nse_field.bv_vessels_2{1,i}(found,1)+dir_aux(:,3).*zef.nse_field.bv_vessels_3{1,i}(found,1));
% end
% if min(dir_aux(:,1).*zef.nse_field.bv_vessels_1{1,i}(found,1)+dir_aux(:,2).*zef.nse_field.bv_vessels_2{1,i}(found,1)+dir_aux(:,3).*zef.nse_field.bv_vessels_3{1,i}(found,1))<aux2
% aux2 = min(dir_aux(:,1).*zef.nse_field.bv_vessels_1{1,i}(found,1)+dir_aux(:,2).*zef.nse_field.bv_vessels_2{1,i}(found,1)+dir_aux(:,3).*zef.nse_field.bv_vessels_3{1,i}(found,1));
% end
% end
% 
% %%
% 
% aux_varib33=zeros(300,167);
% aux_varib22=zeros(300,51);
% 
% for i=1:300
% aux_varib33(i,:) = dir_aux2(:,1).*zef.nse_field.bv_vessels_1{1,i}(found2,1)+dir_aux2(:,2).*zef.nse_field.bv_vessels_2{1,i}(found2,1)+dir_aux2(:,3).*zef.nse_field.bv_vessels_3{1,i}(found2,1);
% end
% 
% for i=1:300
% aux_varib22(i,:) = dir_aux(:,1).*zef.nse_field.bv_vessels_1{1,i}(found,1)+dir_aux(:,2).*zef.nse_field.bv_vessels_2{1,i}(found,1)+dir_aux(:,3).*zef.nse_field.bv_vessels_3{1,i}(found,1);
% end
% 
% mean(mean(aux_varib22(1:100,:),2))
% mean(mean(aux_varib22(100:200,:),2))
% mean(mean(aux_varib22(200:300,:),2))
% std(std(aux_varib22(1:100,:),0,2))
% std(std(aux_varib22(100:200,:),0,2))
% std(std(aux_varib22(200:300,:),0,2))
% 
% mean(mean(aux_varib33(1:100,:),2))
% mean(mean(aux_varib33(100:200,:),2))
% mean(mean(aux_varib33(200:300,:),2))
% std(std(aux_varib33(1:100,:),0,2))
% std(std(aux_varib33(100:200,:),0,2))
% std(std(aux_varib33(200:300,:),0,2))
% %%
% mean(zef.nse_field.bp_vessels{1,35}(found,1))+(1/3)*(mean(zef.nse_field.bp_vessels{1,100}(found,1))-mean(zef.nse_field.bp_vessels{1,35}(found,1)))
% mean(zef.nse_field.bp_vessels{1,135}(found,1))+(1/3)*(mean(zef.nse_field.bp_vessels{1,200}(found,1))-mean(zef.nse_field.bp_vessels{1,135}(found,1)))
% mean(zef.nse_field.bp_vessels{1,235}(found,1))+(1/3)*(mean(zef.nse_field.bp_vessels{1,300}(found,1))-mean(zef.nse_field.bp_vessels{1,235}(found,1)))
% 
% 
% mean(zef.nse_field.bp_vessels{1,35}(found2,1))+(1/3)*(mean(zef.nse_field.bp_vessels{1,100}(found2,1))-mean(zef.nse_field.bp_vessels{1,35}(found2,1)))
% mean(zef.nse_field.bp_vessels{1,135}(found2,1))+(1/3)*(mean(zef.nse_field.bp_vessels{1,200}(found2,1))-mean(zef.nse_field.bp_vessels{1,135}(found2,1)))
% mean(zef.nse_field.bp_vessels{1,235}(found2,1))+(1/3)*(mean(zef.nse_field.bp_vessels{1,300}(found2,1))-mean(zef.nse_field.bp_vessels{1,235}(found2,1)))
% 
% %%
% found = find(abs(v_1_nodes(145873,1)-v_1_nodes(:,1))<=1.5 & abs(v_1_nodes(145873,2)-v_1_nodes(:,2))<=1.5 & abs(v_1_nodes(145873,3)-v_1_nodes(:,3))<=1.5);