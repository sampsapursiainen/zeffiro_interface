
function [nodes,flag_val] = zef_fix_negatives(zef, nodes, tetra)

if isempty(zef)
    zef = evalin('base','zef');
end

threshold_value = zef.meshing_threshold;

fix_n_max = eval('zef.mesh_optimization_repetitions');
fix_param = 0.5;
fix_it = 0;

c = find(zef_condition_number(nodes,tetra)<0);
fix_length = length(c);
%condition_number_thresh = max(0,thresh_val*max(condition_number));

if fix_length > 0

    h_waitbar = zef_waitbar([0],[1], ['Fix ' num2str(fix_length) ' negatives.']);

    while fix_it < fix_n_max && fix_length > 0
        fix_it = fix_it + 1;

        tetra_c = tetra(find(sum(ismember(tetra,tetra(c,:)),2)),:);
        c = find(sum(ismember(tetra_c,tetra(c,:)),2)==4);

        for i = 1 : length(c)

            if mod(i,ceil(length(c)/20))==0 || length(c) < 50
                zef_waitbar([i], [length(c)],h_waitbar, ['Fix ' num2str(fix_length) ' negatives.']);
            end

            [~,~,~,~,g] = zef_surface_mesh(tetra_c, [], c(i));

            g = g(find(g));

            fix_ind = 0;
            j = 0;

            while j < 4 && fix_ind == 0

                j = j + 1;
                vec_1 = nodes(tetra_c(c(i),j),:);
                I =  find(sum(ismember(tetra_c(g,:),tetra_c(c(i),j)),2)==0);
                if not(isempty(I))
                    vec_2 = nodes(setdiff(tetra_c(g(I(1)),:),tetra_c(c(i),:)),:);
                    tetra_ind = find(sum(ismember(tetra_c,tetra_c(c(i),j)),2));
                    tri = zef_surface_mesh(tetra_c, [], tetra_ind);
                    u_tri = unique(tri);

                    u_tri_rand = randperm(length(u_tri));
                    vec_3 = mean(nodes(u_tri(u_tri_rand(1:end-3)),:),1);

                    p_in_c = zef_point_in_cluster(nodes,tri,vec_3,threshold_value);
                    if isempty(p_in_c)
                        [~, lambda_1] = zef_find_intersecting_triangle(vec_1, vec_2,1,tri,nodes,'nonconvex');
                        if not(isempty(lambda_1))
                            vec_3 = vec_1 - lambda_1*(vec_2 - vec_1);
                            [~, lambda_1] = zef_find_intersecting_triangle(vec_3, vec_2,-1,tri,nodes,'nonconvex');
                            if not(isempty(lambda_1))
                                vec_3 = vec_3 - fix_param*lambda_1*(vec_2 - vec_3);
                            end
                        end
                    end

                    node_ind = 0;
                    if not(isempty(vec_3))
                        p_in_c = zef_point_in_cluster(nodes,tri,vec_3,threshold_value);
                        while  isempty(p_in_c)  && node_ind < length(u_tri)
                            node_ind = node_ind + 1;
                            vec_2 = nodes(u_tri(node_ind),:);
                            [~, lambda_1] = zef_find_intersecting_triangle(vec_3, vec_2,-1,tri,nodes,'nonconvex');
                            if not(isempty(lambda_1))
                                vec_3 = vec_3 - fix_param*lambda_1*(vec_2 - vec_3);
                            end
                        end
                    end

                    nodes(tetra_c(c(i),j),:) = vec_3;

                end
            end

            if isempty(find(zef_condition_number(nodes,tetra_c([c(i);g(:)],:))<0))
                fix_ind = j;
            end

            if fix_ind == 0
                nodes(tetra_c(c(i),j),:) = vec_1;
            end

        end

        c = find(zef_condition_number(nodes,tetra)<0);
        fix_length = length(c);

    end

    close(h_waitbar);

end

if fix_length == 0
    flag_val = 1;
else
    flag_val = -1;
end

end
