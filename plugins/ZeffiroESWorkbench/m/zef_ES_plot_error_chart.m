function [h_colorbar_ES] = zef_ES_plot_error_chart

figure('Name','ZEFFIRO Interface: Error chart tool','NumberTitle','off', ...
    'ToolBar','figure','MenuBar','none');

if evalin('base','zef.ES_current_threshold_checkbox') == 0
    y_ES          = evalin('base','zef.y_ES_interval.y_ES');
    residual      = evalin('base','zef.y_ES_interval.residual');
    tolerance_aux = evalin('base','zef.y_ES_interval.optimizer_tolerance');
    reg_param_aux = evalin('base','zef.y_ES_interval.reg_param');
else
    y_ES          = evalin('base','zef.y_ES_interval_threshold.y_ES');
    residual      = evalin('base','zef.y_ES_interval_threshold.residual');
    tolerance_aux = evalin('base','zef.y_ES_interval_threshold.optimizer_tolerance');
    reg_param_aux = evalin('base','zef.y_ES_interval_threshold.reg_param');
end

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
set(gca, 'YTick', 1:length(tolerance_aux));
set(gca, 'YTicklabel', tolerance_aux);
xtickangle(90);
xlabel('Regularization parameter');
ylabel('Optimizer tolerance');

hold on;
for i = 1:length(tolerance_aux)
    for j = 1:length(reg_param_aux)
        plot(j,i,'k.','MarkerFaceColor','none','MarkerSize',3);
    end
end
[c, r] = find(C == min(C(C>0),[],'all'),1,'first');
plot(r,c,'yp','MarkerFaceColor','yellow','MarkerSize',10);
hold off;

h_colorbar_ES = [h_axes; h_colorbar_ES];
end