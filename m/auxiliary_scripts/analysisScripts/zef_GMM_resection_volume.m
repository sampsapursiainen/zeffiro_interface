function [V, V_and, V_or] = zef_GMM_resection_volume(res_zef, FB,D, GMM,GMM_ind)

%the GMM-dipole is inside the resection
    %
%the GMM-dipole is outside the resection

%%
% d=nan(size(points,1),1);
% inside_index=tetra_in_compartment(mesh_points, mesh_edges, points);
% not_inside=setdiff(1:size(points, 1), inside_index);
% d(inside_index)=0;
% d(not_inside)=zef_distance_to_mesh(points(not_inside,:), mesh_points, mesh_edges);

%%

nodes = D.Points;
tetrahedra = D.ConnectivityList;
Aux_mat = [nodes(tetrahedra(:,1),:)'; nodes(tetrahedra(:,2),:)'; nodes(tetrahedra(:,3),:)'] - repmat(nodes(tetrahedra(:,4),:)',3,1);
ind_m = [1 4 7; 2 5 8 ; 3 6 9];
c_vol = abs(Aux_mat(ind_m(1,1),:).*(Aux_mat(ind_m(2,2),:).*Aux_mat(ind_m(3,3),:)-Aux_mat(ind_m(2,3),:).*Aux_mat(ind_m(3,2),:)) ...
                - Aux_mat(ind_m(1,2),:).*(Aux_mat(ind_m(2,1),:).*Aux_mat(ind_m(3,3),:)-Aux_mat(ind_m(2,3),:).*Aux_mat(ind_m(3,1),:)) ...
                + Aux_mat(ind_m(1,3),:).*(Aux_mat(ind_m(2,1),:).*Aux_mat(ind_m(3,2),:)-Aux_mat(ind_m(2,2),:).*Aux_mat(ind_m(3,1),:)))/6;
c_points = 0.25*(nodes(tetrahedra(:,1),:)+ nodes(tetrahedra(:,2),:)+nodes(tetrahedra(:,3),:)+nodes(tetrahedra(:,4),:));

%%

alpha = str2num(GMM.parameters.Values{6})/100;
r = sqrt(chi2inv(alpha,3));

c_points_inside=zef_insideGMM(GMM, c_points,inf);
c_points_inside=c_points_inside(:, GMM_ind);

pos=[GMM.model.mu(GMM_ind,1),GMM.model.mu(GMM_ind,2),GMM.model.mu(GMM_ind,3)];
    [principal_axes,semi_axes]=eig(inv(GMM.model.Sigma(1:3,1:3,GMM_ind)));
    semi_axes = transpose(r./sqrt(diag(semi_axes)));

if isempty(find(c_points_inside,1))

    if zef_distance_to_resection(pos, res_zef, FB)==0
        V_or=sum(c_vol);
        V_and=4/3*pi*semi_axes(1)*semi_axes(2)*semi_axes(3);

    else
        V_or=sum(c_vol)+4/3*pi*semi_axes(1)*semi_axes(2)*semi_axes(3);
        V_and=0;
    end

else

    V_and=sum(c_vol(find(c_points_inside)));
    V_or=sum(c_vol)+4/3*pi*semi_axes(1)*semi_axes(2)*semi_axes(3)-V_and;

end

V=V_and/V_or;

end

