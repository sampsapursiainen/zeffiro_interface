function [I, distance_vec, label_vec] = zef_solid_angle_labeling(zef, tetra, nodes, h)  


if nargin < 4
h = zef_waitbar(0,'Mesh labeling.')
close_waitbar = true;
else
    close_waitbar = false;
end

I = zeros(size(nodes,1), 1);
distance_vec = zeros(size(nodes,1), 1);

    I_2 = [1 : length(I)]';

compartment_counter = 0;
submesh_vec = cell2mat(zef.reuna_submesh_ind);
n_compartments = length(submesh_vec);
label_vec = [1:n_compartments]';

for i_labeling =  1 : length(zef.reuna_p)
    for k_labeling =  1 : length(zef.reuna_submesh_ind{i_labeling})

compartment_counter = compartment_counter + 1;

if compartment_counter < n_compartments
     
            if isempty(zef.reuna_submesh_ind{i_labeling})
                reuna_t_aux = zef.reuna_t{i_labeling};
            else
                if k_labeling == 1
                    reuna_t_aux = zef.reuna_t{i_labeling}(1:zef.reuna_submesh_ind{i_labeling}(k_labeling),:);
                else
                    reuna_t_aux = zef.reuna_t{i_labeling}(zef.reuna_submesh_ind{i_labeling}(k_labeling-1)+1: zef.reuna_submesh_ind{i_labeling}(k_labeling),:);
                end
            end

                [I_1,distance_vec_aux] = zef_point_in_compartment(zef,zef.reuna_p{i_labeling},reuna_t_aux,nodes(I_2,:),[compartment_counter n_compartments]);
                I(I_2(I_1)) = compartment_counter;
                distance_vec(I_2(I_1)) = distance_vec_aux;

                I_2 = find(I==0);

end
    end
end

I_2 = find(I==0);
I(I_2) = label_vec(end);

if close_waitbar
close(h);
end
