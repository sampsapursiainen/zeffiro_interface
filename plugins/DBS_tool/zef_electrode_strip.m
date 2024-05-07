function strip_struct = zef_electrode_strip(position, orientation)

orientation = 1/norm(orientation)*orientation;
center_point = position + 4*orientation;

dir_vec = 1/norm(orientation)*orientation;
strip_struct = struct;
strip_struct.center_point = center_point;
strip_struct.radius = 0.635;
strip_struct.dir_vec = dir_vec;
strip_struct.type = 'point';
strip_struct.ele_sep = 45;
strip_struct.ele_dist = 1.5;
strip_struct.impedance = 1200;

strip_dir = strip_struct.dir_vec;
n_strip_dir_1 = cross(strip_dir, [0 0 1]);
n_strip_dir_1 = 1/norm(n_strip_dir_1)*n_strip_dir_1;
rotation_axis = strip_dir;

j = 1;

n_rot = 360/strip_struct.ele_sep;


for k = 1 : 8

    if mod(k,2) == 0

        for i = 0 : 4

            R = [cosd(k*strip_struct.ele_sep)+rotation_axis(1)^2*(1-cosd(k*strip_struct.ele_sep)) rotation_axis(1)*rotation_axis(2)*(1-cosd(k*strip_struct.ele_sep))-rotation_axis(3)*sind(k*strip_struct.ele_sep) rotation_axis(1)*rotation_axis(3)*(1-cosd(k*strip_struct.ele_sep))+rotation_axis(2)*sind(k*strip_struct.ele_sep); rotation_axis(2)*rotation_axis(1)*(1-cosd(k*strip_struct.ele_sep))+rotation_axis(3)*sind(k*strip_struct.ele_sep) cosd(k*strip_struct.ele_sep)+rotation_axis(2)^2*(1-cosd(k*strip_struct.ele_sep)) rotation_axis(2)*rotation_axis(3)*(1-cosd(k*strip_struct.ele_sep))-rotation_axis(1)*sind(k*strip_struct.ele_sep); rotation_axis(3)*rotation_axis(1)*(1-cosd(k*strip_struct.ele_sep))-rotation_axis(2)*sind(k*strip_struct.ele_sep) rotation_axis(3)*rotation_axis(2)*(1-cosd(k*strip_struct.ele_sep))+rotation_axis(1)*sind(k*strip_struct.ele_sep) -1*cosd(k*strip_struct.ele_sep)+rotation_axis(3)^2*(1-cosd(k*strip_struct.ele_sep))];

            strip_struct.electrode(j,:) = strip_struct.center_point+3.375*strip_dir-i*strip_struct.ele_dist*strip_dir+(R*(strip_struct.radius*n_strip_dir_1)')';

            j = j + 1;
        end

    else

        for i = 0 : 4

            R = [cosd(k*strip_struct.ele_sep)+rotation_axis(1)^2*(1-cosd(k*strip_struct.ele_sep)) rotation_axis(1)*rotation_axis(2)*(1-cosd(k*strip_struct.ele_sep))-rotation_axis(3)*sind(k*strip_struct.ele_sep) rotation_axis(1)*rotation_axis(3)*(1-cosd(k*strip_struct.ele_sep))+rotation_axis(2)*sind(k*strip_struct.ele_sep); rotation_axis(2)*rotation_axis(1)*(1-cosd(k*strip_struct.ele_sep))+rotation_axis(3)*sind(k*strip_struct.ele_sep) cosd(k*strip_struct.ele_sep)+rotation_axis(2)^2*(1-cosd(k*strip_struct.ele_sep)) rotation_axis(2)*rotation_axis(3)*(1-cosd(k*strip_struct.ele_sep))-rotation_axis(1)*sind(k*strip_struct.ele_sep); rotation_axis(3)*rotation_axis(1)*(1-cosd(k*strip_struct.ele_sep))-rotation_axis(2)*sind(k*strip_struct.ele_sep) rotation_axis(3)*rotation_axis(2)*(1-cosd(k*strip_struct.ele_sep))+rotation_axis(1)*sind(k*strip_struct.ele_sep) -1*cosd(k*strip_struct.ele_sep)+rotation_axis(3)^2*(1-cosd(k*strip_struct.ele_sep))];

            strip_struct.electrode(j,:) = strip_struct.center_point+2.625*strip_dir-i*strip_struct.ele_dist*strip_dir+(R*(strip_struct.radius*n_strip_dir_1)')';

            j = j + 1;

        end
    end

end

%hold on
electrode_data = zeros(40,6);
electrode_data(:,1) = strip_struct.electrode(:,1);
electrode_data(:,2) = strip_struct.electrode(:,2);
electrode_data(:,3) = strip_struct.electrode(:,3);
%electrode_data(:,4) = ones(40,1);
electrode_data(:,6) = strip_struct.impedance*ones(40,1);
strip_struct.electrode_data = electrode_data;

%save medtronic_sapiens.dat electrode_data -ascii

cylinder_radius = 0.635;
mesh_resolution =0.25;
n_refinements = 6;
length = 120;
probe = struct;
probe.radius = strip_struct.radius;

theta = 90+asind(orientation(3)/norm(orientation));

cylinder_edge_size = mesh_resolution/2^n_refinements;
n_cylinder_edges = cylinder_radius*2*pi/cylinder_edge_size;

[x y z]=cylinder(probe.radius,1000);

z = z*length;
tri = delaunay(x(:),y(:),z(:));
TR = triangulation(tri,[x(:) y(:) z(:)]);

tri = freeBoundary(TR);

p.vertices = [x(:),y(:),z(:)];

p.faces = tri;

p = reducepatch(p,n_cylinder_edges);

rotation_axis = cross([0 0 1], orientation);
rotation_axis = 1/norm(rotation_axis)*rotation_axis;



for i = 1:size(p.vertices(:,1))
    R = [cosd(theta)+rotation_axis(1)^2*(1-cosd(theta)) rotation_axis(1)*rotation_axis(2)*(1-cosd(theta))-rotation_axis(3)*sind(theta) rotation_axis(1)*rotation_axis(3)*(1-cosd(theta))+rotation_axis(2)*sind(theta); rotation_axis(2)*rotation_axis(1)*(1-cosd(theta))+rotation_axis(3)*sind(theta) cosd(theta)+rotation_axis(2)^2*(1-cosd(theta)) rotation_axis(2)*rotation_axis(3)*(1-cosd(theta))-rotation_axis(1)*sind(theta); rotation_axis(3)*rotation_axis(1)*(1-cosd(theta))-rotation_axis(2)*sind(theta) rotation_axis(3)*rotation_axis(2)*(1-cosd(theta))+rotation_axis(1)*sind(theta) -1*cosd(theta)+rotation_axis(3)^2*(1-cosd(theta))];
    p.vertices(i,:) = (R*p.vertices(i,:)')';

end

for i = 1:size(p.vertices(:,1))
    p.vertices(i,:) = position + p.vertices(i,:);
end

strip_struct.faces = p.faces;

strip_struct.vertices = p.vertices;


end
