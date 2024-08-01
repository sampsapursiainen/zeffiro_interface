function points = zef_strip_coordinate_transform(strip_struct,transform_type) 

 if isequal(transform_type,'reverse') 
    points{1} = strip_struct.points{1} - strip_struct.tip_point';
     points{2} = strip_struct.points{2} - - strip_struct.tip_point' - strip_struct.encapsulation_shift';
 end

for i = 1 : 2

x_aux = strip_struct.orientation_axis{i}(:,ones(1,size(strip_struct.points{i},1)));
    x_aux = sum(strip_struct.points{i}'.*x_aux);
    y_aux = strip_struct.orientation_axis_normal{i}(:,ones(1,size(strip_struct.points{i},1)));
    y_aux = sum(strip_struct.points{i}'.*y_aux);
    z_aux = strip_struct.rotation_axis{i}(:,ones(1,size(strip_struct.points{i},1)));
    z_aux = sum(strip_struct.points{i}'.*z_aux);

if i == 1


 if isequal(transform_type,'forward')
R_1 = [1 0 0; 0 cos(strip_struct.strip_angle) -sin(strip_struct.strip_angle) ; 0 sin(strip_struct.strip_angle) cos(strip_struct.strip_angle)];
elseif isequal(transform_type,'reverse') 
R_1 = [1 0 0; 0 cos(strip_struct.strip_angle) sin(strip_struct.strip_angle) ; 0 -sin(strip_struct.strip_angle) cos(strip_struct.strip_angle)]; 
 end

   points{1} = (R_1*[x_aux; y_aux; z_aux])';

   points{1} = points{1}(:,1)*strip_struct.orientation_axis{1}' + points{1}(:,2)*strip_struct.orientation_axis_normal{1}' + points{1}(:,3)*strip_struct.rotation_axis{1}';

end

   R_2 = [cos(strip_struct.rotation_angle{i}) -sin(strip_struct.rotation_angle{i}) 0; sin(strip_struct.rotation_angle{i}) cos(strip_struct.rotation_angle{i}) 0 ; 0 0 1];

   points{i} = (R_2*[x_aux; y_aux; z_aux])';

   points{i} = points{i}(:,1)*strip_struct.orientation_axis{i}' + points{i}(:,2)*strip_struct.orientation_axis_normal{i}' + points{i}(:,3)*strip_struct.rotation_axis{i}';
end

   if isequal(transform_type,'forward')
    points{1} =  points{1} + strip_struct.tip_point';
     points{2} =  points{2} + strip_struct.tip_point' + strip_struct.encapsulation_shift';
   end




end