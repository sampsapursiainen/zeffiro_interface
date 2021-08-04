function ES_active_electrodes = zef_ES_fix_active_electrodes

if not(evalin('base','zef.h_ES_fixed_active_electrodes.Value'))

    ES_active_electrodes = [];

else
    
[var, a, b] = zef_ES_objective_function;

if isempty(a)
   
    ES_active_electrodes = [];
    
else

    y_ES_interval = evalin('base','zef.y_ES_interval');
    ES_active_electrodes = find(y_ES_interval.y_ES{a,b});
    
end

end
end