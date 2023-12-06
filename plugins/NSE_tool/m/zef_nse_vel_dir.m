function direction = zef_nse_vel_dir(zef,nse_field)
% roi_ind = zef_nse_roi_ind(str2double(zef.nse_field.h_roi_x),str2double(zef.nse_field.h_roi_y),str2double(zef.nse_field.h_roi_z));

roi_ind = find(sqrt(sum((zef.source_positions - repmat([str2double(nse_field.h_roi_x.Value) str2double(nse_field.h_roi_y.Value) str2double(nse_field.h_roi_z.Value)],size(zef.source_positions,1),1)).^2,2))<= nse_field.roi_radius);
towards = [nse_field.dir_v_x nse_field.dir_v_y nse_field.dir_v_z];
c_ind_1_domain = find(ismember(zef.domain_labels,nse_field.artery_domain_ind));
[v_1_nodes, ~, ~] = zef_get_submesh(zef.nodes, zef.tetra, c_ind_1_domain);
dir_aux = -v_1_nodes(roi_ind,:)+towards;
direction = dir_aux./sqrt(dir_aux(:,1).^2+dir_aux(:,2).^2+dir_aux(:,3).^2);
end
