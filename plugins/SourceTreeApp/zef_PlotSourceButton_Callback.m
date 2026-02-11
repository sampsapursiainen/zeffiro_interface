function zef_PlotSourceButton_Callback(~, ~)

try
   treeObj = evalin('base','zef.h_source_tree.SourceTree');
catch
    error('PlotSourceButton: treeObj not found in base workspace.');
end

try
    h_axes = evalin('base','zef.h_axes1');
catch
    error('PlotSourceButton: zef.h_axes1 not found in base workspace.');
end

% -------------------------------------------------
% Call stem plotting routine
% -------------------------------------------------
zef_plot_selected_source_to_axes_stem(treeObj, h_axes, ...
    'DeletePrevious', true, ...
    'StoreHandleToZef', true, ...
    'Tag', 'additional: selected tree source');

end

