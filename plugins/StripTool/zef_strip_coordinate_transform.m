function points = zef_strip_coordinate_transform(strip_struct,transform_type,points) 

    if nargin > 2
    points = mat2cell(points,1);
    strip_struct.points{1} = points{1};
    else
        points = strip_struct.points;
    end

    if isequal(transform_type,'reverse') 
    points{1} = points{1} - strip_struct.tip_point';
     
    if strip_struct.encapsulation_on
    points{2} = points{2} - strip_struct.tip_point' - strip_struct.encapsulation_shift';
    end
    end


    if nargin > 2
        n_iter = 1;
    else
    if strip_struct.encapsulation_on
    n_iter = 2;
    else
    n_iter = 1;
    end
    end

    for i = 1 : n_iter

    x_aux = strip_struct.orientation_axis{i}(:,ones(1,size(points{i},1)));
    x_aux = sum(points{i}'.*x_aux);
    y_aux = strip_struct.orientation_axis_normal{i}(:,ones(1,size(points{i},1)));
    y_aux = sum(points{i}'.*y_aux);
    z_aux = strip_struct.rotation_axis{i}(:,ones(1,size(points{i},1)));
    z_aux = sum(points{i}'.*z_aux);


    if isequal(transform_type,'forward')
    R_1 = [1 0 0; 0 cos(strip_struct.strip_angle) -sin(strip_struct.strip_angle) ; 0 sin(strip_struct.strip_angle) cos(strip_struct.strip_angle)];
    R_2 = [cos(strip_struct.rotation_angle{i}) -sin(strip_struct.rotation_angle{i}) 0; sin(strip_struct.rotation_angle{i}) cos(strip_struct.rotation_angle{i}) 0 ; 0 0 1];
   
   points_aux = R_1*[x_aux; y_aux; z_aux];
   x_aux = points_aux(1,:);
   y_aux = points_aux(2,:);
   z_aux = points_aux(3,:);
   points_aux = R_2*[x_aux; y_aux; z_aux];
   x_aux = points_aux(1,:);
   y_aux = points_aux(2,:);
   z_aux = points_aux(3,:);
   points{i} = x_aux'*strip_struct.orientation_axis{1}' + y_aux'*strip_struct.orientation_axis_normal{1}' + z_aux'*strip_struct.rotation_axis{1}';

    elseif isequal(transform_type,'reverse') 
    R_1 = [1 0 0; 0 cos(strip_struct.strip_angle) sin(strip_struct.strip_angle) ; 0 -sin(strip_struct.strip_angle) cos(strip_struct.strip_angle)]; 
    R_2 = [cos(strip_struct.rotation_angle{i}) sin(strip_struct.rotation_angle{i}) 0; -sin(strip_struct.rotation_angle{i}) cos(strip_struct.rotation_angle{i}) 0 ; 0 0 1];
      
       points_aux = R_2*[x_aux; y_aux; z_aux];
   x_aux = points_aux(1,:);
   y_aux = points_aux(2,:);
   z_aux = points_aux(3,:);
       points_aux = R_1*[x_aux; y_aux; z_aux];
   x_aux = points_aux(1,:);
   y_aux = points_aux(2,:);
   z_aux = points_aux(3,:);
   points{i} = x_aux'*strip_struct.orientation_axis{1}' + y_aux'*strip_struct.orientation_axis_normal{1}' + z_aux'*strip_struct.rotation_axis{1}';

    end
    end

 
   if isequal(transform_type,'forward')
   points{1} =  points{1} + strip_struct.tip_point';
   if strip_struct.encapsulation_on && nargin <= 2
   points{2} =  points{2} + strip_struct.tip_point' + strip_struct.encapsulation_shift';
   end
   end

   if nargin > 2
   points = cell2mat(points);
   end

end