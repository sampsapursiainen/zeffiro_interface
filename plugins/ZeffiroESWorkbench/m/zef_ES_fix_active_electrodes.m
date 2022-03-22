function ES_active_electrodes = zef_ES_fix_active_electrodes
if not(evalin('base','zef.h_ES_fixed_active_electrodes.Value'))
    ES_active_electrodes = [];
else
    try
        [~, sr, sc] = zef_ES_objective_function;
    catch
        ES_active_electrodes = [];
        warning('y_ES not evaluated.')
        return
    end
    if isempty(sr)
        ES_active_electrodes = [];
    else
        y_ES_interval = evalin('base','zef.y_ES_interval');
        ES_active_electrodes = find(y_ES_interval.y_ES{sr,sc});
    end
end
