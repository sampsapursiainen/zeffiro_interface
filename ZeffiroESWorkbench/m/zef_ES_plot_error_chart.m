function [h_colorbar_ES] = zef_ES_plot_error_chart
f = figure(300);
set(f,'Name','ZEFFIRO Interface: Error chart tool')
set(f,'NumberTitle','off');
set(f,'ToolBar','figure');
set(f,'MenuBar','none');

if isfield(evalin('base','zef'),'h_colorbar_ES')
    h_synth_source = evalin('base','zef.h_colorbar_ES');
    if ishandle(h_synth_source)
        delete(h_synth_source)
    end
end

h_colorbar_ES = findobj(evalin('base','zef.h_zeffiro'),'tag','ES_colorbar');
if not(isempty(h_colorbar_ES))
    colorbar(h_colorbar_ES,'delete');        
end

y_ES = evalin('base','zef.y_ES_interval.y_ES');
residual = evalin('base','zef.y_ES_interval.residual');
tolerance_aux = evalin('base','zef.y_ES_interval.optimizer_tolerance_range');
reg_param_aux = evalin('base','zef.y_ES_interval.reg_param_range');

A = zeros(size(y_ES,1),size(y_ES,2));
B = zeros(size(y_ES,1),size(y_ES,2));

for i = 1:size(y_ES,1)
    for j = 1:size(y_ES,2)
        A(i,j) = norm(cell2mat(y_ES(i,j)));
        B(i,j) = norm(cell2mat(residual(i,j)));
    end
end
C = B/max(abs(B(:))) + A/max(abs(A(:)));

h_axes = gca;
imagesc(C);
colormap('jet');
grid on;

h_colorbar_ES = colorbar;
set(h_colorbar_ES, 'ylim', [min(C(:)) max(C(:))]);

set(gca, 'XTick', 1:length(reg_param_aux));
set(gca, 'XTicklabel', reg_param_aux);
xtickangle(90);
xlabel('Regularization parameter');

set(gca, 'YTick', 1:length(tolerance_aux));
set(gca, 'YTicklabel', tolerance_aux);
ylabel('Optimizer tolerance');

h_colorbar_ES = [h_axes; h_colorbar_ES];
end