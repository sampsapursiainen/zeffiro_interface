function  patch_data = zef_set_surface_resolution(zef,patch_data,surface_resolution)

if not(isempty(patch_data.vertices))

    mesh_res = eval('zef.mesh_resolution');

    area_val = sum(sqrt(sum(cross(patch_data.vertices(patch_data.faces(:,2),:)'-patch_data.vertices(patch_data.faces(:,1),:)', patch_data.vertices(patch_data.faces(:,3),:)'-patch_data.vertices(patch_data.faces(:,1),:)').^2))/2);

    if surface_resolution <= 100

        face_count_from_volume = surface_resolution^2*area_val./mesh_res.^2;
        face_count_from_surface = size(patch_data.faces,1);

        if face_count_from_volume > face_count_from_surface

            n_ref = floor((log(face_count_from_volume) - log(face_count_from_surface))/log(4));
            for i = 1 : n_ref
                [patch_data.vertices, patch_data.faces] = zef_triangular_mesh_refinement(patch_data.vertices,patch_data.faces);
            end

        else

            patch_data = reducepatch(patch_data,face_count_from_volume);

        end

    else

        patch_data = reducepatch(patch_data,surface_resolution);

    end

end

end
