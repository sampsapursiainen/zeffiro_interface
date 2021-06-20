function [ell_idx] = zef_ES_4x1_sensors(source_pos, source_ori, separation_angle, source_coord)

ell_idx    = zeros(5,1);
source_pos = source_pos(:)';
source_ori = source_ori(:)';

d_norm = sqrt(sum((source_pos - source_coord).^2,2));

[~,m_ind] = min(d_norm);

p_1 = source_coord((m_ind),:);
    ell_idx(1) = m_ind;
    v_1 = p_1;
    p_1_norm = sqrt(sum(p_1.^2,2));
    v_1 = v_1./p_1_norm;
    v_2 = source_ori./sqrt(sum(source_ori.^2,2));
    v_3 = cross(v_1',v_2')';
    source_index = [1:size(source_coord,1)];
    source_index = setdiff(source_index, m_ind);
    source_coord = source_coord(source_index,:);

p_2 = p_1 + p_1_norm*tan(pi*separation_angle/180)*v_2;
    d_norm = sqrt(sum((p_2 - source_coord).^2,2));
    [~,m_ind] = min(d_norm);
    ell_idx(2) = source_index(m_ind);

p_3 = p_1 + p_1_norm*tan(-pi*separation_angle/180)*v_2;
    d_norm = sqrt(sum((p_3 - source_coord).^2,2));
    [~,m_ind] = min(d_norm);
    ell_idx(3) = source_index(m_ind);

p_4 = p_1 + p_1_norm*tan(pi*separation_angle/180)*v_3;
    d_norm = sqrt(sum((p_4 - source_coord).^2,2));
    [~,m_ind] = min(d_norm);
    ell_idx(4) = source_index(m_ind);

p_5 = p_1 + p_1_norm*tan(-pi*separation_angle/180)*v_3;
    d_norm = sqrt(sum((p_5 - source_coord).^2,2));
    [~,m_ind] = min(d_norm);
    ell_idx(5) = source_index(m_ind);

end