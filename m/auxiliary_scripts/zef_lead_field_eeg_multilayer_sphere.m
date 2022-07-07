function [L_eeg] = zef_lead_field_eeg_multilayer_sphere(electrodes,source_positions,source_directions,sphere_model)

lam_berg = sphere_model.lambda_berg;
mu_berg = sphere_model.mu_berg;
sigma_val = sphere_model.sigma(end);

if isempty(source_directions)
source_directions = repmat(eye(3),size(source_positions,1),1);
source_positions = reshape(repmat(source_positions',3,1),3,3*size(source_positions,1))';
end

electrode_points = electrodes(:,1:3)';
L_eeg = zeros(size(electrode_points,2), size(source_positions,1));
xyz_norm_vec = sqrt(sum(source_directions'.^2));
F = source_directions'./repmat(xyz_norm_vec,3,1);

vec_dofs = source_positions';
vec_dofs_aux = vec_dofs;

 for j = 1 : length(lam_berg)

 vec_dofs = mu_berg(j)*vec_dofs_aux;
 cos_alpha = sum(F.*vec_dofs)./sqrt(sum(vec_dofs.^2));
 sin_alpha = abs(sqrt(1 - cos_alpha.^2));
 aux_angle_vec_1 = cross(F,vec_dofs);
 aux_angle_vec_1 = aux_angle_vec_1./repmat(sqrt(sum(aux_angle_vec_1.^2)),3,1);
 r_q_vec = sqrt(sum((vec_dofs.^2)));

for i = 1 : size(electrode_points,2)

   cos_gamma = (sum(repmat(electrode_points(:,i), 1, size(vec_dofs,2)).*vec_dofs)./(sqrt(sum(vec_dofs.^2))*sqrt(sum(electrode_points(:,i).^2))));
   sin_gamma = abs(sqrt(1 - cos_gamma.^2));
   aux_angle_vec_2 = cross(repmat(electrode_points(:,i), 1, size(vec_dofs,2)),vec_dofs);
   aux_angle_vec_2 = aux_angle_vec_2./repmat(sqrt(sum(aux_angle_vec_2.^2)),3,1);
   cos_beta = (sum(aux_angle_vec_1.*aux_angle_vec_2));
   d_vec = sqrt(sum((vec_dofs - repmat(electrode_points(:,i), 1, size(vec_dofs,2))).^2));
   r_vec = sqrt(sum((repmat(electrode_points(:,i), 1, size(vec_dofs,2))).^2));
   v_r = cos_alpha.*(2*(r_vec.*cos_gamma - r_q_vec)./(d_vec.^3) + 1./(r_q_vec.*d_vec) - 1./(r_vec.*r_q_vec));
   v_t = sin_alpha.*cos_beta.*sin_gamma.*(2*r_vec./(d_vec.^3) + ( d_vec + r_vec )./(r_vec.*d_vec.*(r_vec - r_q_vec.*cos_gamma + d_vec)));
   L_eeg(i,:) = L_eeg(i,:) + lam_berg(j)*(v_r + v_t);

end
end

L_eeg = repmat(xyz_norm_vec./(4*pi*sigma_val),size(L_eeg,1),1).*L_eeg;
L_eeg = L_eeg - repmat(sum(L_eeg), size(electrode_points,2), 1)/size(electrode_points,2);

end
