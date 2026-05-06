function zef_update_signal_parameters_table(zef, signalStruct)

    if isempty(signalStruct) || ...
       (isstruct(signalStruct) && isempty(fieldnames(signalStruct)))
        zef.h_source_tree.SignalParameters.Data = {};
        return;
    end

    rows = signalstruct_to_rows(signalStruct);
    zef.h_source_tree.SignalParameters.Data = rows;
end

function rows = signalstruct_to_rows(s)
    rows = {};

    f = fieldnames(s);
    for k = 1:numel(f)
        val = s.(f{k});
        if isNV(val)
            rows(end+1,:) = { ...
                char(val.Name), ...
                toTableScalar(val.Value) ...
            }; %#ok<AGROW>
        end
    end
end

function tf = isNV(x)
    tf = isstruct(x) && isfield(x,'Name') && isfield(x,'Value');
end

function out = toTableScalar(v)
    if isempty(v)
        out = '';
    elseif ischar(v)
        out = v;
    elseif isstring(v)
        out = char(v);
    elseif isnumeric(v) || islogical(v)
        if isscalar(v)
            out = v;
        else
            out = mat2str(v);
        end
    else
        out = '<unsupported>';
    end
end
