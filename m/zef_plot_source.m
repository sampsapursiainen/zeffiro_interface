%Copyright © 2018, Sampsa Pursiainen
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
s_length = evalin('base','zef.inv_synth_source(1,9)');
source_color = color_cell{evalin('base','zef.inv_synth_source(1,10)')};
s_p = evalin('base','zef.inv_synth_source(:,1:3)');
s_o = evalin('base','zef.inv_synth_source(:,4:6)');
s_o = s_o./repmat(sqrt(sum(s_o.^2,2)),1,3);
s_a = evalin('base','zef.inv_synth_source(:,7)');
s_a = sqrt(s_a./max(s_a));
s_o = repmat(s_a,1,3).*s_o;
s_o = repmat(s_length,1,3).*s_o;
h_axes1 = evalin('base','zef.h_axes1');
hold(h_axes1,'on');
h_synth_source = zeros(size(s_p,1),1);
for i = 1 : size(s_p,1)
h_synth_source(i) = quiver3(h_axes1,s_p(i,1),s_p(i,2),s_p(i,3),s_length*s_o(i,1),s_length*s_o(i,2),s_length*s_o(i,3), 0, 'linewidth',s_width,'color',source_color,'marker','o');
end
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
hold(h_axes1,'off');
h_source = h_rec_source;
end    
end
