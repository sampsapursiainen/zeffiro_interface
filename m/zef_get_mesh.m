function [mesh_data] = zef_get_mesh(file_str,field_id,file_type)

merge_on = evalin('base',['zef.' field_id '_merge']);
invert_on = evalin('base',['zef.' field_id '_invert']);

invert_on

if isequal(file_type,'points')

if merge_on    
l1_points = evalin('base',['zef.' field_id '_points']);
l2_points = load(file_str); 
mesh_data = [l1_points; l2_points];
else
mesh_data = load(file_str);
end

end

if isequal(file_type,'triangles')

if merge_on
l1_triangles = evalin('base',['zef.' field_id '_triangles']); 
l2_triangles = load(file_str);
if invert_on
    l2_triangles = l2_triangles(:,[2 1 3]);
end
if isempty(l1_triangles)
    max_val = 0;
else
    max_val = max(l1_triangles(:));
end
mesh_data = [l1_triangles; l2_triangles+max_val];
else
mesh_data = load(file_str);
if invert_on
    mesh_data = mesh_data(:,[2 1 3]);
end
end



end
    

end