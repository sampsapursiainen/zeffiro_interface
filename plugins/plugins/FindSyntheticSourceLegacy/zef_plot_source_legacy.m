%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
function h_source = zef_plot_source(zef, source_type)


arrow_scale = 1;
arrow_type = 1;
arrow_color = 0.5*[1 1 1]; 
arrow_shape = 10; 
arrow_length = 1; 
arrow_head_size = 2; 
arrow_n_polygons = 100;

if source_type == 1
h_axes1 = eval('zef.h_axes1');
if isfield(eval('zef'),'h_synth_source')
h_synth_source = eval('zef.h_synth_source');
if ishandle(h_synth_source)
delete(h_synth_source)
end
end
s_width = 3;
color_cell = {'k','r','g','b','y','m','c'};
s_length = eval('zef.inv_synth_source(1,9)');
source_color = color_cell{eval('zef.inv_synth_source(1,10)')};
s_p = eval('zef.inv_synth_source(:,1:3)');
s_o = eval('zef.inv_synth_source(:,4:6)');
s_o = s_o./repmat(sqrt(sum(s_o.^2,2)),1,3);
s_a = eval('zef.inv_synth_source(:,7)');
s_a = sqrt(s_a./max(s_a));
s_o = repmat(s_a,1,3).*s_o;
s_o = repmat(s_length,1,3).*s_o;
h_axes1 = eval('zef.h_axes1');
hold(h_axes1,'on');
h_synth_source = zeros(size(s_p,1),1);
axes(h_axes1)
arrow_scale = 3*sqrt(s_length);
for i = 1 : size(s_p,1)
%h_synth_source(i) = quiver3(h_axes1,s_p(i,1),s_p(i,2),s_p(i,3),s_length*s_o(i,1),s_length*s_o(i,2),s_length*s_o(i,3), 0, 'linewidth',s_width,'color',source_color,'marker','o');
h_synth_source(i) = zef_plot_3D_arrow(s_p(i,1),s_p(i,2),s_p(i,3),s_o(i,1),s_o(i,2),s_o(i,3),arrow_scale,arrow_type,source_color,arrow_shape,arrow_length,arrow_head_size,arrow_n_polygons);
set(h_synth_source(i),'Tag','additional: synthetic source');
end
hold(h_axes1,'off');
h_source = h_synth_source;
else
h_axes1 = eval('zef.h_axes1');
if isfield(eval('zef'),'h_rec_source')
h_rec_source = eval('zef.h_rec_source');
if ishandle(h_rec_source)
delete(h_rec_source)
end
end
s_width = 3;
color_cell = {'k','r','g','b','y','m','c'};
s_length = eval('zef.inv_rec_source(1,8)');
source_color = color_cell{eval('zef.inv_rec_source(1,9)')};
s_p = eval('zef.inv_rec_source(:,1:3)');
s_o = eval('zef.inv_rec_source(:,4:6)');
s_o = s_o./repmat(sqrt(sum(s_o.^2,2)),1,3);
s_a = eval('zef.inv_rec_source(:,7)');
s_a = sqrt(s_a./max(s_a));
s_o = repmat(s_a,1,3).*s_o;
s_o = repmat(s_length,1,3).*s_o;
h_axes1 = eval('zef.h_axes1');
hold(h_axes1,'on');
h_rec_source = zeros(size(s_p,1),1);
for i = 1 : size(s_p,1)
h_rec_source(i) = quiver3(h_axes1,s_p(i,1),s_p(i,2),s_p(i,3),s_length*s_o(i,1),s_length*s_o(i,2),s_length*s_o(i,3), 0, 'linewidth',s_width,'color',source_color,'marker','o');
end
hold(h_axes1,'off');
h_source = h_rec_source;
end
end
