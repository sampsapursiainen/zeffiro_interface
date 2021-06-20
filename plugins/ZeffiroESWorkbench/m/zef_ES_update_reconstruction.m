if evalin('base','zef.ES_search_type') == 1
    if not(evalin('base','zef.ES_current_threshold_checkbox'))
        zef.reconstruction = evalin('base','zef.y_ES_single.volumetric_current_density');
    else
        zef.reconstruction = evalin('base','zef.y_ES_single_threshold.volumetric_current_density');
    end
elseif evalin('base','zef.ES_search_type') >= 2
    if not(evalin('base','zef.ES_current_threshold_checkbox'))
        rec_aux = evalin('base','zef.y_ES_interval.volumetric_current_density');
    else
        rec_aux = evalin('base','zef.y_ES_interval_threshold.volumetric_current_density');
    end
    [star_row_idx, star_col_idx] = zef_ES_objective_function;
    if isempty(star_row_idx)
        star_row_idx = 1;
    end
    if isempty(star_col_idx)
        star_col_idx = 1;
    end
    zef.reconstruction = rec_aux{star_row_idx, star_col_idx};
    clear rec_aux star_row_idx star_col_idx loader_aux
elseif evalin('base','zef.ES_search_type') == 3
    zef.reconstruction = evalin('base','zef.y_ES_interval.volumetric_current_density{1,1}');
end

try
    plot_meshes;
catch
    zef_visualize_surfaces;
end