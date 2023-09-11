function str = zef_string_from_source_model(input)

% Converts a core.ZefSourceModel input into a character array.

switch input
    case core.ZefSourceModel.Error
        str = 'Error';
    case core.ZefSourceModel.Whitney
        str = 'Whitney';
    case core.ZefSourceModel.Hdiv
        str = 'H(div)'
    otherwise
        warning("Did not receive a valid core.ZefSourceModel. Returning Error.")
        str = 'Error';
end
end
