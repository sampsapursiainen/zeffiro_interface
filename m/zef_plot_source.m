%Copyright © 2018, Sampsa Pursiainen
function h_synth_source = zef_plot_source
source_positions = evalin('base','zef.source_positions');
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
s_o = repmat(s_length,1,3).*s_o;
h_axes1 = evalin('base','zef.h_axes1');
hold(h_axes1,'on');
h_synth_source = zeros(size(s_p,1),1);
for i = 1 : size(s_p,1)
[s_min,s_ind] = min(sqrt(sum((source_positions - repmat(s_p(i,:),size(source_positions,1),1)).^2,2)));
h_synth_source(i) = quiver3(h_axes1,s_p(i,1),s_p(i,2),s_p(i,3),s_length*s_o(i,1),s_length*s_o(i,2),s_length*s_o(i,3), 0, 'linewidth',s_width,'color',source_color,'marker','o');
end
hold(h_axes1,'off');

end
