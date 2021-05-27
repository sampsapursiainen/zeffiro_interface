function zef_ES_plot_error_chart
%% Variables and parameters setup
if not(isfield(evalin('base','zef'),'y_ES_interval'))
    warning('There are no values calculated yet...')
    return
end
if evalin('base','zef.ES_current_threshold_checkbox') == 0
    load_aux = evalin('base','zef.y_ES_interval');
else
    try
        load_aux = evalin('base','zef.y_ES_interval_threshold');
    catch
        error('Attempting to plot threshold values that have not yet been calculated. Plotting original values instead.')
    end
end
loader = zef_ES_error_criteria;
title_aux = {'Total Dose (L_{1}-Norm)', 'Residual', 'Max Y_{ES}', 'Effective NNZ Currents', 'Local Relative Error', 'Local Relative Magnitude Error', 'Local Orientation Error'};
%% Figure and Axes
if isempty(findobj('type','figure','Name','ZEFFIRO Interface: Error chart tool'))
    f = figure('Name','ZEFFIRO Interface: Error chart tool','NumberTitle','off', ...
        'ToolBar','figure','MenuBar','none');
    %set(f,'Position',[1 1430 1300 1050]);

end
%% Tab #1 Properties
h = uitabgroup();
tab = uitab(h, 'title', 'Panel 1');
axes('parent', tab);

loader_aux = loader(1,1:4);
titles     = title_aux(1:4);

for w = 1:4
    sp_var = cell2mat(loader_aux{1,w});
    subplot(2,2,w)
    h_map = heatmap(num2str(load_aux.reg_param, '%1.1e'), num2str(load_aux.optimizer_tolerance, '%1.1e'), sp_var);
    
    title(char(titles(w)))
    printing;
    if w == 4
        set(h_map, 'CellLabelFormat', '%2.0f')
    else
        set(h_map, 'CellLabelFormat', '%1.3f')
    end
end
clear aux titles
%% Tab #2 Properties
% Tab #2star_row_idx
tab = uitab(h, 'title', 'Panel 2');
a = axes('parent', tab); %#ok<NASGU>
loader_aux = [loader(1,2) loader(1,5:end)];
titles = title_aux([2,5:7]);

for w = 1:4
    sp_var = cell2mat(loader_aux{1,w});
    subplot(2,2,w)
    
    h_map = heatmap(num2str(load_aux.reg_param, '%1.1e'), num2str(load_aux.optimizer_tolerance, '%1.1e'), sp_var);
    
    title(char(titles(w)))
    printing;
    if w == 4
        set(h_map, 'CellLabelFormat', '%2.0f')
    else
        set(h_map, 'CellLabelFormat', '%1.3f')
    end
end
%% Wrapping up, functions and return of variables
    function printing
        colormap('jet');
        set(h_map.NodeChildren(3), 'XTickLabelRotation', 90)
        xlabel('Regularization parameter');
        ylabel('Optimizer tolerance');
    end
end