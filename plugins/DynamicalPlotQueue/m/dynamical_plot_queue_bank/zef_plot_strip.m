function zef_plot_strip(strip_struct)

hold on
if nargin == 0;
    strip_struct = evalin('caller','zef.strip_struct');
end

for i = 1:size(strip_struct.electrode,1)

    if i == 1 || i == 8
        r = 0.75
    else
        r = 0.35
    end

    [x y z] = sphere(20);

x = r*x;
y = r*y;
z = r*z;

    h_s = surf(strip_struct.electrode(i,1)+x,strip_struct.electrode(i,2)+y,strip_struct.electrode(i,3)+z);
    h_s.EdgeColor = 'none';
    h_s.Tag = 'additional: electrode strip';
    h_s.FaceColor = [1 0 0];
end

%xlabel('x')
%ylabel('y')
%zlabel('z')

h_axes = evalin('caller','h_axes_image');
axes(h_axes);


hold on
tri = strip_struct.faces{1};

x = strip_struct.vertices{1}(:,1);
y = strip_struct.vertices{1}(:,2);
z = strip_struct.vertices{1}(:,3);


h_t = trisurf(tri,x,y,z);
h_t.EdgeColor = 'none';
h_t.Tag = 'additional: electrode strip';
h_t.FaceColor = [0.6 0.6 0.6];

hold off
end
