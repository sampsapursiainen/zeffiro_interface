if evalin('base','zef.ES_search_type') == 1
        zef.reconstruction = evalin('base','zef.y_ES_single.volumetric_current_density');
elseif evalin('base','zef.ES_search_type') >= 2
        rec_aux = evalin('base','zef.y_ES_interval.volumetric_current_density');
    [~,sr, sc] = zef_ES_objective_function;
    if isempty(sr)
        sr = 1;
    end
    if isempty(sc)
        sc = 1;
    end
    
    zef.reconstruction = rec_aux{sr, sc};
    clear rec_aux star_row_idx star_col_idx loader_aux
elseif evalin('base','zef.ES_search_type') == 3
    zef.reconstruction = evalin('base','zef.y_ES_interval.volumetric_current_density{1,1}');
end
try
    plot_meshes;
catch
    zef_visualize_surfaces;
end