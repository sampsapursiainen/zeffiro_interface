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
n_chart = 1 + length(findall(groot,'-regexp','Name','ZEFFIRO Interface: Error chart*'));
f = figure('Name',['ZEFFIRO Interface: Error chart ' num2str(n_chart) ', ' vec.Properties.Description], ...
    'NumberTitle','off', ...
    'ToolBar','none', ...
    'MenuBar','none');
pos_aux = findall(groot,'Name','ZEFFIRO Interface: ES Workbench').Position;
set(f,'Position',[pos_aux(1) pos_aux(2) 800 600]);
pbaspect([1 1 1])


%% Tab properties
h = uitabgroup();
tab_titles = [{'Current pattern'}; {'Volume current'}; {'Algorithm'}];
fieldnames_table = {};
fieldnames_table{1} = fieldnames(vec(:,[ 3  2   4   10]));
fieldnames_table{2} = fieldnames(vec(:,[ 5  7   9   6]));
fieldnames_table{3} = fieldnames(vec(:,[11 14]));

for i_idx = 1:3
    fieldnames_table{i_idx} = fieldnames_table{i_idx}(1:end-3);
    tabs_aux = uitab(h, 'title', tab_titles{i_idx});
    axes('parent', tabs_aux);
    for w = 1:length(fieldnames_table{i_idx})
        subplot(2,2,w)
        printing_imagesc(vec, fieldnames_table{i_idx}{w});
    end
end
%% Wrapping up, functions and return of variables
    function printing_imagesc(vec, fieldnames_table)
        % This function prepares the image with scaled color
        
        imagesc(vec.(fieldnames_table){:});
        colormap(gca, turbo(2048));
        pbaspect([1 1 1])
        
        ax = gca;
        ax.XLabel.String       = 'Alpha parameter (dB)';
        ax.XLabel.FontSize     = 10;
        ax.XLabel.FontWeight   = 'bold';
        ax.XTickLabel          = {num2str((vec.('Alpha (dB)'){:}),'%1.0f')};
        ax.XTick               = 1:length(vec.('Alpha (dB)'){:});
        ax.XTickLabelRotation  = 90;
        
        ax.YLabel.String       = 'Nuisance field weight (dB)';
        ax.YLabel.FontSize     = 10;
        ax.YLabel.FontWeight   = 'bold';
        ax.YTickLabel          = {num2str((vec.('Beta (dB)'){:}),'%1.0f')};
        ax.YTick               = 1:length(vec.('Beta (dB)'){:});
        ax.YTickLabelRotation  = 0;
        
        %%% Colorbar TickLabels
        cb = colorbar;
        colormap(cb, turbo(2048))
        T = linspace(cb.Limits(1), cb.Limits(2), 5); %% 5= five numbers in the colorbar
        cb.Ticks = T;
        if     contains(fieldnames_table, 'Total dose')
            TL = arrayfun(@(x) sprintf('%1.3e', x), T, 'un', 0);
        elseif contains(fieldnames_table, 'Maximum current (mA)')
            TL = arrayfun(@(x) sprintf('%1.3e', x), T, 'un', 0);
        elseif contains(fieldnames_table, 'Angle error (deg)')
            TL = arrayfun(@(x) sprintf('%3.3f', x), T, 'un', 0);
        elseif contains(fieldnames_table, 'Relative magnitude error')
            TL = arrayfun(@(x) sprintf('%1.3f', x), T, 'un', 0);
        else
            TL = arrayfun(@(x) sprintf('%1.3f', x), T, 'un', 0);
        end
        set(cb, 'TickLabels', TL);
        
        %%% Legend
        [sr, sc] = zef_ES_objective_function(vec);
        
        hold on;
        plot(ax, sc, sr, 'yp','MarkerFaceColor','y','MarkerEdgeColor','k','MarkerSize',12);
        plot(ax, sc, sr, 'yp','MarkerFaceColor','w','MarkerEdgeColor','w','MarkerSize',12);
        lgd = legend('Location','SouthWest', 'FontName', 'FixedWidth');
        lgd.String(1) = {['\alpha : ' num2str((vec.('Alpha (dB)'){:}(sc)), '%1.0f')]};
        lgd.String(2) = {['\epsilon : ' num2str((vec.('Beta (dB)'){:}(sr)), '%1.0f')]};
        lgd.AutoUpdate = 'off';
        plot(ax, sc, sr, 'yp','MarkerFaceColor','y','MarkerEdgeColor','k','MarkerSize',12);
        
        %%% Grid
        grid on
        ax.GridAlpha = 0.3;
        ax.GridColor = [0.3 0.3 0.3];
        
        hold off
        title(fieldnames_table);
    end
close(h_dial)
end