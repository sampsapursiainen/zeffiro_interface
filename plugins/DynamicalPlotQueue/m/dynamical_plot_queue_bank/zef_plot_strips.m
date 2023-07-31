function zef_plot_strips(strip_struct)

hold on
if nargin == 0;
    strip_struct = evalin('caller','zef.strip_struct');
end
haxes = evalin('caller','zef.h_axes1');
axes(haxes);
hold on
for i=1:strip_struct.probe_num
    
    tri1 = strip_struct.faces{i};
    
    x1 = strip_struct.vertices{i}(:,1);
    y1 = strip_struct.vertices{i}(:,2);
    z1 = strip_struct.vertices{i}(:,3);
    
    
    h_t1 = trisurf(tri1,x1,y1,z1);
    h_t1.EdgeColor = 'none';
    h_t1.Tag = 'additional: electrode strip';
    h_t1.FaceColor = [0.6 0.6 0.6];

end

hold off

end
