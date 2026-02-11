function zef_plot_outPub(outPub, pass, nodeFilter)
    if nargin < 2, pass = 1; end
    if nargin < 3, nodeFilter = ""; end

zef = evalin('base','zef');
axes(zef.h_axes1); cla;
   hold on; grid on;
    labels = {};
    y_aux = [];
    for k = 1:numel(outPub.nodes)
        path = string(outPub.nodes(k).path);
        if nodeFilter ~= "" && ~contains(path, nodeFilter, 'IgnoreCase', true)
            continue;
        end
        y = outPub.nodes(k).upAbsByPass(:,pass);
       y_aux = [y_aux; y];
        plot(outPub.tAbs, y, 'LineWidth', 3);
        labels{end+1} = char(path); %#ok<AGROW>
    end
    legend(labels, 'Interpreter','none','Location','northeast','Orientation','vertical');
    xlabel('t (s)'); ylabel('Signal amplitude');
    set(zef.h_axes1,'ylim',1.1*[min(y_aux), max(y_aux)]);
    set(zef.h_axes1,'xlim',[min(outPub.tAbs) max(outPub.tAbs)]);
    pbaspect([2 1 1]);
    set(zef.h_axes1, 'linewidth',2)
end
