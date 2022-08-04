function zef_ES_plot_error_chart(varargin)
%% Variables and parameters setup
h_dial = helpdlg('Plotting data...','ZI: Help');
switch nargin
    case 0
        vec = zef_ES_table;
    case 1
        vec = varargin{1};
    otherwise
        error('Invalid number of arguments inserted.')
end
%% Figure and Axes
f = figure('Name','ZEFFIRO Interface: Error chart', ...
    'NumberTitle','off', ...
    'ToolBar','none', ...
    'MenuBar','none');
pos_aux = findall(groot,'Name','ZEFFIRO Interface: ES Workbench').Position;
set(f,'Position',[pos_aux(1) pos_aux(2) 800 600]);
pbaspect([1 1 1])
%% Tab properties
h = uitabgroup();
tab_titles = [{'Current pattern'}; {'Volume current'}];
fieldnames_table = {};
fieldnames_table{1} = fieldnames(vec(:,1:4));
fieldnames_table{2} = fieldnames(vec(:,[5:7,9]));

for i_idx = 1:2
    tabs_aux = uitab(h, 'title', tab_titles{i_idx});
    axes('parent', tabs_aux);
    for w = 1:4
        printing_imagesc(vec, w, fieldnames_table{i_idx});
    end
end
%% Wrapping up, functions and return of variables
    function printing_imagesc(vec, w, fieldnames_table, varargin)
        [sr, sc] = zef_ES_objective_function(vec);
        subplot(2,2,w)
        imagesc(vec.(fieldnames_table{w}){1,1});
        colormap(gca, turbo(2048));
        pbaspect([1 1 1])
        
        ax = gca;
        ax.XLabel.String       = 'Alpha parameter (dB)';
        ax.XLabel.FontSize     = 10;
        ax.XLabel.FontWeight   = 'bold';
        ax.XTickLabel          = {num2str(db(vec.('Alpha'){:}),'%1.0f')};
        ax.XTick               = 1:length(vec.('Alpha'){:});
        ax.XTickLabelRotation  = 90;
        
        ax.YLabel.String       = 'Nuisance field weight (dB)';
        ax.YLabel.FontSize     = 10;
        ax.YLabel.FontWeight   = 'bold';
        ax.YTickLabel          = {num2str(db(vec.('Beta'){:}),'%1.0f')};
        ax.YTick               = 1:length(vec.('Beta'){:});
        ax.YTickLabelRotation  = 0;
        
        %%% Colorbar
        cb = colorbar;
        colormap(cb, turbo(2048))
        %         if strcmp(fieldnames_table{w}, 'Total dose')
        %             ax.ColorScale = 'log';
        %             cb.Ruler.TickLabelFormat = '%1.3f';
        %         else
        %             ax.ColorScale = 'linear';
        %         end
        
        t = cb.Limits;
        T = linspace(t(1), t(2), 5); %% 5= five numbers in the colorbar
        cb.Ticks = T;
        
        if         strcmp(fieldnames_table{w}, 'Total dose')
            TL = arrayfun(@(x) sprintf('%1.1e', x), T, 'un', 0);
        elseif strcmp(fieldnames_table{w}, 'Maximum current (A)')
            TL = arrayfun(@(x) sprintf('%1.1e', x), T, 'un', 0);
        elseif     strcmp(fieldnames_table{w}, 'Angle error (deg)')
            TL = arrayfun(@(x) sprintf('%3.2f', x), T, 'un', 0);
        elseif     strcmp(fieldnames_table{w}, 'Relative magnitude error')
            TL = arrayfun(@(x) sprintf('%1.4f', x), T, 'un', 0);
        else
            TL = arrayfun(@(x) sprintf('%1.2f', x), T, 'un', 0);
        end
        set(cb, 'TickLabels', TL);
        
        %%% Legend
        hold on;
        plot(sc, sr, 'yp','MarkerFaceColor','y','MarkerEdgeColor','k','MarkerSize',12);
        plot(sc, sr, 'yp','MarkerFaceColor','w','MarkerEdgeColor','w','MarkerSize',12);
        lgd = legend('Location','SouthWest', 'FontName', 'FixedWidth');
        lgd.String(1) = {['\alpha : ' num2str(db(vec.('Alpha'){:,:}(sc)), '%1.0f')]};
        lgd.String(2) = {['\epsilon : ' num2str(db(vec.('Alpha'){:,:}(sr)), '%1.0f')]};
        lgd.AutoUpdate = 'off';
        plot(sc, sr, 'yp','MarkerFaceColor','y','MarkerEdgeColor','k','MarkerSize',12);
        
        grid on
        ax.GridAlpha = 0.3;
        ax.GridColor = [0.3 0.3 0.3];
        
        hold off
        title(fieldnames_table(w));
    end
close(h_dial)
end