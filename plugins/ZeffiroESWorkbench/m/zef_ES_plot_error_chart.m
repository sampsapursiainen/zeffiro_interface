function zef_ES_plot_error_chart(varargin)
if nargin == 0
    zef = evalin('base','zef');
else
    zef = varargin{1};
end
%% Variables and parameters setup
vec = zef_ES_table(zef);
[sr, sc] = zef_ES_objective_function(zef);
%% Figure & Axes
n_chart = 1 + length(findall(groot,'-regexp','Name','ZEFFIRO Interface: Error chart*'));
h_fig = figure('Name',['ZEFFIRO Interface: Error chart ' num2str(n_chart)], ...
    'NumberTitle','off', ...
    'ToolBar','none', ...
    'MenuBar','none');
try
    pos_aux = findall(groot,'Name','ZEFFIRO Interface: ES Workbench').Position;
    set(h_fig,'Position',[pos_aux(1) pos_aux(2) 800 600]);
catch
    movegui(h_fig,'center')
end
pbaspect([1 1 1])
%% Tab properties & plotting
h = uitabgroup();
tab_titles = [{'Current pattern'}; {'Volume current'}; {'Algorithm'}];
fieldnames_table    = {};
fieldnames_table{1} = fieldnames(vec(:, [ 3  2  4  10]));
fieldnames_table{2} = fieldnames(vec(:, [ 5  7  9  6]));
fieldnames_table{3} = fieldnames(vec(:, [11 14]));

for i_idx = 1:3
    fieldnames_table{i_idx} = fieldnames_table{i_idx}(1:end-3);
    tabs_aux = uitab(h, 'title', tab_titles{i_idx});
    axes('parent', tabs_aux);

    for w = 1:length(fieldnames_table{i_idx})
        subplot(2,2,w);
        printing_imagesc(vec, fieldnames_table{i_idx}{w}, sr, sc);
    end
end
%% Wrapping up, functions and return of variables
    function printing_imagesc(vec, fieldnames_table, sr, sc)
        % This function prepares the image with scaled color

        imagesc(vec.(fieldnames_table){:});
        %h_f.ButtonDownFcn = @(s,e) assignin('base', 'xy_click', [round(e.IntersectionPoint(1)), round(e.IntersectionPoint(2))]);
        colormap(gca, turbo(2048));
        pbaspect([1 1 1])

        ax = gca;
        ax.XLabel.String       = 'Alpha parameter (dB)';
        ax.XLabel.FontSize     = 10;
        ax.XLabel.FontWeight   = 'bold';
        ax.XTickLabel          = {num2str((vec.('Alpha'){:}),'%1.0f')};
        ax.XTick               = 1:length(vec.('Alpha'){:});
        ax.XTickLabelRotation  = 90;

        ax.YLabel.String       = 'Nuisance field weight (dB)';
        ax.YLabel.FontSize     = 10;
        ax.YLabel.FontWeight   = 'bold';
        ax.YTickLabel          = {num2str((vec.('Beta'){:}),'%1.0f')};
        ax.YTick               = 1:length(vec.('Beta'){:});
        ax.YTickLabelRotation  = 0;

        %%% Colorbar TickLabels
        cb = colorbar;
        colormap(cb, turbo(2048))
        cb_num_ticks = 5;           % numbers of ticks in the colorbar
        T = linspace(cb.Limits(1), cb.Limits(2), cb_num_ticks);
        cb.Ticks = T;
        if     contains(fieldnames_table, 'Total dose')
            TL = arrayfun(@(x) sprintf('%1.3e', x), T, 'un', 0);
        elseif contains(fieldnames_table, 'Maximum current')
            TL = arrayfun(@(x) sprintf('%1.3e', x), T, 'un', 0);
        elseif contains(fieldnames_table, 'Angle error')
            TL = arrayfun(@(x) sprintf('%3.3f', x), T, 'un', 0);
        elseif contains(fieldnames_table, 'Relative magnitude error')
            TL = arrayfun(@(x) sprintf('%1.3f', x), T, 'un', 0);
        else
            TL = arrayfun(@(x) sprintf('%1.3f', x), T, 'un', 0);
        end
        set(cb, 'TickLabels', TL);

        %%% Legend
        hold on;
        plot(ax, sc, sr, 'yp','MarkerFaceColor','y','MarkerEdgeColor','k','MarkerSize',12);
        plot(ax, sc, sr, 'yp','MarkerFaceColor','w','MarkerEdgeColor','w','MarkerSize',12);
        lgd = legend('Location','SouthWest', 'FontName', 'FixedWidth');
        lgd.String(1) = {['\alpha : '   num2str((vec.('Alpha'){:}(sc)), '%1.0f')]};
        lgd.String(2) = {['\epsilon : ' num2str((vec.('Beta'){:}(sr)), '%1.0f')]};
        lgd.AutoUpdate = 'off';
        plot(ax, sc, sr, 'yp','MarkerFaceColor','y','MarkerEdgeColor','k','MarkerSize',12);

        %%% Grid
        grid on
        ax.GridAlpha = 0.3;
        ax.GridColor = [0.3 0.3 0.3];

        hold off
        title(fieldnames_table);
    end

h_fig.Visible = zef.use_display;
zef.h_ES_error_chart = h_fig;

end