function zef_ES_plot_error_chart
%% Variables and parameters setup
try
    load_aux = evalin('base','zef.y_ES_interval');
catch
    if not(isfield(evalin('base','zef'),'y_ES_interval'))
        error('There are no values calculated yet...')
    end
end
[loader, star_r, star_c] = zef_ES_objective_function;
titles = fieldnames(loader);
%% Figure and Axes
if isempty(findobj('type','figure','Name','ZEFFIRO Interface: Error chart tool'))
    f = figure('Name','ZEFFIRO Interface: Error chart tool','NumberTitle','off', ...
        'ToolBar','figure','MenuBar','none');
    %set(f,'Position',[1 1450 1435 1050]);
else
    f = findobj('type','figure','Name','ZEFFIRO Interface: Error chart tool');
    axes(f.CurrentAxes);
    clf(f.CurrentAxes);
end
% Original
f.PaperUnits = 'inches';
f.Units      = 'inches';
f.Renderer   = 'zbuffer';
f.Color      = [1 1 1];

h = uitabgroup();

% Tab #1 Properties
tab1 = uitab(h, 'title', 'Y_ES');
axes('parent', tab1);
loader_aux = loader(1,1:end);
titles_aux = titles(1:4);
for w = 1:4
   sp_var = cell2mat(loader_aux{1,w});
   % if w ~= 4
       printing_imagesc(w);
%     else
%        printing_heatmap(w);
%     end
end
%sgtitle('Y_{ES} and Objective Function')

%% Tab #2 Properties
tab2 = uitab(h, 'title', 'Volumetric');
axes('parent', tab2);
 loader_aux = loader(1, 5:end);
titles_aux = fieldnames(loader_aux);
for w = 1:4
     sp_var = cell2mat(loader_aux{1,w});
     printing_imagesc(w);
%     %printing_heatmap(w);
 end
% sgtitle('Current Angle and Magnitude differences')
%% Wrapping up, functions and return of variables
% h.Children(1).BackgroundColor = [1 1 1];
    function printing_imagesc(w)
        subplot(2,2,w)
        imagesc(sp_var(:,1:end));
        colormap('jet');
        pbaspect([1 1 1])
        %fnt_sz = 28;
        fnt_sz = 11;
        
      R = 1;
        
        ax = gca;
        ax.FontSize = fnt_sz;
        
        ax.XTick      = 1:R:length(load_aux.reg_param);
       
            ax.XTickLabel = (load_aux.reg_param(1:R:end));
       
        ax.XLabel.String = 'Regularization parameter';
        ax.XTickLabelRotation = 90;
        ax.XLabel.FontSize = fnt_sz;
        ax.XLabel.FontWeight = 'bold';
        ax.XLabel.FontName = 'Arial';
        
        ax.YTick      = 1:R:length(load_aux.optimizer_tolerance);

            ax.YTickLabel = (load_aux.optimizer_tolerance(1:R:end));

            if evalin('base','zef.ES_search_method')==1
        ax.YLabel.String = 'Optimizer tolerance';
            elseif evalin('base','zef.ES_search_method')==2
        ax.YLabel.String = 'k-value';
            end
        ax.YLabel.FontSize = fnt_sz;
        ax.YLabel.FontWeight = 'bold';
        ax.YLabel.FontName = 'Arial';
        
        cb                = colorbar; 
        %cb.Ruler.Exponent = -3;
        grid on;
        
        hold on;
%         for i = 1:length(load_aux.optimizer_tolerance)
%             for j = 1:length(load_aux.reg_param)
%                 plot(j,i,'ks','MarkerFaceColor','none','MarkerEdgeColor','k','MarkerSize',7);
%             end
%         end
        plot(star_c, star_r, 'yp','MarkerFaceColor','yellow','MarkerEdgeColor','k','MarkerSize',18);
        hold off;
%         axis equal
        title(titles_aux(w));
    end
    function printing_heatmap(w)
        subplot(2,2,w)
        h_map = heatmap(num2str(load_aux.reg_param, '%1.2e'), num2str(load_aux.optimizer_tolerance, '%1.2e'), sp_var);
        if load_aux.reg_param(1) == 1
            h_map.XData(1) = cellstr('1');
        end
        colormap('jet');
        set(h_map.NodeChildren(3), 'XTickLabelRotation', 90)
        xlabel('Regularization parameter');
        ylabel('Optimizer tolerance');
        title(titles_aux(w));
    end
end