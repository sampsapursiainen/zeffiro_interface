function [triangles] = zef_get_strip_contacts(zef,strip_struct,contact_index)

if isequal(domain_type,'geometry')

compartment_ind = find(ismember(zef.compartment_tags,strip_struct.compartment_tag),1);
strip_struct.points = zef.reuna_p{compartment_ind}; 
strip_struct.triangles = zef.reuna_t{compartment_ind}; 
strip_struct.points = zef_strip_coordinate_transform(strip_struct,'reverse');
triangles = zef.reuna_t{compartment_ind};

end

if isequal(domain_type,'mesh')

compartment_ind = find(ismember(zef.compartment_tags,strip_struct.compartment_tag),1);
I = find(zef.domain_labels <= compartment_ind);
triangles = zef_surface_mesh(tetra, nodes, I, gpu_mode);
[poins_aux,triangles_aux] = zef_get_submesh(zef.nodes,triangles);
strip_struct.points = points_aux; 
strip_struct.triangles = triangles_aux; 
strip_struct.points = zef_strip_coordinate_transform(strip_struct,'reverse');

end

if isequal(strip_model,'omnidirectional_4')
point_ind = find(strip_struct.points(:,3)>1.5+1.5*(contact_index-1) & strip_struct.points(:,3)<1.5+1.5*contact_index);
end

tri_ind = find(sum(ismember(strip_struct.triangles,point_ind),2)==3);
triangles = triangles(tri_ind,:);
triangles = zef_triangles_2_sensor_boundary(zef,strip_struct.compartment_tag,triangles);

end