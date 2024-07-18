function zef = zef_electrode_strip_multiple_probe(zef)
clear strip_struct
orientation(1,:) = 1/norm(zef.strip_struct.dir_vec(1,:))*zef.strip_struct.dir_vec(1,:);
orientation(2,:) = 1/norm(zef.strip_struct.dir_vec(2,:))*zef.strip_struct.dir_vec(2,:);

position(1,:) = zef.strip_struct.center_point(1,:) - 4*zef.strip_struct.dir_vec(1,:);
position(2,:) = zef.strip_struct.center_point(2,:) - 4*zef.strip_struct.dir_vec(2,:);
zef.strip_struct.dir_vec(1,:) = 1/norm(zef.strip_struct.dir_vec(1,:))*zef.strip_struct.dir_vec(1,:);
zef.strip_struct.dir_vec(2,:) = 1/norm(zef.strip_struct.dir_vec(2,:))*zef.strip_struct.dir_vec(2,:);
strip_struct = struct;
strip_struct.probe_num = zef.strip_struct.probe_num;
strip_struct.center_point = zef.strip_struct.center_point;
strip_struct.radius = 0.635;
strip_struct.dir_vec = zef.strip_struct.dir_vec;
strip_struct.type = 'point';
strip_struct.ele_sep = 45;
strip_struct.ele_dist = 1.5;
strip_struct.impedance = 1200;
strip_struct.electrode_radius = 0.66;
for n=1:strip_struct.probe_num
    strip_dir = strip_struct.dir_vec;
    n_strip_dir_1(n,:) = cross(strip_dir(n,:), [0 0 1]);
    n_strip_dir_1(n,:) = 1/norm(n_strip_dir_1(n,:))*n_strip_dir_1(n,:);
    rotation_axis = strip_dir(n,:);

    j = 1;

    n_rot = 360/strip_struct.ele_sep;

    for k = 1 : 8

        if mod(k,2) == 0

            for i = 0 : 4

            R = [cosd(k*strip_struct.ele_sep)+rotation_axis(1)^2*(1-cosd(k*strip_struct.ele_sep)) rotation_axis(1)*rotation_axis(2)*(1-cosd(k*strip_struct.ele_sep))-rotation_axis(3)*sind(k*strip_struct.ele_sep) rotation_axis(1)*rotation_axis(3)*(1-cosd(k*strip_struct.ele_sep))+rotation_axis(2)*sind(k*strip_struct.ele_sep); rotation_axis(2)*rotation_axis(1)*(1-cosd(k*strip_struct.ele_sep))+rotation_axis(3)*sind(k*strip_struct.ele_sep) cosd(k*strip_struct.ele_sep)+rotation_axis(2)^2*(1-cosd(k*strip_struct.ele_sep)) rotation_axis(2)*rotation_axis(3)*(1-cosd(k*strip_struct.ele_sep))-rotation_axis(1)*sind(k*strip_struct.ele_sep); rotation_axis(3)*rotation_axis(1)*(1-cosd(k*strip_struct.ele_sep))-rotation_axis(2)*sind(k*strip_struct.ele_sep) rotation_axis(3)*rotation_axis(2)*(1-cosd(k*strip_struct.ele_sep))+rotation_axis(1)*sind(k*strip_struct.ele_sep) -1*cosd(k*strip_struct.ele_sep)+rotation_axis(3)^2*(1-cosd(k*strip_struct.ele_sep))];

            strip_struct.electrode(40*(n-1)+j,:) = strip_struct.center_point(n,:)+3.375*strip_dir(n,:)-i*strip_struct.ele_dist*strip_dir(n,:)+(R*(strip_struct.radius*n_strip_dir_1(n,:))')';

            j = j + 1;
            end

        else

            for i = 0 : 4

            R = [cosd(k*strip_struct.ele_sep)+rotation_axis(1)^2*(1-cosd(k*strip_struct.ele_sep)) rotation_axis(1)*rotation_axis(2)*(1-cosd(k*strip_struct.ele_sep))-rotation_axis(3)*sind(k*strip_struct.ele_sep) rotation_axis(1)*rotation_axis(3)*(1-cosd(k*strip_struct.ele_sep))+rotation_axis(2)*sind(k*strip_struct.ele_sep); rotation_axis(2)*rotation_axis(1)*(1-cosd(k*strip_struct.ele_sep))+rotation_axis(3)*sind(k*strip_struct.ele_sep) cosd(k*strip_struct.ele_sep)+rotation_axis(2)^2*(1-cosd(k*strip_struct.ele_sep)) rotation_axis(2)*rotation_axis(3)*(1-cosd(k*strip_struct.ele_sep))-rotation_axis(1)*sind(k*strip_struct.ele_sep); rotation_axis(3)*rotation_axis(1)*(1-cosd(k*strip_struct.ele_sep))-rotation_axis(2)*sind(k*strip_struct.ele_sep) rotation_axis(3)*rotation_axis(2)*(1-cosd(k*strip_struct.ele_sep))+rotation_axis(1)*sind(k*strip_struct.ele_sep) -1*cosd(k*strip_struct.ele_sep)+rotation_axis(3)^2*(1-cosd(k*strip_struct.ele_sep))];

            strip_struct.electrode(40*(n-1)+j,:) = strip_struct.center_point(n,:)+2.625*strip_dir(n,:)-i*strip_struct.ele_dist*strip_dir(n,:)+(R*(strip_struct.radius*n_strip_dir_1(n,:))')';

            j = j + 1;

            end
        end

    end

end

%hold on
electrode_data = zeros(40*strip_struct.probe_num,6);
electrode_data(:,1) = strip_struct.electrode(:,1);
electrode_data(:,2) = strip_struct.electrode(:,2);
electrode_data(:,3) = strip_struct.electrode(:,3);
%electrode_data(:,4) = ones(40,1);
electrode_data(:,6) = strip_struct.impedance*ones(40*strip_struct.probe_num,1);
strip_struct.electrode_data = electrode_data;

%save medtronic_sapiens.dat electrode_data -ascii

cylinder_radius = 0.635;
mesh_resolution =0.25;
n_refinements = 6;
length = 80;
probe = struct;
probe.radius = strip_struct.radius;

for n=1:strip_struct.probe_num
    theta = 90+asind(orientation(n,3)/norm(orientation(n,:)));

    cylinder_edge_size = mesh_resolution/2^n_refinements;
    n_cylinder_edges = cylinder_radius*2*pi/cylinder_edge_size;

    [x y z] = cylinder(probe.radius,1000);

    z = z*length;
    tri = delaunay(x(:),y(:),z(:));
    TR = triangulation(tri,[x(:) y(:) z(:)]);

    tri = freeBoundary(TR);

    p.vertices = [x(:),y(:),z(:)];

    p.faces = tri;

    p = reducepatch(p,n_cylinder_edges);

    rotation_axis = cross([0 0 1], orientation(n,:));
    rotation_axis = 1/norm(rotation_axis)*rotation_axis;

    for i = 1:size(p.vertices(:,1))
        R = [cosd(theta)+rotation_axis(1)^2*(1-cosd(theta)) rotation_axis(1)*rotation_axis(2)*(1-cosd(theta))-rotation_axis(3)*sind(theta) rotation_axis(1)*rotation_axis(3)*(1-cosd(theta))+rotation_axis(2)*sind(theta); rotation_axis(2)*rotation_axis(1)*(1-cosd(theta))+rotation_axis(3)*sind(theta) cosd(theta)+rotation_axis(2)^2*(1-cosd(theta)) rotation_axis(2)*rotation_axis(3)*(1-cosd(theta))-rotation_axis(1)*sind(theta); rotation_axis(3)*rotation_axis(1)*(1-cosd(theta))-rotation_axis(2)*sind(theta) rotation_axis(3)*rotation_axis(2)*(1-cosd(theta))+rotation_axis(1)*sind(theta) -1*cosd(theta)+rotation_axis(3)^2*(1-cosd(theta))];
        p.vertices(i,:) = (R*p.vertices(i,:)')';

    end

    for i = 1:size(p.vertices(:,1))
        p.vertices(i,:) = position(n,:) + p.vertices(i,:);
    end

    strip_struct.faces{n} = p.faces;

    strip_struct.vertices{n} = p.vertices;
end

clear zef.strip_struct;

zef.strip_struct = strip_struct;

end
