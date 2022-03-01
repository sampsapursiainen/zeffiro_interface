function [z] = zef_normalizeInverseReconstruction(z)
%zef_normalizeInverseReconstruction normalized the postProcessed inverse
%output z for the later plotting

    aux_norm_vec = 0;
    for f_ind = 1 : length(z)
        aux_norm_vec = max(sqrt(sum(reshape(z{f_ind}, 3, length(z{f_ind})/3).^2)),aux_norm_vec);
    end
    for f_ind = 1 : length(z)
        z{f_ind} = z{f_ind}./max(aux_norm_vec);
    end

end

