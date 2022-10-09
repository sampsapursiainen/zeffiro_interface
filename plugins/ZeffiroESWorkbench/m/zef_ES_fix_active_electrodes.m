function ES_active_electrodes = zef_ES_fix_active_electrodes(zef)


if not(zef.h_ES_fixed_active_electrodes.Value)
    ES_active_electrodes = [];
else
    try
        [sr, sc] = zef_ES_objective_function(zef);
    catch
        ES_active_electrodes = [];
        return
    end
    
    if isempty(sr)
        ES_active_electrodes = [];
    else
        y_ES_interval = zef.y_ES_interval;
        %ES_active_electrodes = find(y_ES_interval.y_ES{sr,sc});
        
        [~,I] = maxk(abs(y_ES_interval.y_ES{sr,sc}), zef.ES_score_dose);
        ES_active_electrodes = sort(I);
    end
end
