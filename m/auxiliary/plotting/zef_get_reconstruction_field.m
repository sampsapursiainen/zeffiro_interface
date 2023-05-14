function zef_get_reconstruction_field(reconstruction, s_i_ind, intersect_ind);


reconstruction = reconstruction(:);
reconstruction = reshape(reconstruction,3,length(reconstruction)/3);

if ismember(type,[1 7])
    reconstruction = sqrt(sum(reconstruction.^2))';
elseif type == 6
    reconstruction = (1/sqrt(3))*sum(reconstruction)';
end
if ismember(type, [1 6 7])
    reconstruction = sum(reconstruction(s_i_ind),2)/size(s_i_ind,2);
    reconstruction = reconstruction(I_2_b_rec);
    reconstruction = reconstruction(I_2_rec(I_1_rec));
end

if ismember(type, [2 3 4 5])
    rec_x = reconstruction(1,:)';
    rec_y = reconstruction(2,:)';
    rec_z = reconstruction(3,:)';
    rec_x = sum(rec_x(s_i_ind),2)/size(s_i_ind,2);
    rec_y = sum(rec_y(s_i_ind),2)/size(s_i_ind,2);
    rec_z = sum(rec_z(s_i_ind),2)/size(s_i_ind,2);
    rec_x = rec_x(I_2_b_rec);
    rec_y = rec_y(I_2_b_rec);
    rec_z = rec_z(I_2_b_rec);
    rec_x = rec_x(I_2_rec(I_1_rec));
    rec_y = rec_y(I_2_rec(I_1_rec));
    rec_z = rec_z(I_2_rec(I_1_rec));
end

if ismember(type, [2 3 4 5])
    reconstruction = sqrt((rec_x.*n_vec_aux(:,1)).^2 + (rec_y.*n_vec_aux(:,2)).^2 + (rec_z.*n_vec_aux(:,3)).^2);
end

if type == 3
    reconstruction = sqrt((rec_x - rec_x.*abs(n_vec_aux(:,1))).^2 + (rec_y - rec_y.*abs(n_vec_aux(:,2))).^2 + (rec_z - rec_z.*abs(n_vec_aux(:,3))).^2);
end

if type == 4
    aux_rec = rec_x.*n_vec_aux(:,1) + rec_y.*n_vec_aux(:,2) + rec_z.*n_vec_aux(:,3);
    I_aux_rec = find(aux_rec > 0);
    reconstruction(I_aux_rec) = 0;
end

if type == 5
    aux_rec = rec_x.*n_vec_aux(:,1) + rec_y.*n_vec_aux(:,2) + rec_z.*n_vec_aux(:,3);
    I_aux_rec = find(aux_rec <= 0);
    reconstruction(I_aux_rec) = 0;
end

if ismember(type, [2 3 4 5 7])
    reconstruction = zef_smooth_field(surface_triangles(I_3_rec,:), reconstruction, size(nodes,1),3);
end

end

if not(ismember(type, [6]))
    if eval('zef.inv_scale') == 1
        reconstruction = -min_rec_log10 + 20*log10(max(reconstruction,max_abs_reconstruction/eval('zef.inv_dynamic_range')));
    elseif eval('zef.inv_scale') == 2
        reconstruction = (max(reconstruction,max_abs_reconstruction/eval('zef.inv_dynamic_range')));
    elseif eval('zef.inv_scale') == 3
        reconstruction = sqrt(max(reconstruction,max_abs_reconstruction/eval('zef.inv_dynamic_range')));
    end
end

end


if eval('zef.use_parcellation')

    if eval('zef.parcellation_type') > 1
        rec_aux = zeros(size(reconstruction));
        if eval('zef.parcellation_type') == 2
            for p_ind = selected_list
                rec_aux(p_cell{p_ind+1}) = quantile(reconstruction(p_cell{p_ind+1}),eval('zef.parcellation_quantile'));
            end
        elseif eval('zef.parcellation_type') == 3
            for p_ind = selected_list
                rec_aux(p_cell{p_ind+1}) = quantile(sqrt(reconstruction(p_cell{p_ind+1})),eval('zef.parcellation_quantile'));
            end
        elseif eval('zef.parcellation_type') == 4
            for p_ind = selected_list
                rec_aux(p_cell{p_ind+1}) = quantile((reconstruction(p_cell{p_ind+1})).^(1/3),eval('zef.parcellation_quantile'));
            end
        elseif eval('zef.parcellation_type') == 5
            for p_ind = selected_list
                rec_aux(p_cell{p_ind+1}) = mean(reconstruction(p_cell{p_ind+1}));
            end
        end
        reconstruction = rec_aux;
    end

    reconstruction = reconstruction.*reconstruction_p_2;
end
