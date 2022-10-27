function [z] = postprocess_reconstruction(z_inverse, procFile)

    % postprocess_reconstruction
    %
    % Reorders the inverse output z_inverse to fit the visibility options. The
    % procFile is given by goodness_of_inversion.process_leadfield.

    source_direction_mode=procFile.source_direction_mode;
    source_directions=procFile.source_directions;
    s_ind_1=procFile.s_ind_1;
    s_ind_2=procFile.s_ind_2;
    s_ind_4=procFile.s_ind_4;
    sizeL2=procFile.sizeL2;
    n_interp=procFile.n_interp;

    z=cell(size(z_inverse));

    for f_ind=1:length(z_inverse)

        z_vec=z_inverse{f_ind};

        if ismember(source_direction_mode, [1,2])
            z_aux = zeros(sizeL2,1);
        end

        if source_direction_mode == 3
            z_aux = zeros(3*sizeL2,1);
        end

        if ismember(source_direction_mode,[2])
            z_vec_aux = (z_vec(s_ind_4) + z_vec(n_interp+s_ind_4) + z_vec(2*n_interp+s_ind_4))/3;%sould all be the same value
            z_vec(s_ind_4) = z_vec_aux.*source_directions(s_ind_4,1);
            z_vec(n_interp+s_ind_4) = z_vec_aux.*source_directions(s_ind_4,2);
            z_vec(2*n_interp+s_ind_4) = z_vec_aux.*source_directions(s_ind_4,3);
        end

        if ismember(source_direction_mode,[3])
            z_vec = [z_vec.*source_directions(:,1); z_vec.*source_directions(:,2); z_vec.*source_directions(:,3)];
        end

        if ismember(source_direction_mode,[1 2])
            z_aux(s_ind_1) = z_vec;
        end

        if ismember(source_direction_mode,[3])
            z_aux(s_ind_2) = z_vec;
        end

        z{f_ind} = z_aux;

    end % for

end % function
