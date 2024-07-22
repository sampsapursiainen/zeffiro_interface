function points = zef_strip_coordinate_transform(strip_struct,transform_type) 

x_aux = strip_struct.orientation_axis(:,ones(1,size(strip_struct.points,1)));
    x_aux = sum(strip_struct.points'.*x_aux);
    y_aux = strip_struct.orientation_axis_normal(:,ones(1,size(strip_struct.points,1)));
    y_aux = sum(strip_struct.points'.*y_aux);
    z_aux = strip_struct.rotation_axis(:,ones(1,size(strip_struct.points,1)));
    z_aux = sum(strip_struct.points'.*z_aux);

   R = [cos(strip_struct.rotation_angle) -sin(strip_struct.rotation_angle); cos(strip_struct.rotation_angle) sin(strip_struct.rotation_angle)];
   
   if isequal(transform_type,'forward')
   aux_mat = R*[x_aux; y_aux];
    points = [aux_mat; z_aux]';
    points =  points + strip_struct.tip_point';
   elseif isequal(transform_type,'reverse') 
    points = strip_struct.points + strip_struct.tip_point';
       aux_mat = R'*[x_aux; y_aux];
    points = [aux_mat; z_aux]';
   end

end