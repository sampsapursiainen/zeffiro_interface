%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
function h_source = zef_plot_source(source_type)

if source_type == 1
h_axes1 = evalin('base','zef.h_axes1');
if isfield(evalin('base','zef'),'h_synth_source')
h_synth_source = evalin('base','zef.h_synth_source');
if ishandle(h_synth_source)
delete(h_synth_source)
end
end
s_width = 3;
color_cell = {'k','r','g','b','y','m','c'};
s_length = evalin('base','zef.inv_synth_source(:,9)');
source_color = color_cell(evalin('base','zef.inv_synth_source(:,10)'));
s_p = evalin('base','zef.inv_synth_source(:,1:3)');
s_o = evalin('base','zef.inv_synth_source(:,4:6)');
s_o = s_o./repmat(sqrt(sum(s_o.^2,2)),1,3);
s_a = evalin('base','zef.inv_synth_source(:,7)');
s_a = sqrt(s_a./max(s_a));
s_o = repmat(s_a,1,3).*s_o;
s_o = repmat(s_length,1,3).*s_o;
h_axes1 = evalin('base','zef.h_axes1');
zef_plot_meshes([]);
hold(h_axes1,'on');
h_synth_source = zeros(size(s_p,1),1);
for i = 1 : size(s_p,1)
h_synth_source(i) = quiver3(h_axes1,s_p(i,1),s_p(i,2),s_p(i,3),s_length(i)*s_o(i,1),s_length(i)*s_o(i,2),s_length(i)*s_o(i,3), 0, 'linewidth',s_width,'color',source_color{i},'marker','o');
end
x_scale = h_axes1.XAxis.TickValues(2) - h_axes1.XAxis.TickValues(1);
y_scale = h_axes1.YAxis.TickValues(2) - h_axes1.YAxis.TickValues(1);
z_scale = h_axes1.ZAxis.TickValues(2) - h_axes1.ZAxis.TickValues(1);
h_axes1.XAxis.TickValues = [floor(h_axes1.XAxis.Limits(1)/x_scale):ceil(h_axes1.XAxis.Limits(2)/x_scale)]*x_scale;
h_axes1.YAxis.TickValues = [floor(h_axes1.YAxis.Limits(1)/y_scale):ceil(h_axes1.YAxis.Limits(2)/y_scale)]*y_scale;
h_axes1.ZAxis.TickValues = [floor(h_axes1.ZAxis.Limits(1)/z_scale):ceil(h_axes1.ZAxis.Limits(2)/z_scale)]*z_scale;
h_axes1.XAxis.TickLabels = num2cell(h_axes1.XAxis.TickValues);
h_axes1.YAxis.TickLabels = num2cell(h_axes1.YAxis.TickValues);
h_axes1.ZAxis.TickLabels = num2cell(h_axes1.ZAxis.TickValues);

hold(h_axes1,'off');
h_source = h_synth_source;
else
h_axes1 = evalin('base','zef.h_axes1');
if isfield(evalin('base','zef'),'h_rec_source')
h_rec_source = evalin('base','zef.h_rec_source');
if ishandle(h_rec_source)
delete(h_rec_source)
end
end
s_width = 3;
color_cell = {'k','r','g','b','y','m','c'};
s_length = evalin('base','zef.inv_rec_source(1,8)');
source_color = color_cell{evalin('base','zef.inv_rec_source(1,9)')};
s_p = evalin('base','zef.inv_rec_source(:,1:3)');
s_o = evalin('base','zef.inv_rec_source(:,4:6)');
s_o = s_o./repmat(sqrt(sum(s_o.^2,2)),1,3);
s_a = evalin('base','zef.inv_rec_source(:,7)');
s_a = sqrt(s_a./max(s_a));
s_o = repmat(s_a,1,3).*s_o;
s_o = repmat(s_length,1,3).*s_o;
h_axes1 = evalin('base','zef.h_axes1');
hold(h_axes1,'on');
h_rec_source = zeros(size(s_p,1),1);
for i = 1 : size(s_p,1)
h_rec_source(i) = quiver3(h_axes1,s_p(i,1),s_p(i,2),s_p(i,3),s_length*s_o(i,1),s_length*s_o(i,2),s_length*s_o(i,3), 0, 'linewidth',s_width,'color',source_color,'marker','o');
end
x_scale = h_axes1.XAxis.TickValues(2) - h_axes1.XAxis.TickValues(1);
y_scale = h_axes1.YAxis.TickValues(2) - h_axes1.YAxis.TickValues(1);
z_scale = h_axes1.ZAxis.TickValues(2) - h_axes1.ZAxis.TickValues(1);
h_axes1.XAxis.TickValues = [floor(h_axes1.XAxis.Limits(1)/x_scale):ceil(h_axes1.XAxis.Limits(2)/x_scale)]*x_scale;
h_axes1.YAxis.TickValues = [floor(h_axes1.YAxis.Limits(1)/y_scale):ceil(h_axes1.YAxis.Limits(2)/y_scale)]*y_scale;
h_axes1.ZAxis.TickValues = [floor(h_axes1.ZAxis.Limits(1)/z_scale):ceil(h_axes1.ZAxis.Limits(2)/z_scale)]*z_scale;
h_axes1.XAxis.TickLabels = num2cell(h_axes1.XAxis.TickValues);
h_axes1.YAxis.TickLabels = num2cell(h_axes1.YAxis.TickValues);
h_axes1.ZAxis.TickLabels = num2cell(h_axes1.ZAxis.TickValues);

hold(h_axes1,'off');
h_source = h_rec_source;
end
end
