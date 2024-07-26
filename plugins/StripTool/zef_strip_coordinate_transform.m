function points = zef_strip_coordinate_transform(strip_struct,transform_type) 

 if isequal(transform_type,'reverse') 
    points = strip_struct.points - strip_struct.tip_point';
end

x_aux = strip_struct.orientation_axis(:,ones(1,size(strip_struct.points,1)));
    x_aux = sum(strip_struct.points'.*x_aux);
    y_aux = strip_struct.orientation_axis_normal(:,ones(1,size(strip_struct.points,1)));
    y_aux = sum(strip_struct.points'.*y_aux);
    z_aux = strip_struct.rotation_axis(:,ones(1,size(strip_struct.points,1)));
    z_aux = sum(strip_struct.points'.*z_aux);

 if isequal(transform_type,'forward')
R_1 = [1 0 0; 0 cos(strip_struct.rotation_angle) -sin(strip_struct.rotation_angle) ; 0 sin(strip_struct.rotation_angle) cos(strip_struct.rotation_angle)];
elseif isequal(transform_type,'reverse') 
R_1 = [1 0 0; 0 cos(strip_struct.rotation_angle) sin(strip_struct.rotation_angle) ; 0 -sin(strip_struct.rotation_angle) cos(strip_struct.rotation_angle)]; 
 end

   points = (R_1*[x_aux; y_aux; z_aux])';

   points = points(:,1)*strip_struct.orientation_axis' + points(:,2)*strip_struct.orientation_axis_normal' + points(:,3)*strip_struct.rotation_axis';


   R_2 = [cos(strip_struct.rotation_angle) -sin(strip_struct.rotation_angle) 0; sin(strip_struct.rotation_angle) cos(strip_struct.rotation_angle) 0 ; 0 0 1];

   points = (R_2*[x_aux; y_aux; z_aux])';

   points = points(:,1)*strip_struct.orientation_axis' + points(:,2)*strip_struct.orientation_axis_normal' + points(:,3)*strip_struct.rotation_axis';

   if isequal(transform_type,'forward')
    points =  points + strip_struct.tip_point';
   end




end